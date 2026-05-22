import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDatabaseTable<T> {
  final Database database;
  final String name;
  final T Function(JsonMap) fromDB;

  BaseDatabaseTable(
      {required this.database, required this.name, required this.fromDB});

  ///@param where - "WHERE date='$day'"
  Future<List<T>> getWhere(String where) async {
    var response = await database.rawQuery("SELECT*FROM $name $where");
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result;
  }

  Future<List<T>> getAll() async {
    var response = await database.rawQuery("SELECT*FROM $name");
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result;
  }

  ///@param where - "WHERE date='$day'"
  Future<T?> getById(int id) async {
    var response = await database.rawQuery("SELECT*FROM $name WHERE id='$id'");
    var result = response.map((e) {
      return fromDB(e);
    }).toList();
    return result.firstOrNull;
  }

  Future<int> add(JsonMap item) async {
    return await database.insert(name, item);
  }

  Future<T> addAndUse(JsonMap item) async {
    var id = await add(item);
    return (await getById(id))!;
  }

  Future update(JsonMap task, int id) async {
    database.update(
      name,
      task,
      where: 'id = ?',
      whereArgs: [id],
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
