
import 'package:flutter/material.dart';

extension ColorFilterOnColor on Color {
  ColorFilter defaultFilter() => ColorFilter.mode(this, BlendMode.srcATop);

  Color oppositeTextColor({Color black=Colors.black, Color white = Colors.white}) {
    return computeLuminance() > 0.5 ? black : white;
  }

}