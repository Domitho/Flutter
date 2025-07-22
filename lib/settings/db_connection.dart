import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbConnection {
  static const version = 1;
  static const dbName = "gestion_desayunos.db";

  static Future<Database> getDb() async {
    final dbPath = join(await getDatabasesPath(), dbName);

    //await deleteDatabase(dbPath);

    return openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categoria (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            descripcion TEXT,
            created_at TEXT
          )
        ''');

        // Crear tabla breakfast
        await db.execute('''
          CREATE TABLE breakfast (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            code TEXT,
            price NUMERIC,
            stock INT,
            imageUrl TEXT,
            categoria_id INTEGER,
            FOREIGN KEY (categoria_id) REFERENCES categoria(id)
          )
        ''');

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

        await db.execute(
          'CREATE TABLE usuarios('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nombre TEXT, '
          'email TEXT UNIQUE, '
          'password TEXT)',
        );

        await db.execute('''
          CREATE TABLE empleados (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            rol TEXT NOT NULL,
            telefono TEXT,
            email TEXT
          )
        ''');

        final now = DateTime.now().toIso8601String();

        final categoriaId = await db.insert('categoria', {
          'nombre': 'Sin categoría',
          'descripcion': 'Categoría por defecto',
          'created_at': now,
        });

        // Usuario por defecto
        await db.insert('usuarios', {
          'nombre': 'admin',
          'email': 'admin@demo.com',
          'password': '1234', // Considera cifrar en el futuro
        });

        // Datos iniciales
        await db.insert('breakfast', {
          'name': 'Desayuno Inicial',
          'description': 'Primer desayuno registrado',
          'code': '001',
          'price': 0,
          'stock': 0,
          'imageUrl': '',
          'categoria_id': categoriaId,
        });
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
