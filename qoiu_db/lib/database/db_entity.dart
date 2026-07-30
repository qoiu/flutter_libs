import 'package:qoiu_utils/qoiu_utils_export.dart';

abstract class DbEntity {
  int get id;
  JsonMap toDB();
}
