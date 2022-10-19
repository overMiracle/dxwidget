import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 徽标主题
class DxBadgeTheme extends InheritedTheme {
  const DxBadgeTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxBadgeThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxBadgeTheme(
          key: key,
          data: DxBadgeTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxBadgeThemeData data;

  static DxBadgeThemeData of(BuildContext context) {
    final DxBadgeTheme? badgeTheme = context.dependOnInheritedWidgetOfExactType<DxBadgeTheme>();
    return badgeTheme?.data ?? DxTheme.of(context).badgeTheme;
  }

  @override
  bool updateShouldNotify(DxBadgeTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxBadgeTheme(data: data, child: child);
}

class DxBadgeThemeData {
  final double size;
  final Color color;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderWidth;
  final Color backgroundColor;
  final Color dotColor;
  final double dotSize;
  final String fontFamily;

  factory DxBadgeThemeData({
    double? size,
    Color? color,
    EdgeInsets? padding,
    double? fontSize,
    FontWeight? fontWeight,
    double? borderWidth,
    Color? backgroundColor,
    Color? dotColor,
    double? dotSize,
    String? fontFamily,
  }) {
    return DxBadgeThemeData.raw(
      size: size ?? 16.0,
      color: color ?? DxStyle.white,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      fontSize: fontSize ?? 11.0,
      fontWeight: fontWeight ?? DxStyle.fontWeightBold,
      borderWidth: borderWidth ?? DxStyle.borderWidthBase,
      backgroundColor: backgroundColor ?? DxStyle.red,
      dotColor: dotColor ?? DxStyle.red,
      dotSize: dotSize ?? 8.0,
      fontFamily: fontFamily ?? '',
    );
  }

  const DxBadgeThemeData.raw({
    required this.size,
    required this.color,
    required this.padding,
    required this.fontSize,
    required this.fontWeight,
    required this.borderWidth,
    required this.backgroundColor,
    required this.dotColor,
    required this.dotSize,
    required this.fontFamily,
  });

  DxBadgeThemeData copyWith({
    double? size,
    Color? color,
    EdgeInsets? padding,
    double? fontSize,
    FontWeight? fontWeight,
    double? borderWidth,
    Color? backgroundColor,
    Color? dotColor,
    double? dotSize,
    String? fontFamily,
  }) {
    return DxBadgeThemeData(
      size: size ?? this.size,
      color: color ?? this.color,
      padding: padding ?? this.padding,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      borderWidth: borderWidth ?? this.borderWidth,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dotColor: dotColor ?? this.dotColor,
      dotSize: dotSize ?? this.dotSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  DxBadgeThemeData merge(DxBadgeThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      size: other.size,
      color: other.color,
      padding: other.padding,
      fontSize: other.fontSize,
      fontWeight: other.fontWeight,
      borderWidth: other.borderWidth,
      backgroundColor: other.backgroundColor,
      dotColor: other.dotColor,
      dotSize: other.dotSize,
      fontFamily: other.fontFamily,
    );
  }

  static DxBadgeThemeData lerp(DxBadgeThemeData? a, DxBadgeThemeData? b, double t) {
    return DxBadgeThemeData(
      size: lerpDouble(a?.size, b?.size, t),
      color: Color.lerp(a?.color, b?.color, t),
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t),
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      fontWeight: FontWeight.lerp(a?.fontWeight, b?.fontWeight, t),
      borderWidth: lerpDouble(a?.borderWidth, b?.borderWidth, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      dotColor: Color.lerp(a?.dotColor, b?.dotColor, t),
      dotSize: lerpDouble(a?.dotSize, b?.dotSize, t),
      fontFamily: b?.fontFamily,
    );
  }
}
