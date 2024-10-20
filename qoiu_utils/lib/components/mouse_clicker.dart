import 'package:flutter/material.dart';

class MouseClicker extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const MouseClicker({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
