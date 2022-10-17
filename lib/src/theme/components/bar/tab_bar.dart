import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

class DxTabBarTheme extends InheritedTheme {
  const DxTabBarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxTabBarThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxTabBarTheme(
          key: key,
          data: DxTabBarTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxTabBarThemeData data;

  static DxTabBarThemeData of(BuildContext context) {
    final DxTabBarTheme? tabBarTheme = context.dependOnInheritedWidgetOfExactType<DxTabBarTheme>();
    return tabBarTheme?.data ?? DxTheme.of(context).tabBarTheme;
  }

  @override
  bool updateShouldNotify(DxTabBarTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxTabBarTheme(data: data, child: child);
  }
}

class DxTabBarThemeData {
  final double height;
  final Color backgroundColor;
  final double itemFontSize;
  final Color itemTextColor;
  final Color itemActiveColor;
  final Color itemActiveBackgroundColor;
  final double itemLineHeight;
  final double itemIconSize;
  final double itemMarginBottom;

  factory DxTabBarThemeData({
    double? height,
    Color? backgroundColor,
    double? itemFontSize,
    Color? itemTextColor,
    Color? itemActiveColor,
    Color? itemActiveBackgroundColor,
    double? itemLineHeight,
    double? itemIconSize,
    double? itemMarginBottom,
  }) {
    final Color bgColor = backgroundColor ?? DxStyle.white;
    return DxTabBarThemeData.raw(
      height: height ?? 50.0,
      backgroundColor: bgColor,
      itemFontSize: itemFontSize ?? DxStyle.fontSizeSm,
      itemTextColor: itemTextColor ?? DxStyle.gray7,
      itemActiveColor: itemActiveColor ?? DxStyle.blue,
      itemActiveBackgroundColor: itemActiveBackgroundColor ?? bgColor,
      itemLineHeight: itemLineHeight ?? 1.0,
      itemIconSize: itemIconSize ?? 22.0,
      itemMarginBottom: itemMarginBottom ?? 4.0,
    );
  }

  const DxTabBarThemeData.raw({
    required this.height,
    required this.backgroundColor,
    required this.itemFontSize,
    required this.itemTextColor,
    required this.itemActiveColor,
    required this.itemActiveBackgroundColor,
    required this.itemLineHeight,
    required this.itemIconSize,
    required this.itemMarginBottom,
  });

  DxTabBarThemeData copyWith({
    double? height,
    Color? backgroundColor,
    double? itemFontSize,
    Color? itemTextColor,
    Color? itemActiveColor,
    Color? itemActiveBackgroundColor,
    double? itemLineHeight,
    double? itemIconSize,
    double? itemMarginBottom,
  }) {
    return DxTabBarThemeData(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      itemFontSize: itemFontSize ?? this.itemFontSize,
      itemTextColor: itemTextColor ?? this.itemTextColor,
      itemActiveColor: itemActiveColor ?? this.itemActiveColor,
      itemActiveBackgroundColor: itemActiveBackgroundColor ?? this.itemActiveBackgroundColor,
      itemLineHeight: itemLineHeight ?? this.itemLineHeight,
      itemIconSize: itemIconSize ?? this.itemIconSize,
      itemMarginBottom: itemMarginBottom ?? this.itemMarginBottom,
    );
  }

  DxTabBarThemeData merge(DxTabBarThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      height: other.height,
      backgroundColor: other.backgroundColor,
      itemFontSize: other.itemFontSize,
      itemTextColor: other.itemTextColor,
      itemActiveColor: other.itemActiveColor,
      itemActiveBackgroundColor: other.itemActiveBackgroundColor,
      itemLineHeight: other.itemLineHeight,
      itemIconSize: other.itemIconSize,
      itemMarginBottom: other.itemMarginBottom,
    );
  }

  static DxTabBarThemeData lerp(DxTabBarThemeData? a, DxTabBarThemeData? b, double t) {
    return DxTabBarThemeData(
      height: lerpDouble(a?.height, b?.height, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      itemFontSize: lerpDouble(a?.itemFontSize, b?.itemFontSize, t),
      itemTextColor: Color.lerp(a?.itemTextColor, b?.itemTextColor, t),
      itemActiveColor: Color.lerp(a?.itemActiveColor, b?.itemActiveColor, t),
      itemActiveBackgroundColor: Color.lerp(a?.itemActiveBackgroundColor, b?.itemActiveBackgroundColor, t),
      itemLineHeight: lerpDouble(a?.itemLineHeight, b?.itemLineHeight, t),
      itemIconSize: lerpDouble(a?.itemIconSize, b?.itemIconSize, t),
      itemMarginBottom: lerpDouble(a?.itemMarginBottom, b?.itemMarginBottom, t),
    );
  }
}
