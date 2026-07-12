import 'package:flutter/foundation.dart';
import 'package:qoiu_db/database/db_entity.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDatabaseTable<T extends DbEntity> {
  late Database database;
  final String name;
  final T Function(JsonMap) fromDB;

  BaseDatabaseTable(
      {required this.name, required this.fromDB});

  /// Sql code called onCreate
  ///
  /// example
 ///
  /// ```dart
  /// @override
 /// String get onCreate => '''
 ///         CREATE TABLE IF NOT EXISTS task (
 ///   id INTEGER PRIMARY KEY,
 ///   title TEXT NOT NULL,
 ///   progress INTEGER,
 ///   duration INTEGER,
 ///   target INTEGER,
 ///   lvl INTEGER,
 ///   lvlPercent REAL,
 ///   extra TEXT
/// )
 ///         ''';
  ///         ```
  String? get onCreate=>null;
  Map<int,String> get onUpdate => {};

  List<String> _columnNames = [];

  @nonVirtual
  List<String> get columnNames=>_columnNames;

  initColumns() async {
    var results = await database.rawQuery("PRAGMA table_info('$name')");
    _columnNames = results.map((e) => e['name'] as String).toList();
  }



  ///@param where - "WHERE date='$day'"
  Future<List<T>> getAll([String where='']) async {
    var response = await database.rawQuery("SELECT*FROM $name $where");
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result;
  }

  ///@param id - "WHERE id='$id'"
  Future<T?> getById(int id) async {
    var response = await database.rawQuery("SELECT*FROM $name WHERE id='$id'");
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result.firstOrNull;
  }

  Future<int> add(DbEntity item) async {
    return await database.insert(name, item.toDB());
  }

  Future<T> addAndUse(DbEntity item) async {
    var id = await add(item);
    return (await getById(id))!;
  }

  Future update(DbEntity task) async {
    database.update(
      name,
      task.toDB(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> delete(int id) async {
    await database.delete(
      name,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
