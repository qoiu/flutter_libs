
import 'package:flutter/material.dart';

extension GlobalKeyWithSize on GlobalKey {
  Size? size<T extends Object>() {
    try {
      return renderBox()?.size;
    } finally{}
  }

  RenderBox? renderBox() => (currentContext?.findRenderObject() is RenderBox)?(currentContext?.findRenderObject() as RenderBox?):null;
}