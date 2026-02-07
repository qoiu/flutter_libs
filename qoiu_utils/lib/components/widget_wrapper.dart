
import 'package:flutter/material.dart';


class WidgetWrapper extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Widget Function(Widget child) wrap;
  const WidgetWrapper({required this.condition, required this.child, required this.wrap, super.key});

  @override
  Widget build(BuildContext context) {
    return condition?wrap(child):child;
  }
}
