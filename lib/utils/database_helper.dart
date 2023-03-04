import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username TEXT,
        password TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'user.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createUser(String username, String? password) async {
    final db = await SQLHelper.db();

    final data = {'username': username, 'password': password};
    final id = await db.insert('users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query('users', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getUser(
      String username, String password) async {
    final db = await SQLHelper.db();
    return db.query('users',
        where: "username = ? AND password = ? ",
        whereArgs: [username, password],
        limit: 5);
  }
}

class SQlMap {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE maps(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user REAL,
        latitude REAL,
        longitude REAL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'map.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createCoordinates(
      dynamic user, dynamic latitude, dynamic longitude) async {
    final db = await SQlMap.db();
    final data = {'user': user, 'latitude': latitude, 'longitude': longitude};
    final id = await db.insert('maps', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
  static Future<List<Map<String, dynamic>>> getCoordinate(int id) async {
    final db = await SQlMap.db();
    return db.query('maps', where: "id = ?", whereArgs: [id], limit: 5);
  }

  static Future<List<Map<String, dynamic>>> getCoordinates(dynamic user) async {
    final db = await SQlMap.db();
    return db.query('maps', where: "user = ?", whereArgs: [user], limit: 50);
  }
}
