import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

class LoadingContainer extends StatefulWidget {
  final Widget? child;
  final Widget Function(VoidCallback refresh)? builder;
  final Widget Function(VoidCallback refresh)? errorWidget;
  final AsyncCallback loadingData;

  const LoadingContainer(
      {required this.child, required this.loadingData, this.errorWidget, super.key})
      : builder = null;

  const LoadingContainer.builder(
      {super.key, required this.builder, this.errorWidget, required this.loadingData})
      : child = null;

  @override
  State<LoadingContainer> createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer> {
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) {
      getData();
    });
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
      });
      await widget.loadingData();
    } catch (e) {
      isError = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: getColorScheme().primary))
        : isError
            ? widget.errorWidget?.let((e)=>e(getData))??Container()
            : widget.builder != null
                ? widget.builder!(getData)
                : widget.child!;
  }
}
