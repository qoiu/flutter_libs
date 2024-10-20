import 'package:flutter/material.dart';

class VisibleClicker extends StatelessWidget {
  final BorderRadius? borderRadius;
  final VoidCallback onTap;
  final Widget child;
  const VisibleClicker({super.key, required this.child, required this.onTap, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    var radius = borderRadius??BorderRadius.circular(10);
    return Material(
      borderRadius: radius,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
