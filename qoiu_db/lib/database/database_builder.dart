import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qoiu_utils/extensions/list_extensions.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'base_database_table.dart';

class DatabaseTableBuilder {
  final String? onCreate;
  final List<String> onUpdate;

  DatabaseTableBuilder({this.onCreate, this.onUpdate = const []});
}

class DatabaseBuilder<T extends Enum> {
  String path;
  String? _windowsPath;

  final List<String> _onCreate = [];
  final List<String> _onUpdate = [];
  final List<String> _drop = [];
  final List<DatabaseTableBuilder> _tables = [];
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

  DatabaseBuilder addTables(List<DatabaseTableBuilder> tables) {
    _tables.addAll(tables);
    return this;
  }

  DatabaseBuilder addTable(DatabaseTableBuilder table) {
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

  DatabaseBuilder windowsPath(String path) {
    _windowsPath = path;
    return this;
  }

  Future<String> _getWindowsPath() async {
    databaseFactory = databaseFactoryFfi;
    final documentsDirectory = await getApplicationDocumentsDirectory();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String projectName = packageInfo.appName;

    final path =
        _windowsPath?.let((e) => '${e.replaceAll('.db', '')}.db') ??
        '${documentsDirectory.path}\\$projectName\\${this.path.replaceAll('.db', '')}.db';
    return path;
  }

  Future<String> _getMobilePath() async {
    var simple = path.contains('/');
    var databasesPath = await getDatabasesPath();
    return simple ? path : '$databasesPath/${path.replaceAll('.db', '')}.db';
  }

  Future<Database> build() async {
    String path = Platform.isWindows
        ? await _getWindowsPath()
        : await _getMobilePath();
    Database database;
    for (var o in _tables) {
      o.onCreate?.let((e) => _onCreate.add(e));
      _onUpdate.addAll(o.onUpdate);
    }
    ['initDatabase', path].print();
    var version = _onUpdate.length + 1;
    ['dbVersion',version].print();
    if (_deleteDatabase) {
      await deleteDatabase(path);
      'database deleted'.dpRed().print();
    }
    if (Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
      database = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: version,
          onCreate: (Database db, int version) async {
            for (var entry in _onCreate) {
              await db.execute(entry);
            }
            for (var entry in _onUpdate) {
              await db.execute(entry);
            }
          },
          onUpgrade: (Database db, int oldVersion, int newVersion) async {
            ['db version','$oldVersion -> $newVersion'].print();
            await _onUpdate.indexedMapFuture((index, e) async {
              if (oldVersion < index ) {
                ['update', index].print();
                await db.execute(e);
              }
            });
          },
        ),
      );
    } else {
      database = await openDatabase(
        path,
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
          ['db version','$oldVersion -> $newVersion'].print();
          await _onUpdate.indexedMapFuture((index, e) async {
            if (oldVersion < index ) {
              ['update', index].print();
              await db.execute(e);
            }
          });
        },
      );
    }
    for (var o in _drop) {
      await database.execute('DROP TABLE $o');
    }
    ['initDatabase', 'complete'.dpGreen()].print();
    return database;
  }
}
