
import 'package:flutter/material.dart';
import '../qoiu_utils.dart';

extension TextStyleExtension on TextStyle?{
  TextStyle? get inverseColor => this?.copyWith(color: getColorScheme().inverseSurface);
  TextStyle? get primary => this?.copyWith(color: getColorScheme().primary);
  TextStyle? get black => this?.copyWith(color: getColorScheme().onSurface);
  TextStyle? get error => this?.copyWith(color: getColorScheme().error);
}