import 'package:flutter/material.dart';
import 'package:jogo/pages/pagina_jogo.dart';

void main() {
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Memória',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // Fonte personalizada
      ),
      home: const PaginaJogoMemoria(),
    );
  }
}
