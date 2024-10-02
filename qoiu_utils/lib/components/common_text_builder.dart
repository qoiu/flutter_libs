import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utills.dart';

class TextBuilder {
  TextStyle? _style;
  Color? _color;
  String text;
  TextAlign? _align;
  TextOverflow? _overflow;
  int? _textMaxLines;
  TextDecoration? _decoration;
  bool _selectable = false;

  TextBuilder overflow(TextOverflow? overflow) {
    _overflow = overflow;
    return this;
  }

  TextBuilder ellipsis() {
    _overflow = TextOverflow.ellipsis;
    return this;
  }

  TextBuilder style(TextStyle? style) {
    _style = style;
    return this;
  }

  /// 12sp - w600
  TextBuilder bodySmall() {
    _style = getTextStyle().bodySmall;
    return this;
  }

  /// 14sp - w600
  TextBuilder bodyMedium() {
    _style = getTextStyle().bodyMedium;
    return this;
  }

  /// 16sp - w600
  TextBuilder bodyLarge() {
    _style = getTextStyle().bodyLarge;
    return this;
  }

  /// 12sp - w700
  TextBuilder labelSmall() {
    _style = getTextStyle().labelSmall;
    return this;
  }

  /// 14sp - w700
  TextBuilder labelMedium() {
    _style = getTextStyle().labelMedium;
    return this;
  }

  /// 16sp - w700
  TextBuilder labelLarge() {
    _style = getTextStyle().labelLarge;
    return this;
  }

  /// 12sp - w800
  TextBuilder titleSmall() {
    _style = getTextStyle().titleSmall;
    return this;
  }

  /// 14sp - w800
  TextBuilder titleMedium() {
    _style = getTextStyle().titleMedium;
    return this;
  }

  /// 16sp - w800
  TextBuilder titleLarge() {
    _style = getTextStyle().titleLarge;
    return this;
  }

  TextBuilder fontSize(double size) {
    _style = _style?.copyWith(fontSize: size);
    return this;
  }

  TextBuilder fontWeight(FontWeight weight) {
    _style = _style?.copyWith(fontWeight: weight);
    return this;
  }

  TextBuilder font500() {
    _style = _style?.copyWith(fontWeight: FontWeight.w500);
    return this;
  }

  TextBuilder alignStart() {
    _align = TextAlign.start;
    return this;
  }

  TextBuilder alignCenter() {
    _align = TextAlign.center;
    return this;
  }

  TextBuilder alignEnd() {
    _align = TextAlign.end;
    return this;
  }

  TextBuilder underline() {
    _decoration = TextDecoration.underline;
    return this;
  }

  TextBuilder selectable() {
    _selectable = true;
    return this;
  }

  TextBuilder color(Color color) {
    _color = color;
    return this;
  }

  TextBuilder primary() {
    _color = getColorScheme().primary;
    return this;
  }

  TextBuilder secondary() {
    _color = getColorScheme().onSurface;
    return this;
  }

  TextBuilder maxLines(int value) {
    _textMaxLines = value;
    return this;
  }

  TextBuilder(this.text);

  Widget build() => _selectable
      ? SelectableText(
          text,
          style: (_style ?? getTextStyle().bodyMedium)!.copyWith(
              color: _color, decoration: _decoration, overflow: _overflow),
          textAlign: _align,
          maxLines: _textMaxLines,
        )
      : Text(
          text,
          style: (_style ?? getTextStyle().bodyMedium)!
              .copyWith(color: _color, decoration: _decoration),
          overflow: _overflow,
          textAlign: _align,
          maxLines: _textMaxLines,
        );
}

class RichTextBuilder {
  List<TextBuilder> texts = [];
  TextOverflow _overflow = TextOverflow.clip;

  RichTextBuilder(this.texts);

  TextSpan _toTextSpan(TextBuilder text,
          [TextStyle? defaultStyle, Color? defaultColor]) =>
      TextSpan(
          text: text.text,
          style: (text._style ?? defaultStyle ?? getTextStyle().bodyMedium)!
              .copyWith(color: text._color ?? defaultColor));

  RichTextBuilder overflow(TextOverflow overflow) {
    _overflow = overflow;
    return this;
  }

  RichTextBuilder ellipsis() {
    _overflow = TextOverflow.ellipsis;
    return this;
  }

  Widget build() {
    if (texts.isEmpty) return Container();
    if (texts.length == 1) return texts.first.build();
    TextStyle? style = texts.first._style;
    Color? color = texts.first._color;
    return RichText(
      text: TextSpan(
          style: texts.first._style,
          children: texts.map((e) => _toTextSpan(e, style, color)).toList()),
      overflow: _overflow,
      maxLines: texts.first._textMaxLines,
    );
  }
}
