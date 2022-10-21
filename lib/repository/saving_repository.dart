import 'package:financas_pessoais/database/database_manager.dart';
import '../models/savings.dart';

class SavingRepository {
  Future<List<Saving>> listarSavings() async {
    final db = await DatabaseManager().getDatabase();
    final List<Map<String, dynamic>> rows = await db.rawQuery('''
          SELECT 
            savings.id,
            savings.nome, 
            savings.descricao,
            savings.valorAtual,
            savings.valorFinal,  
            savings.data
          FROM savings
''');
    return rows
        .map(
          (row) => Saving(
            id: row['id'],
            nome: row['nome'],
            descricao: row['descricao'],
            valorAtual: row['valorAtual'],
            valorFinal: row['valorFinal'],
            data: DateTime.fromMillisecondsSinceEpoch(row['data']),
          ),
        )
        .toList();
  }

  Future<void> cadastrarSaving(Saving saving) async {
    final db = await DatabaseManager().getDatabase();

    db.insert("savings", {
      "id": saving.id,
      "nome": saving.nome,
      "descricao": saving.descricao,
      "valorAtual": saving.valorAtual,
      "valorFinal": saving.valorFinal,
      "data": saving.data.millisecondsSinceEpoch,
    });
  }

  Future<void> removerSaving(int id) async {
    final db = await DatabaseManager().getDatabase();
    await db.delete(
        'savings',
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future<int> editarSaving(Saving saving) async {
    final db = await DatabaseManager().getDatabase();
    return db.update(
        'savings',
        {
          "nome": saving.nome,
          "id": saving.id,
          "descricao": saving.descricao,
          "valorAtual": saving.valorAtual,
          "valorFinal": saving.valorFinal,
          "data": saving.data.millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [saving.id]);
  }
}
