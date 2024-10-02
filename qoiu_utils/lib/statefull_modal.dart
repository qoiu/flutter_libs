import 'package:flutter/material.dart';

import 'navigation.dart';

abstract class StatefulModal extends StatefulWidget{
  abstract final String tag;
  final bool isScrolled;
  final bool useSafeArea;

  const StatefulModal({this.isScrolled=true, this.useSafeArea=true, super.key});

  Future<T?> show<T>({BuildContext? context}) {
    return showModalBottomSheet(
        context: context??rootNavigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        useSafeArea: useSafeArea,
        isScrollControlled: isScrolled,
        builder: (context) => this,
        routeSettings: RouteSettings(name: tag));
  }
}

abstract class StatelessModal extends StatelessWidget{
  abstract final String tag;
  final bool isScrolled;
  final bool useSafeArea;

  const StatelessModal({this.isScrolled=true, this.useSafeArea=true, super.key});

  Future<T?> show<T>({BuildContext? context}) async{
    return await showModalBottomSheet(
        context: context??rootNavigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        useSafeArea: useSafeArea,
        isScrollControlled: isScrolled,
        builder: (context) => this,
        routeSettings: RouteSettings(name: tag));
  }
}