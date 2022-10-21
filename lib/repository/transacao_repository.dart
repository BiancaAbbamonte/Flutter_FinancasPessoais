import 'package:financas_pessoais/database/database_manager.dart';
import 'package:financas_pessoais/models/tipo_lancamento.dart';
import 'package:financas_pessoais/models/transacao.dart';

import '../models/categorial.dart';

class TransacaoRepository {
  Future<List<Transacao>> listarTransacoes() async {
    final db = await DatabaseManager().getDatabase();
    final List<Map<String, dynamic>> rows = await db.rawQuery('''
          SELECT 
            transacoes.id, 
            transacoes.descricao,
            transacoes.tipoTransacao,
            transacoes.valor, 
            transacoes.categoriaId, 
            transacoes.data,
            transacoes.observacao, 
            categorias.categoriaDescricao,
            categorias.categoriaCor,
            categorias.categoriaIcone,
            categorias.categoriaTipoTransacao
          FROM transacoes
    INNER JOIN categorias ON categorias.id = transacoes.categoriaId
''');
    return rows
        .map(
          (row) => Transacao(
            id: row['id'],
            descricao: row['descricao'],
            tipoTransacao: TipoTransacao.values[row['tipoTransacao']],
            valor: row['valor'],
            data: DateTime.fromMillisecondsSinceEpoch(row['data']),
            observacao: row['observacao'],
            categoria: Categoria(
                id: row['categoriaId'],
                categoriaCor: row['categoriaCor'],
                categoriaDescricao: row['categoriaDescricao'],
                categoriaIcone: row['categoriaIcone'],
                categoriaTipoTransacao:
                    TipoTransacao.values[row['categoriaTipoTransacao']]),
          ),
        )
        .toList();
  }

  Future<void> cadastrarTransacao(Transacao transacao) async {
    final db = await DatabaseManager().getDatabase();

    db.insert("transacoes", {
      "id": transacao.id,
      "descricao": transacao.descricao,
      "tipoTransacao": transacao.tipoTransacao.index,
      "valor": transacao.valor,
      "data": transacao.data.millisecondsSinceEpoch,
      "observacao": transacao.observacao,
      "categoriaId": transacao.categoria.id,
    });
  }

  Future<void> removerLancamento(int id) async {
    final db = await DatabaseManager().getDatabase();
    await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> editarTransacao(Transacao transacao) async {
    final db = await DatabaseManager().getDatabase();
    return db.update(
        'transacoes',
        {
          "id": transacao.id,
          "descricao": transacao.descricao,
          "tipoTransacao": transacao.tipoTransacao.index,
          "valor": transacao.valor,
          "data": transacao.data.millisecondsSinceEpoch,
          "observacao": transacao.observacao,
          "categoriaId": transacao.categoria.id,
        },
        where: 'id = ?',
        whereArgs: [transacao.id]);
  }
}
