import '../models/pedidos_model.dart';
import '../settings/db_connection.dart';

class PedidosRepository {
  static String tableName = "pedidos";

  // Insertar un nuevo pedido
  static Future<int> insert(BreakfastOrder order) async {
    return await DbConnection.insert(tableName, order.toMap());
  }

  // Actualizar un pedido existente
  static Future<int> update(BreakfastOrder order) async {
    return await DbConnection.update(tableName, order.toMap(), order.id as int);
  }

  // Eliminar un pedido
  static Future<int> delete(BreakfastOrder order) async {
    return await DbConnection.delete(tableName, order.id as int);
  }

  // Listar todos los pedidos
  static Future<List<BreakfastOrder>> list() async {
    var result = await DbConnection.list(tableName);
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => BreakfastOrder.fromMap(result[index]),
      );
    }
  }
}
