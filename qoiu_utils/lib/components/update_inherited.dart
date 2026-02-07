import 'package:flutter/material.dart';

class MainUpdateWidget extends InheritedWidget {
  final Function(VoidCallback fn) _setState;

  const MainUpdateWidget(
      {super.key,
      required super.child,
      required Function(VoidCallback fn) setState})
      : _setState = setState;

  update() {
    _setState(() {});
  }

  static MainUpdateWidget of(BuildContext context) {
    final MainUpdateWidget? result =
        context.dependOnInheritedWidgetOfExactType<MainUpdateWidget>();
    assert(result != null, 'No ChatInherit found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class UpdateController {
  VoidCallback _update = () {};

  subscribe(VoidCallback update) {
    _update = update;
  }

  dispose() {
  _update = (){};
}

  update() => _update();
}

mixin UpdaterMixin<T extends StatefulWidget> on State<T>{
  UpdateController updateController = UpdateController();

  @override
  void initState() {
    super.initState();
    updateController.subscribe(onUpdate);
  }

  @override
  dispose(){
    super.dispose();
    updateController.dispose();
  }

  onUpdate(){
    setState(() {});
  }
}

class ValueUpdater{
  final ValueNotifier<DateTime> _updater=ValueNotifier(DateTime.now());
  final int delay;


  ValueUpdater({this.delay=0});

  update(){
    var now = DateTime.now();
    if(now.millisecondsSinceEpoch-_updater.value.millisecondsSinceEpoch>delay){
      _updater.value = now;
    }
  }

  subscribe(VoidCallback listener){
    _updater.addListener(listener);
  }

  unsubscribe(VoidCallback listener){
    _updater.removeListener(listener);
  }
}