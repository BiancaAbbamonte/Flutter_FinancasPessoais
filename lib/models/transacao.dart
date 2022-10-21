import 'package:financas_pessoais/models/categorial.dart';
import 'package:financas_pessoais/models/tipo_lancamento.dart';

class Transacao {
  int? id;
  String descricao;
  TipoTransacao tipoTransacao;
  double valor;
  DateTime data;
  Categoria categoria;
  String observacao;

  Transacao({
    this.id,
    required this.descricao,
    required this.tipoTransacao,
    required this.valor,
    required this.data,
    required this.categoria,
    this.observacao = '',
  });
}
