class InfosDaCarta {
  final int id;
  final String conteudo;
  bool estaVirada;
  bool estaCombinada;

  InfosDaCarta({
    required this.id,
    required this.conteudo,
    this.estaVirada = false,
    this.estaCombinada = false,
  });

  // Método auxiliar para criar uma cópia com propriedades atualizadas
  InfosDaCarta propsAtualizadas({bool? estaVirada, bool? estaCombinada}) {
    return InfosDaCarta(
      id: id,
      conteudo: conteudo,
      estaVirada: estaVirada ?? this.estaVirada,
      estaCombinada: estaCombinada ?? this.estaCombinada,
    );
  }
}
