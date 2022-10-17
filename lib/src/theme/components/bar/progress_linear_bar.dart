import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

class DxProgressLinearBarTheme extends InheritedTheme {
  const DxProgressLinearBarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxProgressLinearBarThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxProgressLinearBarTheme(
          key: key,
          data: DxProgressLinearBarTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxProgressLinearBarThemeData data;

  static DxProgressLinearBarThemeData of(BuildContext context) {
    final DxProgressLinearBarTheme? progressLinearBarTheme =
        context.dependOnInheritedWidgetOfExactType<DxProgressLinearBarTheme>();
    return progressLinearBarTheme?.data ?? DxTheme.of(context).progressLinearBarTheme;
  }

  @override
  bool updateShouldNotify(DxProgressLinearBarTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxProgressLinearBarTheme(data: data, child: child);
  }
}

class DxProgressLinearBarThemeData {
  final double height;
  final Color color;
  final Color backgroundColor;
  final EdgeInsets pivotPadding;
  final Color pivotTextColor;
  final double pivotFontSize;
  final double pivotLineHeight;
  final Color pivotBackgroundColor;

  factory DxProgressLinearBarThemeData({
    double? height,
    Color? color,
    Color? backgroundColor,
    EdgeInsets? pivotPadding,
    Color? pivotTextColor,
    double? pivotFontSize,
    double? pivotLineHeight,
    Color? pivotBackgroundColor,
  }) {
    return DxProgressLinearBarThemeData.raw(
      height: height ?? 4.0,
      color: color ?? DxStyle.blue,
      backgroundColor: backgroundColor ?? DxStyle.gray3,
      pivotPadding: pivotPadding ?? const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
      pivotTextColor: pivotTextColor ?? DxStyle.white,
      pivotFontSize: pivotFontSize ?? DxStyle.fontSizeXs,
      pivotLineHeight: pivotLineHeight ?? 1.6,
      pivotBackgroundColor: pivotBackgroundColor ?? DxStyle.blue,
    );
  }

  const DxProgressLinearBarThemeData.raw({
    required this.height,
    required this.color,
    required this.backgroundColor,
    required this.pivotPadding,
    required this.pivotTextColor,
    required this.pivotFontSize,
    required this.pivotLineHeight,
    required this.pivotBackgroundColor,
  });

  DxProgressLinearBarThemeData copyWith({
    double? height,
    Color? color,
    Color? backgroundColor,
    EdgeInsets? pivotPadding,
    Color? pivotTextColor,
    double? pivotFontSize,
    double? pivotLineHeight,
    Color? pivotBackgroundColor,
  }) {
    return DxProgressLinearBarThemeData(
      height: height ?? this.height,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pivotPadding: pivotPadding ?? this.pivotPadding,
      pivotTextColor: pivotTextColor ?? this.pivotTextColor,
      pivotFontSize: pivotFontSize ?? this.pivotFontSize,
      pivotLineHeight: pivotLineHeight ?? this.pivotLineHeight,
      pivotBackgroundColor: pivotBackgroundColor ?? this.pivotBackgroundColor,
    );
  }

  DxProgressLinearBarThemeData merge(DxProgressLinearBarThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      height: other.height,
      color: other.color,
      backgroundColor: other.backgroundColor,
      pivotPadding: other.pivotPadding,
      pivotTextColor: other.pivotTextColor,
      pivotFontSize: other.pivotFontSize,
      pivotLineHeight: other.pivotLineHeight,
      pivotBackgroundColor: other.pivotBackgroundColor,
    );
  }

  static DxProgressLinearBarThemeData lerp(DxProgressLinearBarThemeData? a, DxProgressLinearBarThemeData? b, double t) {
    return DxProgressLinearBarThemeData(
      height: lerpDouble(a?.height, b?.height, t),
      color: Color.lerp(a?.color, b?.color, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      pivotPadding: EdgeInsets.lerp(a?.pivotPadding, b?.pivotPadding, t),
      pivotTextColor: Color.lerp(a?.pivotTextColor, b?.pivotTextColor, t),
      pivotFontSize: lerpDouble(a?.pivotFontSize, b?.pivotFontSize, t),
      pivotLineHeight: lerpDouble(a?.pivotLineHeight, b?.pivotLineHeight, t),
      pivotBackgroundColor: Color.lerp(a?.pivotBackgroundColor, b?.pivotBackgroundColor, t),
    );
  }
}
