import '../models/inventario_model.dart';
import '../settings/db_connection.dart';

class BreakfastRepository {
  static String tableName = "breakfast";

  // Insertar un nuevo desayuno
  static Future<int> insert(Breakfast breakfast) async {
    return await DbConnection.insert(tableName, breakfast.toMap());
  }

  // Actualizar un desayuno existente
  static Future<int> update(Breakfast breakfast) async {
    return await DbConnection.update(
      tableName,
      breakfast.toMap(),
      breakfast.id as int,
    );
  }

  // Eliminar un desayuno
  static Future<int> delete(Breakfast breakfast) async {
    return await DbConnection.delete(tableName, breakfast.id as int);
  }

  // Listar todos los desayunos
  static Future<List<Breakfast>> list() async {
    var result = await DbConnection.list(tableName);
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) =>
            Breakfast.fromMap(result[index]), // Convertir de Map a Breakfast
      );
    }
  }
}
