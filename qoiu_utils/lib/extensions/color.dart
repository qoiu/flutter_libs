
import 'package:flutter/material.dart';

extension ColorFilterOnColor on Color {
  ColorFilter defaultFilter() => ColorFilter.mode(this, BlendMode.srcATop);

  Color oppositeTextColor() {
    return computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

}