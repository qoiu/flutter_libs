import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  final String asset;
  final EdgeInsets? padding;
  final EdgeInsets? clickableExtra;
  final double size;
  final Function() action;
  final BoxShape? shape;
  final Color? color;
  final Color? backgroundColor;
  final bool isLoading;
  final bool isEnable;
  final double indicatorWidth;

  const SvgButton(this.asset, this.action,
      {super.key,
      this.size = 30,
      this.padding,
      this.backgroundColor,
      this.color,
      this.shape,
      this.clickableExtra,
      this.isLoading = false,
      this.isEnable = true,
      this.indicatorWidth = 2});

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: isEnable?1:0.5, child: Material(
      color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(size),
      child: InkWell(
        onTap: isEnable?action:null,
        borderRadius: BorderRadius.circular(size),
        child: Container(
          padding: clickableExtra ?? EdgeInsets.zero,
          child: Container(
            width: size,
            height: size,
            padding: padding ?? const EdgeInsets.all(5),
            child: isLoading
                ? CircularProgressIndicator(strokeWidth: indicatorWidth, color: color??Theme.of(context).colorScheme.onPrimary)
                : SvgPicture.asset(
                    asset,
                    colorFilter: color!=null?ColorFilter.mode(color!, BlendMode.srcATop):null,
                  ),
          ),
        ),
      ),
    ));
  }
}
