import '../models/empleado_model.dart';
import '../settings/db_connection.dart';

class EmpleadoRepository {
  static String tableName = "empleados";

  static Future<int> insert(Empleado empleado) async {
    return await DbConnection.insert(tableName, empleado.toMap());
  }

  static Future<int> update(Empleado empleado) async {
    return await DbConnection.update(tableName, empleado.toMap(), empleado.id!);
  }

  static Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  static Future<List<Empleado>> list() async {
    final data = await DbConnection.list(tableName);
    return data.map((e) => Empleado.fromMap(e)).toList();
  }

  static Future<Empleado?> findById(int id) async {
    final data = await DbConnection.filter(tableName, 'id = ?', [id]);
    if (data.isNotEmpty) {
      return Empleado.fromMap(data.first);
    }
    return null;
  }
}
