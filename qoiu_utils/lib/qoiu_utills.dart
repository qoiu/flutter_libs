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
