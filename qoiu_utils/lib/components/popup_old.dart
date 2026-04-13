import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/widget_wrapper.dart';

class PopupOld extends StatefulWidget {
  final Widget child;
  final Widget follower;
  final OverlayPortalController controller;
  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final Offset offset;
  final VoidCallback? tapOutside;

  const PopupOld({
    required this.child,
    required this.follower,
    required this.controller,
    this.tapOutside,
    this.offset = Offset.zero,
    this.followerAnchor = Alignment.topCenter,
    this.targetAnchor = Alignment.bottomCenter,
    super.key,
  });

  @override
  State<PopupOld> createState() => _PopupOldState();
}

class _PopupOldState extends State<PopupOld> {
  final _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: widget.controller,
        child: widget.child,
        overlayChildBuilder: (BuildContext context) {
          return WidgetWrapper(
            condition: widget.tapOutside!=null,
            wrap: (child) => GestureDetector(
                onTap: ()async{
                  widget.controller.hide();
                  await Future.delayed(const Duration(milliseconds: 100));
                  widget.tapOutside!();
                  },
                child: Container(color: Colors.transparent, child: child)),
            child: Align(
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                followerAnchor: widget.followerAnchor,
                targetAnchor: widget.targetAnchor,
                offset: widget.offset,
                child: widget.follower,
              ),
            ),
          );
        },
      ),
    );
  }
}
