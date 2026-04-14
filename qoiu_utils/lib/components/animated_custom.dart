
import 'package:flutter/cupertino.dart';

class AnimatedCustom<T> extends StatefulWidget {
  final AnimatedCustomController<T> controller;
  final Widget Function(T,Widget?) builder;
  final Widget? child;
  final Curve curve;

  const AnimatedCustom({
    Key? key,
    required this.controller,
    required this.builder,
    this.child,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedCustomState<T> createState() => _AnimatedCustomState<T>();
}

class _AnimatedCustomState<T> extends State<AnimatedCustom> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<T>(
      tween: Tween<T>(
        begin: widget.controller.start,
        end: widget.controller.end,
      ),
      duration: Duration(milliseconds: widget.controller.milliseconds),
      curve: widget.curve,
      builder: (BuildContext context, T? value, Widget? child) {
        return value == null ? Container() : widget.builder(value,child);
      },
      child: widget.child,
    );
  }
}


class AnimatedCustomController<T>{
  T start;
  T end;
  int milliseconds;
  int defaultMilliseconds;

  AnimatedCustomController(this.start, [this.milliseconds=800]): end = start, defaultMilliseconds = milliseconds;

  animate(T target,[int? milliseconds]){
    start = end;
    end = target;
    this.milliseconds = milliseconds??defaultMilliseconds;
  }

}