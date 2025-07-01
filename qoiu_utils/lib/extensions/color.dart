
import 'package:flutter/material.dart';

extension ColorFilterOnColor on Color {
  ColorFilter defaultFilter() => ColorFilter.mode(this, BlendMode.srcATop);
}