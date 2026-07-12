import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'base_database_table.dart';

/// An abstract class for quick database creation.
///
/// > Don't forget to call await DB.main.init();
///
/// Example of usage and class structure:
/// ```dart
/// abstract class DB {
///   static MainDatabase main = MainDatabase();
///   static TaskQueries tasks = TaskQueries();
///   static SkillQueries skills = SkillQueries();
///   static LogsQueries logs = LogsQueries();
/// }
///
/// class MainDatabase extends IDatabase {
///   @override
///   String get databaseName => 'tasks';
///
///   @override
///   List<BaseDatabaseTable> get tables => [DB.tasks, DB.logs, DB.skills];
/// }
/// ```
abstract class DatabaseInterface {
  ///  Simple database name like: 'tasks'
  ///
  /// > 'database.db' - default name,
  @nonVirtual
  String databaseName;

  @nonVirtual
  int databaseVersion ;

  DatabaseInterface({this.databaseName = 'database', this.databaseVersion = 1});
  ///  Special path for windows if you want something like
  ///  ```dart
  ///
  ///  Future<String?> get windowsPath async {
  ///    var windowsPath = await getApplicationDocumentsDirectory();
  ///    return'${windowsPath.path}\\myUser\\myProject\\$databaseName.db';
  ///  }
  ///  @override
  ///   String get databaseName => 'tasks';
  Future<String?> get windowsPath async {
    var windowsPath = await getApplicationDocumentsDirectory();
    return '${windowsPath.path}\\qoiu\\guild_game\\$databaseName.db';
  }

  late Database _database;

  ///here you can get database
  @nonVirtual
  Database get database => _database;

  ///Extra function
  List<String> get onCreate => [];

  Map<int,String> _onUpdate = {};
  ///Name of tables to drop
  ///
  /// ```SQL
  /// DROP TABLE IF EXISTS $name
  /// ```
  List<String> get drop => [];

  ///List of tables in database
  List<BaseDatabaseTable> get tables => [];
  bool _deleteDatabase = false;

  Future<String> _getWindowsPath() async {
    databaseFactory = databaseFactoryFfi;
    final documentsDirectory = await getApplicationDocumentsDirectory();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String projectName = packageInfo.appName;

    final path = (await windowsPath)?.let((e) => '${e.replaceAll('.db', '')}.db') ??
        '${documentsDirectory.path}\\$projectName\\${databaseName.replaceAll('.db', '')}.db';
    return path;
  }

  FutureOr<void> onOpen(Database database) async{}

  Future<String> get databasesPath async => await getDatabasesPath();

  Future<String> _getMobilePath() async {
    var simple = databaseName.contains('/');
    var path = await databasesPath;
    return simple
        ? databaseName
        : '$path/${databaseName.replaceAll('.db', '')}.db';
  }

  Future<Database> init() async {
    String path =
        Platform.isWindows ? await _getWindowsPath() : await _getMobilePath();
    for (var table in tables) {
      table.onCreate?.let((e) => onCreate.add(e));
      ['${table.name} - onUpdate', table.onUpdate.length].print();
      ['${table.name} - onUpdate', table.onUpdate].print();
      _onUpdate.addAll(table.onUpdate);
    }
    ['onUpdate', _onUpdate].print();
    ['onUpdate', _onUpdate.length].print();
    ['initDatabase', path].print();
    var version = databaseVersion;
    ['dbVersion', version].print();
    if (_deleteDatabase) {
      await deleteDatabase(path);
      'database deleted'.dpRed().print();
    }
    if (Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
      _database = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: version,
          onOpen: onOpen,
          onCreate: _onCreateMethod,
          onUpgrade: _onUpgradeMethod,
        ),
      );
    } else {
      _database = await openDatabase(
        path,
        version: version,
        onOpen: onOpen,
        onCreate: _onCreateMethod,
        onUpgrade: _onUpgradeMethod,
      );
    }
    for (var table in tables) {
      table.database = _database;
      table.initColumns();
    }
    ['initDatabase', 'complete'.dpGreen()].print();
    return _database;
  }

  FutureOr<void> _onCreateMethod(Database db, int version) async {
        for (var entry in onCreate) {
          await db.execute(entry);
        }
        // for (var entry in _onUpdate.entries) {
        //   await db.execute(entry);
        // }
      }

  FutureOr<void> _onUpgradeMethod(Database db, int oldVersion, int newVersion) async {
      ['db version', '$oldVersion -> $newVersion'].print();
      for (var entry in _onUpdate.entries) {
        if(oldVersion<entry.key){
          await db.execute(entry.value);
        }
      }
    }
}
