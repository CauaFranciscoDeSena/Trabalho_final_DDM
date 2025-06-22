import 'package:flutter/material.dart';
import 'package:jogo/models/infos_carta.dart'; // Importa o modelo de dados da carta

// Widget que representa uma única carta
class LadosDaCarta extends StatelessWidget {
  final InfosDaCarta carta;

  const LadosDaCarta({super.key, required this.carta});

  @override
  Widget build(BuildContext context) {
    // Se a carta for combinada, mostre-a como esmaecida
    if (carta.estaCombinada) {
      return Opacity(
        opacity: 0.4,
        child: Card(
          color: Colors.grey[600], // Cartas combinadas são mais escuras
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              carta.conteudo,
              style: const TextStyle(fontSize: 48, color: Colors.white70),
            ),
          ),
        ),
      );
    }

    // Frente ou Verso da carta com base em `estaVirada`
    return Card(
      color: carta.estaVirada ? const Color(0xFF9b59b6) : const Color(0xFF6c5ce7), // Diferentes tons de roxo
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Center(
        child: carta.estaVirada
            ? Transform( // <--- ADICIONADO: Novo Transform para corrigir o espelhamento
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // Espelha horizontalmente
                child: Image.asset( // Usar Image.asset para exibir a imagem
                  carta.conteudo,
                  width: 160, // Ajuste o tamanho da imagem
                  height: 160, // Ajuste o tamanho da imagem
                ),
              )
            : const Text(
                '❓', // Ponto de interrogação para carta virada para baixo
                style: TextStyle(fontSize: 48, color: Color(0xFFffeaa7)), // Amarelo claro
              ),
      ),
    );
  }
}
