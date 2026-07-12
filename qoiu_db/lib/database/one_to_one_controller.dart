import 'package:qoiu_db/database/database_table_iterface.dart';
import 'package:qoiu_utils/qoiu_utils_export.dart';

import 'db_entity.dart';
import 'json_map_extension.dart';

class OneToOneController<T extends DbEntity> {
  final String prefix;
  final String joinColumn; /// Поле в основной таблице, например 'playerId'
  final DatabaseTableInterface targetDb; /// Поле в основной таблице, например 'playerId'
  final T Function(JsonMap map) mapper;

  const OneToOneController({
    required this.prefix,
    required this.targetDb,
    this.joinColumn = 'id',
    required this.mapper,
  });

  T fromDb(JsonMap rawMap) => mapper(rawMap.unprefix(prefix));
}
