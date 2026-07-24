import 'package:qoiu_db/database/database_table_interface.dart';
import 'package:qoiu_db/database/db_entity.dart';
import 'package:qoiu_db/database/one_to_one_controller.dart';

mixin JointTable<T extends DbEntity> on DatabaseTableInterface<T> {
  List<OneToOneController> get joins => [];
  @override
  Future<List<T>> getAll([String? where]) async {
    StringBuffer selectClause = StringBuffer('SELECT main.*');

    for (var j in joins) {
      String tableAlias = j.prefix.replaceAll("_", "");

      // БЕРЕМ СПИСОК КОЛОНОК (теперь это критично!)
      // Если у тебя еще нет метода getColumns(),
      // сейчас самое время его добавить в BaseDatabaseTable
      for (var col in j.targetDb.columnNames) {
        selectClause.write(', $tableAlias.$col AS ${j.prefix}$col');
      }
    }

    String sql = '''
      $selectClause
      FROM $name AS main
      ${joins.map((j) => 'LEFT JOIN ${j.targetDb.name} AS ${j.prefix.replaceAll("_", "")} ON main.${j.joinColumn} = ${j.prefix.replaceAll("_", "")}.id').join(' ')}
      $where
    ''';

    var response = await database.rawQuery(sql);
    return response.map((e) => fromDB(e)).toList();
  }


  @override
  Future<T?> getById(int id) async {
    var list = await getAll("WHERE main.id = $id");
    return list.firstOrNull;
  }
}
