import 'package:flutter/material.dart';
import 'package:jogo/models/infos_carta.dart';
import 'dart:math';
import 'package:jogo/widgets/lados-carta.dart'; // Para embaralhamento aleatório

class PaginaJogoMemoria extends StatefulWidget {
  const PaginaJogoMemoria({super.key});

  @override
  State<PaginaJogoMemoria> createState() => _EstadoPaginaJogoMemoria();
}

class _EstadoPaginaJogoMemoria extends State<PaginaJogoMemoria> {
  // Lista de conteúdos possíveis para as cartas (emojis)
  final List<String> _conteudoCartas = [
    'lib/imgs/flamengo.png',
    'lib/imgs/sao_paulo.png',
    'lib/imgs/palmeiras.png',
    'lib/imgs/corinthians.png',
    'lib/imgs/atletico_mineiro.png',
    'lib/imgs/cruzeiro.png',
    'lib/imgs/gremio.png',
    'lib/imgs/internacional.png',
    'lib/imgs/santos.png', 
    'lib/imgs/vasco.png',
  ];

  late List<InfosDaCarta> _cartas; // Lista de todas as cartas no jogo
  List<int> _indicesCartasViradas = []; // Índices das cartas atualmente viradas (máximo 2)
  int _turnos = 0; // Número de turnos jogados
  bool _jogoAtivo = true; // Impede cliques durante o atraso de avaliação da carta
  bool _jogoAcabou = false; // Indica se o jogo terminou

  @override
  void initState() {
    super.initState();
    _inicializarJogo(); // Inicializa o jogo quando o widget é criado
  }

  // Inicializa ou reinicia o jogo
  void _inicializarJogo() {
    final List<String> conteudoEmbaralhado = [
      ..._conteudoCartas,
      ..._conteudoCartas
    ]..shuffle(Random()); // Duplica e embaralha os conteúdos

    setState(() {
      _cartas = List.generate(conteudoEmbaralhado.length, (index) {
        return InfosDaCarta(
          id: index,
          conteudo: conteudoEmbaralhado[index],
          estaVirada: false,
          estaCombinada: false,
        );
      });
      _indicesCartasViradas = [];
      _turnos = 0;
      _jogoAtivo = true;
      _jogoAcabou = false;
    });
  }

  // Manipula o evento de toque na carta
  void _manipularToqueCarta(int index) {
    // Se o jogo não estiver ativo, ou a carta já estiver virada/combinada, ou duas cartas já estiverem viradas, retorne
    if (!_jogoAtivo ||
        _cartas[index].estaVirada ||
        _cartas[index].estaCombinada ||
        _indicesCartasViradas.length == 2) {
      return;
    }

    setState(() {
      _cartas[index].estaVirada = true; // Vira a carta clicada
      _indicesCartasViradas.add(index); // Adiciona seu índice à lista de viradas
    });

    // Se duas cartas estiverem viradas, avalie-as
    if (_indicesCartasViradas.length == 2) {
      _jogoAtivo = false; // Desabilita outros cliques
      _turnos++; // Incrementa a contagem de turnos

      final InfosDaCarta carta1 = _cartas[_indicesCartasViradas[0]];
      final InfosDaCarta carta2 = _cartas[_indicesCartasViradas[1]];

      if (carta1.conteudo == carta2.conteudo) {
        // Se o conteúdo combinar, marque-as como combinadas
        setState(() {
          _cartas[_indicesCartasViradas[0]].estaCombinada = true;
          _cartas[_indicesCartasViradas[1]].estaCombinada = true;
          _indicesCartasViradas.clear(); // Limpa as cartas viradas
        });
        _jogoAtivo = true; // Reabilita cliques
        _verificarFimDeJogo(); // Verifica se todas as cartas foram combinadas
      } else {
        // Se o conteúdo não combinar, vire-as de volta após um atraso
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _cartas[_indicesCartasViradas[0]].estaVirada = false;
            _cartas[_indicesCartasViradas[1]].estaVirada = false;
            _indicesCartasViradas.clear(); // Limpa as cartas viradas
          });
          _jogoAtivo = true; // Reabilita cliques
        });
      }
    }
  }

  // Verifica se todas as cartas foram combinadas
  void _verificarFimDeJogo() {
    if (_cartas.every((carta) => carta.estaCombinada)) {
      setState(() {
        _jogoAcabou = true;
        _jogoAtivo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradiente de fundo para apelo visual
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8e44ad), // Roxo Escuro
              Color(0xFF3498db), // Azul Brilhante
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Título do Jogo
                const Text(
                  'Jogo da Memória',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Contador de Turnos e Mensagem de Fim de Jogo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Turnos: $_turnos',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (_jogoAcabou)
                      const Text(
                        '🎉 Você Ganhou!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFffee58), // Destaque Amarelo
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black45,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                // Grade de cartas
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10, 
                      crossAxisSpacing: 10.0, // Espaço horizontal entre as cartas
                      mainAxisSpacing: 10.0, // Espaço vertical entre as cartas
                      childAspectRatio: 0.8, // Cartas ligeiramente mais altas
                    ),
                    itemCount: _cartas.length,
                    itemBuilder: (context, index) {
                      final carta = _cartas[index];
                      return GestureDetector(
                        onTap: () => _manipularToqueCarta(index),
                        child: Transform(
                          alignment: FractionalOffset.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateY(carta.estaVirada ? pi : 0),
                          child: LadosDaCarta(carta: carta),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Botão Reiniciar Jogo
                ElevatedButton(
                  onPressed: _inicializarJogo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Cor de fundo do botão
                    foregroundColor: Colors.white, // Cor do texto do botão
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Cantos arredondados
                    ),
                    elevation: 5, // Sombra
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Reiniciar Jogo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
