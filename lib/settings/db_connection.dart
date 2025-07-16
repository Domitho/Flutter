import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbConnection {
  static const version = 1;
  static const dbName = "gestion_desayunos.db";

  static Future<Database> getDb() async {
    final dbPath = join(await getDatabasesPath(), dbName);

    return openDatabase(
      dbPath,
      onCreate: (db, version) async {
        // Crear tabla breakfast
        await db.execute(
          'CREATE TABLE breakfast('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'description TEXT, '
          'code TEXT, '
          'price NUMERIC, '
          'stock INT, '
          'imageUrl TEXT)',
        );

        // Crear tabla pedidos
        await db.execute(
          'CREATE TABLE pedidos('
          'id INTEGER PRIMARY KEY, '
          'customerName TEXT, '
          'breakfast TEXT, '
          'quantity INT, '
          'totalPrice INT, '
          'orderDate TEXT, '
          'status TEXT)',
        );

        // Datos iniciales
        await db.execute(
          "INSERT INTO breakfast(name, description, code, price, stock, imageUrl) "
          "VALUES('Desayuno Inicial', 'Primer desayuno registrado', '001', 0, 0, '')",
        );
      },
      version: version,
    );
  }

  static Future<int> insert(String tableName, dynamic data) async {
    final db = await getDb();
    return db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(String tableName, dynamic data, int id) async {
    final db = await getDb();
    return db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> delete(String tableName, int id) async {
    final db = await getDb();
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> list(String tablename) async {
    final db = await getDb();
    return db.query(tablename);
  }

  static Future<List<Map<String, dynamic>>> filter(
    String tablename,
    String where,
    dynamic whereArgs,
  ) async {
    final db = await getDb();
    return db.query(tablename, where: where, whereArgs: whereArgs);
  }
}
