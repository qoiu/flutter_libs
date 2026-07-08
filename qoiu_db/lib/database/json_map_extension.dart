
import 'dart:convert';

import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';

extension JsonMapExtension on JsonMap{
  JsonMap? get extra => (this['extra'] is String)?(this['extra'] as String).let((e)=>jsonDecode(this['extra'])):this['extra'];
  MapEntry toExtraEntry()=>MapEntry('extra', jsonEncode(this));
  String toExtra()=> jsonEncode(this);


  Map<String, dynamic> unprefix(String prefix) {
    return Map.fromEntries(
      entries
          .where((e) => e.key.startsWith(prefix))
          .map((e) => MapEntry(e.key.replaceFirst(prefix, ''), e.value)),
    );
  }
}