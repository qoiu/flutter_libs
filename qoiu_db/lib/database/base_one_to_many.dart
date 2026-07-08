import 'package:qoiu_db/database/base_database_table.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

import 'db_entity.dart';
import 'many_to_many_link.dart';

class DbOneToManyLink<T extends DbEntity, R extends BaseDatabaseTable<T>>
    implements ToManyLink<T> {

  final int parentId;
  final String parentIdColumn; // Название колонки в таблице ребенка, например 'houseId'
  final R table;           // Ссылка на твой класс таблицы (например, WorldRoomTable)


  DbOneToManyLink({
    required this.parentId,
    required this.parentIdColumn,
    required this.table,
  });

  @override
  Future<List<T>> fetch() async {
    ['fetch',parentId].print();
    if (parentId == -1) return [];
   return await table.getWhere("WHERE $parentIdColumn = $parentId");
  }


  @override
  Future<void> add(T child) async {
    await table.database.update(
      table.name,
      {parentIdColumn: parentId},
      where: 'id = ?',
      whereArgs: [child.id],
    );
  }

  @override
  Future<void> remove(T child) async {
    // Убираем привязку (ставим null)
    await table.database.update(
      table.name,
      {parentIdColumn: null},
      where: 'id = ?',
      whereArgs: [child.id],
    );
  }
}
