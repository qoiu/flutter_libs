import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final Function()? onTap;
  final BorderRadius borderRadius;

  const CardTemplate({this.child, this.padding, this.onTap, this.borderRadius=const BorderRadius.all(Radius.circular(20)), super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: Colors.transparent,
      shadowColor: Colors.black.withAlpha(64),
      elevation: 4,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: child,
        ),
      ),
    );
  }
}
