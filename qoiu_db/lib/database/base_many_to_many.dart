import 'dart:async';

import 'package:qoiu_db/qoiu_db.dart';
import 'package:qoiu_utils/qoiu_utils_export.dart';

abstract class BaseManyToMany<T1, T2> extends DatabaseCreateTableInterface{

  // Эти поля описывают структуру, они нужны для генерации SQL и запросов
  final String idColumn1;
  final String idColumn2;
  final String table1Name;
  final String table2Name;

  final FutureOr<T1> Function(Map<String, dynamic>) fromDbT1;
  final FutureOr<T2> Function(Map<String, dynamic>) fromDbT2;

  BaseManyToMany({
    required super.name,
    required this.idColumn1,
    required this.idColumn2,
    required this.table1Name,
    required this.table2Name,
    required this.fromDbT1,
    required this.fromDbT2,
  });

  final _updateController = StreamController<void>.broadcast();

  void notifyUpdate() => _updateController.add(null);

  Stream<List<T>> watchItems<T>(int parentId, LinkSide side) {
    return _updateController.stream.asyncMap((_) async {
      final items = await getItems(parentId, side);
      return items.cast<T>();
    });
  }

  // Генератор скрипта на основе полей текущего класса
  @override
  String get onCreate => '''
    CREATE TABLE $name (
      $idColumn1 INTEGER,
      $idColumn2 INTEGER,
      PRIMARY KEY ($idColumn1, $idColumn2),
      FOREIGN KEY ($idColumn1) REFERENCES $table1Name (id) ON DELETE CASCADE,
      FOREIGN KEY ($idColumn2) REFERENCES $table2Name (id) ON DELETE CASCADE
    );
  ''';

  Future<void> createLink(int id1, int id2) async {
    await database.insert(
        name,
        {
          idColumn1: id1,
          idColumn2: id2,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createLinkWithEntity(
      JsonMap entityData, int id1, int id2) async {
    await database.transaction((txn) async {
      await txn.insert(
        name,
        entityData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final Map<String, dynamic> linkData = {idColumn1: id1, idColumn2: id2};

      await txn.insert(
        name,
        linkData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    notifyUpdate();
  }

  // Удалить связь
  Future<void> removeLink(int id1, int id2) async {
    await database.delete(
      name,
      where: '$idColumn1 = ? AND $idColumn2 = ?',
      whereArgs: [id1, id2],
    );
  }

  // Получить все объекты Т1 для конкретного ID из T2
  Future<List<T1>> getT1ByT2Id(int t2id) async {
    try {
      var query = '''
      SELECT t1.* FROM $table1Name t1
      INNER JOIN $name link ON t1.id = link.$idColumn1
      WHERE link.$idColumn2 = ?
    ''';
      final List<Map<String, dynamic>> res =
          await database.rawQuery(query, [t2id]);
      return Future.wait(res.map((e) async => await fromDbT1(e)));
    } catch (e) {
      ['error', e].print();
      return [];
    }
  }

  // Получить все объекты Т2 для конкретного ID из T1
  Future<List<T2>> getT2ByT1Id(int t1id) async {
    var query = '''
      SELECT t2.* FROM $table2Name t2
      INNER JOIN $name link ON t2.id = link.$idColumn2
      WHERE link.$idColumn1 = ?
    ''';
    final List<Map<String, dynamic>> res =
        await database.rawQuery(query, [t1id]);
    return Future.wait(res.map((e) async => await fromDbT2(e)));
  }

  Future<List<dynamic>> getItems(int parentId, LinkSide parentSide) async {
    try {
      if (parentSide == LinkSide.side1) {
        return await getT2ByT1Id(parentId);
      } else {
        return await getT1ByT2Id(parentId);
      }
    } catch (e) {
      ['error', e.toString()].print();
      return [];
    }
  }
}

extension StartWithFuture<E> on Stream<E> {
  Stream<E> startWithFuture(Future<E> future) async* {
    yield await future;
    yield* this;
  }
}

enum LinkSide { side1, side2 }

class ManyToManyBuilder extends DatabaseInterface {
  final String name;
  final String idColumn1;
  final String idColumn2;
  final String table1Name;
  final String table2Name;

  ManyToManyBuilder(
      {required this.name,
      required this.idColumn1,
      required this.idColumn2,
      required this.table1Name,
      required this.table2Name});

  @override
  List<String> get onCreate => [
        '''
   CREATE TABLE IF NOT EXISTS $name (
      $idColumn1 INTEGER NOT NULL,
      $idColumn2 INTEGER NOT NULL,
      
      -- Делаем пару колонок первичным ключом. 
      -- Это автоматически создает уникальный индекс и запрещает дубликаты.
      PRIMARY KEY ($idColumn1, $idColumn2),
      
      -- Настраиваем связи с основными таблицами
      FOREIGN KEY ($idColumn1) REFERENCES $table1Name (id) ON DELETE CASCADE,
      FOREIGN KEY ($idColumn2) REFERENCES $table2Name (id) ON DELETE CASCADE
    );
    '''
      ];
}
