
import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';


class WidgetWrapper extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Widget Function(Widget child) wrap;
  final Widget Function(Widget child)? elseWrap;
  const WidgetWrapper({required this.condition, required this.child, required this.wrap, this.elseWrap, super.key});

  @override
  Widget build(BuildContext context) {
    return condition?wrap(child):elseWrap?.let((f)=>f(child))??child;
  }
}
