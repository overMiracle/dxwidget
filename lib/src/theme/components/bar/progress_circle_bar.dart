import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 圆形进度条主题
class DxCircleTheme extends InheritedTheme {
  const DxCircleTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxCircleThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxCircleTheme(
          key: key,
          data: DxCircleTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxCircleThemeData data;

  static DxCircleThemeData of(BuildContext context) {
    final DxCircleTheme? circleTheme = context.dependOnInheritedWidgetOfExactType<DxCircleTheme>();
    return circleTheme?.data ?? DxTheme.of(context).circleTheme;
  }

  @override
  bool updateShouldNotify(DxCircleTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxCircleTheme(data: data, child: child);
}

class DxCircleThemeData {
  final double size;
  final Color color;
  final Color layerColor;
  final Color textColor;
  final FontWeight textFontWeight;
  final double textFontSize;
  final double textLineHeight;

  factory DxCircleThemeData({
    double? size,
    Color? color,
    Color? layerColor,
    Color? textColor,
    FontWeight? textFontWeight,
    double? textFontSize,
    double? textLineHeight,
  }) {
    final double $textFontSize = textFontSize ?? DxStyle.fontSizeMd;
    return DxCircleThemeData.raw(
      size: size ?? 100.0,
      color: color ?? DxStyle.blue,
      layerColor: layerColor ?? DxStyle.white,
      textColor: textColor ?? DxStyle.textColor,
      textFontWeight: textFontWeight ?? DxStyle.fontWeightBold,
      textFontSize: $textFontSize,
      textLineHeight: textLineHeight ?? (DxStyle.lineHeightMd / $textFontSize),
    );
  }

  const DxCircleThemeData.raw({
    required this.size,
    required this.color,
    required this.layerColor,
    required this.textColor,
    required this.textFontWeight,
    required this.textFontSize,
    required this.textLineHeight,
  });

  DxCircleThemeData copyWith({
    double? size,
    Color? color,
    Color? layerColor,
    Color? textColor,
    FontWeight? textFontWeight,
    double? textFontSize,
    double? textLineHeight,
  }) {
    return DxCircleThemeData(
      size: size ?? this.size,
      color: color ?? this.color,
      layerColor: layerColor ?? this.layerColor,
      textColor: textColor ?? this.textColor,
      textFontWeight: textFontWeight ?? this.textFontWeight,
      textFontSize: textFontSize ?? this.textFontSize,
      textLineHeight: textLineHeight ?? this.textLineHeight,
    );
  }

  DxCircleThemeData merge(DxCircleThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      size: other.size,
      color: other.color,
      layerColor: other.layerColor,
      textColor: other.textColor,
      textFontWeight: other.textFontWeight,
      textFontSize: other.textFontSize,
      textLineHeight: other.textLineHeight,
    );
  }

  static DxCircleThemeData lerp(DxCircleThemeData? a, DxCircleThemeData? b, double t) {
    return DxCircleThemeData(
      size: lerpDouble(a?.size, b?.size, t),
      color: Color.lerp(a?.color, b?.color, t),
      layerColor: Color.lerp(a?.layerColor, b?.layerColor, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      textFontWeight: FontWeight.lerp(a?.textFontWeight, b?.textFontWeight, t),
      textFontSize: lerpDouble(a?.textFontSize, b?.textFontSize, t),
      textLineHeight: lerpDouble(a?.textLineHeight, b?.textLineHeight, t),
    );
  }
}
