import '../models/categoria_model.dart';
import '../settings/db_connection.dart';

class CategoriaRepository {
  static String tableName = "categoria";

  static Future<int> insert(Categoria categoria) async {
    return await DbConnection.insert(tableName, categoria.toMap());
  }

  static Future<int> update(Categoria categoria) async {
    return await DbConnection.update(
      tableName,
      categoria.toMap(),
      categoria.id!,
    );
  }

  static Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  static Future<List<Categoria>> list() async {
    final data = await DbConnection.list(tableName);
    return data.map((e) => Categoria.fromMap(e)).toList();
  }

  static Future<Categoria?> findById(int id) async {
    final data = await DbConnection.filter(tableName, 'id = ?', [id]);
    if (data.isNotEmpty) {
      return Categoria.fromMap(data.first);
    }
    return null;
  }
}
