import 'package:qoiu_utils/extensions/list_extensions.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:sqflite/sqflite.dart';

import 'base_database_table.dart';

class DatabaseBuilder<T extends Enum> {
  String path;

  final List<String> _onCreate = [];
  final List<String> _onUpdate = [];
  final List<String> _drop = [];
  final List<BaseDatabaseTable> _tables = [];
  bool _deleteDatabase = false;

  DatabaseBuilder(this.path);

  DatabaseBuilder addOnCreateList(List<String> execute) {
    _onCreate.addAll(execute);
    return this;
  }

  DatabaseBuilder addOnCreate(String execute) {
    _onCreate.add(execute);
    return this;
  }

  DatabaseBuilder addTables(List<BaseDatabaseTable> tables) {
    _tables.addAll(tables);
    return this;
  }

  DatabaseBuilder addTable(BaseDatabaseTable table) {
    _tables.add(table);
    return this;
  }

  DatabaseBuilder addOnUpdateList(List<String> execute) {
    _onUpdate.addAll(execute);
    return this;
  }

  DatabaseBuilder addOnUpdate(String execute) {
    _onUpdate.add(execute);
    return this;
  }

  DatabaseBuilder deleteOnStart() {
    _deleteDatabase = true;
    return this;
  }

  Future<Database> build() async {
    var simple = path.contains('/');
    var databasesPath = await getDatabasesPath();
    String fPath = simple?path : '$databasesPath/$path';
    ['initDatabase',path].print();
    var version = _onUpdate.length + 1;
    if (_deleteDatabase) {
      await deleteDatabase(fPath);
    }
    var database = await openDatabase(
      fPath,
      version: version,
      onCreate: (Database db, int version) async {
        for (var entry in _onUpdate) {
          await db.execute(entry);
        }
        for (var entry in _onUpdate) {
          await db.execute(entry);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await _onUpdate.indexedMapFuture((index, e) async {
          if (oldVersion < index + 1) {
            await db.execute(e);
          }
        });
      },
    );
    for (var o in _drop) {
      await database.execute('DROP TABLE $o');
    }
    return database;
  }
}
