class Saving {
  int? id;
  String nome;
  String descricao;
  double valorAtual;
  double valorFinal;
  DateTime data;

  Saving({
    this.id,
    required this.nome,
    required this.descricao,
    required this.valorAtual,
    required this.valorFinal,
    required this.data,
  });
}
