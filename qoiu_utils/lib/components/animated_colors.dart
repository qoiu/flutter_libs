import 'package:flutter/cupertino.dart';

import 'animated_custom.dart';

class AnimatedColor extends StatefulWidget {
  final Color startColor;
  final Color targetColor;
  final Duration duration;
  final bool showMain;
  final Widget Function(Color) builder;
  final Curve curve;

  const AnimatedColor({
    Key? key,
    required this.startColor,
    required this.targetColor,
    required this.duration,
    required this.builder,
    this.showMain = false,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedColorState createState() => _AnimatedColorState();
}

class _AnimatedColorState extends State<AnimatedColor> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: widget.showMain ? widget.startColor : widget.targetColor,
        end: widget.showMain ? widget.targetColor : widget.startColor,
      ),
      duration: widget.duration,
      curve: widget.curve,
      builder: (BuildContext context, Color? color, Widget? child) {
        return color == null ?
         child ?? Container() : widget.builder(color);
      }, // Pass the original child
    );
  }
}

class AnimatedCustomColor extends StatefulWidget {
  final AnimatedCustomController<Color> controller;
  final Widget Function(Color, Widget?) builder;
  final Widget? child;
  final Curve curve;

  const AnimatedCustomColor({
    Key? key,
    required this.controller,
    required this.builder,
    this.child,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedCustomColorState createState() => _AnimatedCustomColorState();
}

class _AnimatedCustomColorState extends State<AnimatedCustomColor> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: widget.controller.start,
        end: widget.controller.end,
      ),
      duration: Duration(milliseconds: widget.controller.milliseconds),
      curve: widget.curve,
      builder: (BuildContext context, Color? color, Widget? child) {
        return color == null
            ? child ?? Container()
            : widget.builder(color, child);
      },
      child: widget.child,
    );
  }
}
