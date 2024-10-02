library qoiu_utills;


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
  print() => debugPrint(this);
  printLong() => debugPrint(this, wrapWidth: 1024);
  String? get nullIfEmpty => isEmpty?null:this;
}


extension DebugColor on String {
  String dpRed() => "\x1B[31m$this\x1B[0m";
  String dpGreen() => "\x1B[32m$this\x1B[0m";
  String dpYellow() => "\x1B[33m$this\x1B[0m";
  String dpBlue() => "\x1B[34m$this\x1B[0m";
}