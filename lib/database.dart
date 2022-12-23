import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'worker.dart';
import 'package:flutter/widgets.dart';

class WorkersDatabase {
  static final WorkersDatabase instance = WorkersDatabase._init();

  static Database? _database;
  WorkersDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('workers.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY';
    final integerType = 'INTEGER';
    final textType = 'TEXT';

    await db.execute('''
CREATE TABLE $tableWorkers (
      ${WorkerFields.id} $idType,
      ${WorkerFields.name} $textType,
      ${WorkerFields.place} $textType,
      ${WorkerFields.a} $integerType,
      ${WorkerFields.b} $integerType,
      ${WorkerFields.c} $integerType
      )
      ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Worker> create(Worker worker) async {
    final db = await instance.database;
    //final Worker worker = Worker(place: place, name: name, a: a, b: b, c: c);
    final id = await db.insert(tableWorkers, worker.toJson());
    return worker.copy(id: id);
  }

  Future<Worker> readWorker(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableWorkers,
        columns: WorkerFields.values,
        where: '${WorkerFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Worker.fromJson(maps.first);
    } else {
      throw Exception('ID is not found');
    }
  }

  Future<List<Worker>> readAllWorkers() async {
    final db = await instance.database;
    final orderBy = '${WorkerFields.name} ASC';
    final result = await db.query(tableWorkers, orderBy: orderBy);

    return result.map((json) => Worker.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableWorkers,
      where: '${WorkerFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Worker worker) async {
    final db = await instance.database;

    return db.update(
      tableWorkers,
      worker.toJson(),
      where: '${WorkerFields.id} = ?',
      whereArgs: [worker.id],
    );
  }
}
