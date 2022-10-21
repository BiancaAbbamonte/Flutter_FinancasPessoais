import 'package:financas_pessoais/database/database_manager.dart';
import 'package:financas_pessoais/models/categorial.dart';
import 'package:financas_pessoais/models/tipo_lancamento.dart';

class CategoriaRepository {
  Future<List<Categoria>> listarCategorias() async {
    final db = await DatabaseManager().getDatabase();

    // Listar Categorias do Banco de dados
    // Retorna uma Lista de Map (chave/valor)
    // onde a chave é o nome da coluna no banco de dados
    final List<Map<String, dynamic>> rows = await db.query('categorias');

    // Mapear a lista de <Map> para uma lista de <Categoria>
    return rows
        .map(
          (row) => Categoria(
              id: row['id'],
              categoriaDescricao: row['categoriaDescricao'],
              categoriaCor: row['categoriaCor'],
              categoriaIcone: row['categoriaIcone'],
              categoriaTipoTransacao:
                  TipoTransacao.values[row['categoriaTipoTransacao']]),
        )
        .toList();
  }
}
