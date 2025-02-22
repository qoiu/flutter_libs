import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FutureButton extends StatefulWidget {
  final AsyncCallback actions;
  final Widget child;

  const FutureButton({required this.child, required this.actions, super.key});

  @override
  State<FutureButton> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  Savable isProcessing = Savable();

  @override
  Widget build(BuildContext context) {
    return FutureButtonController(
        isProcessing: isProcessing,
        onClick: () async {
          try {
            setState(() {
              isProcessing.isLoading = true;
            });
            await widget.actions();
          } finally {
            setState(() {
              isProcessing.isLoading = false;
            });
          }
        },
        child: widget.child);
  }
}

class FutureButtonController extends InheritedWidget {
  final VoidCallback onClick;
  final Savable _isProcessing;

  bool get isProcessing => _isProcessing.isLoading;

  const FutureButtonController(
      {super.key,
      required super.child,
      required this.onClick,
      required Savable isProcessing})
      : _isProcessing = isProcessing;

  static FutureButtonController? of(BuildContext context) {
    final FutureButtonController? result =
        context.dependOnInheritedWidgetOfExactType<FutureButtonController>();
    return result;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class FuturePrepareProcessButton<T> extends StatefulWidget {
  final Future<dynamic>? Function(T data) onPrepared;
  final Future<T> Function() prepare;
  final Widget child;

  const FuturePrepareProcessButton(
      {required this.onPrepared,
      required this.prepare,
      required this.child,
      super.key});

  @override
  State<FuturePrepareProcessButton<T>> createState() =>
      _FutureButtonProcessPrepareState<T>();
}

class _FutureButtonProcessPrepareState<T>
    extends State<FuturePrepareProcessButton<T>> {
  Savable isProcessing = Savable();

  @override
  Widget build(BuildContext context) {
    return FutureButtonController(
        isProcessing: isProcessing,
        onClick: () async {
          T result = await widget.prepare();
          try {
            setState(() {
              isProcessing.isLoading = true;
            });
            await widget.onPrepared(result);
          } finally {
            setState(() {
              isProcessing.isLoading = false;
            });
          }
        },
        child: widget.child);
  }
}
class Savable{
  bool isLoading = false;
}