library qoiu_utills;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qoiu_utils/navigation.dart';


ColorScheme getColorScheme([BuildContext? context]) =>
    Theme.of(context ?? rootNavigatorKey.currentContext!).colorScheme;

TextTheme getTextStyle([BuildContext? context]) =>
    Theme.of(context ?? rootNavigatorKey.currentContext!).textTheme;



extension GlobalKeyWithSize on GlobalKey  {
  Size? size<T extends Object>()=> (currentContext?.findRenderObject() as RenderBox?)?.size;
}

extension DefaultDuration on Duration  {
  static Duration get defaultDuration => const Duration(milliseconds: 500);
}

extension PrintString on String {
  String get digits => replaceAll(RegExp(r'[^0-9]'),'');
  print() {
    if (kDebugMode) {
      debugPrint(this);
    }
  }
  printLong() {
    if (kDebugMode) {
      debugPrint(this, wrapWidth: 1024);
    }
  }
  String? get nullIfEmpty => isEmpty?null:this;
}



extension DebugColor on String {
  String dpRed() => "\x1B[31m$this\x1B[0m";
  String dpGreen() => "\x1B[32m$this\x1B[0m";
  String dpYellow() => "\x1B[33m$this\x1B[0m";
  String dpBlue() => "\x1B[34m$this\x1B[0m";
  String dp(int color) => "\x1B[${color}m$this\x1B[0m";
  String clearColors(){
    var result = this;
    result = result.replaceAll('\x1B[0m', '');
    for (var i = 0; i < 5; ++i) {
      result = result.replaceAll('\x1B[3${i}m', '');
    }
    return result;
  }
}

extension NullableExtention<T> on T {
  R? let<R>(R Function(T that) op) => this == null ? null : op(this);
}

extension ColorFilterOnColor on Color {
  ColorFilter defaultFilter() => ColorFilter.mode(this, BlendMode.srcATop);
}

T parseEnum<T extends Enum>(List<T> list, String? data, [T? defaultValue]) {
  return list.where((element) => element.name == data).firstOrNull ??
      defaultValue ??
      list.first;
}

List<T> parseList<T>(
    dynamic json, T Function(Map<String, dynamic> json) mapper) {
  return (json as List?)
      ?.map((e) => (e is Map<String, dynamic>) ? mapper(e) : null)
      .whereType<T>()
      .toList() ??
      <T>[];
}
extension StringMap on Map<String, dynamic> {
  Map<String, dynamic> toStringMap() =>
      Map.fromEntries(entries.map((e) => MapEntry(e.key, e.value.toString())));

  static Map<String, String Function(String)> defaultKeyColorize = {
    'id': (s) => s.dpYellow()
  };

  String toQuery() {
    if (isEmpty) {
      return '';
    }
    var first = true;
    return entries.map((e) {
      var start = '&';
      if (first) {
        first = false;
        start = '?';
      }
      return '$start${e.key}=${e.value}';
    }).join('');
  }

  print({int? maxListSize = 3}) {
    parseToString(maxListSize).printLong();
  }

  String parseToString(
      [int? maxListSize, int depth = 0, bool fromMap = false]) {
    if(length==1 && entries.first.value is String){
      var entry = entries.first;
      String key = (defaultKeyColorize.containsKey(entry.key))
          ? defaultKeyColorize[entry.key]!(entry.key)
          : entry.key.dpBlue();
      return '$key: ${entry.value}';
    }
    var star = '*'.dp(90);
    var offsetStart = List.generate(depth, (i) => '').join('');
    var result = depth==0? '{\n':'\n';
    var index = 0;
    for (var entry in entries) {
      var value = _typePrint(entry.value,
          maxListSize: maxListSize, depth: depth+1, fromMap: true);
      String key = (defaultKeyColorize.containsKey(entry.key))
          ? defaultKeyColorize[entry.key]!(entry.key)
          : entry.key.dpBlue();
      var offset = List.generate(depth, (i) => '---'.dp(90)).join('');
      result +=
      '$star$offset${key.dp(1)}: $value${(entry.key!=entries.last.key)?',\n':''}';
      index++;
    }

    return result;
  }
}

String _typePrint(dynamic value,
    {int? maxListSize, int depth = 0, bool fromMap = false}) {
  var result = '';
  if (value == null) {
    result = 'null'.dpRed();
  } else if (value is Map<String, dynamic>) {
    result = (value).parseToString(maxListSize, depth, fromMap);
  } else if (value is Enum) {
    result = (result as Enum).name.dpYellow();
  } else if (value is List) {
    result = value.parseToString(maxListSize, depth);
  } else if (value is bool) {
    result = value.toString().dpGreen();
  } else if (value is int) {
    result = value.toString().dp(93);
  } else {
    result = value.toString();
  }
  return result;
}

extension PrintList on List {
  print([int? maxListSize]) => parseToString(maxListSize).printLong();

  String parseToString([int? maxRecord, int depth = 0]) {
    if (length == 1) {
      return _typePrint(first, depth: depth);
    } else if (length == 2) {
      return '${first.toString().dpBlue()}: ${_typePrint(last, depth: depth)}';
    } else {
      var list = (maxRecord == null ? this : take(maxRecord))
          .map((e) => _typePrint(e, depth: depth));
      if(list.any((e) => e.length > 15) || list.length>10){
        list = list.map((e)=>'\n${'*'.dp(90)}${List.generate(depth, (i) => '~~~'.dp(90)).join()}$e');
      }
      return '${maxRecord != null ? '($maxRecord)'.dp(37) : ''}${depth==0?'[':''}${list.join()}';
    }
  }
}
