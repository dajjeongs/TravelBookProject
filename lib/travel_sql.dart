
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_book/travel_data.dart';

class DatabaseService {
  static final DatabaseService _database = DatabaseService._internal();
  late Future<Database> database;

  factory DatabaseService() => _database;

  DatabaseService._internal() {
    databaseConfig();
  }


  Future<bool> databaseConfig() async {
    try {
      database = openDatabase(
        join(await getDatabasesPath(), 'travel_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE travels(id INTEGER PRIMARY KEY, name TEXT, start TEXT, end TEXT)',
          );
        },
        version: 1,
      );
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<bool> insertTravel(Travel travel) async {
    final Database db = await database;
    try {
      db.insert(
        // 테이블 이름
        'travels',
        travel.toMap(),
        // 데이터 충돌이 날 경우, 어떻게 할 것인가
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<int> getDatabaseRowCount() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('travels');

    return data.length;
  }

  Future<List<Travel>> selectTravels() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('travels');

    return List.generate(data.length, (i) {
      return Travel(
        id: data[i]['id'],
        name: data[i]['name'],
      );
    });
  }

  Future<Travel> selectTravel(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> data =
    await db.query('travels', where: "id = ?", whereArgs: [id]);
    return Travel(
        id: data[0]['id'],
        name: data[0]['name'],
    );
  }

  Future<bool> updateTravel(Travel travel) async {
    final Database db = await database;
    try {
      db.update(
        'travels',
        travel.toMap(),
        where: "id = ?",
        whereArgs: [travel.id],
      );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> deleteTravel(int id) async {
    final Database db = await database;
    try {
      db.delete(
        'travels',
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (err) {
      return false;
    }
  }
}