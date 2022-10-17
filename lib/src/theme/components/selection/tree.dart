import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 选择主题
class DxTreeSelectionTheme extends InheritedTheme {
  const DxTreeSelectionTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxTreeSelectionThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxTreeSelectionTheme(
          key: key,
          data: DxTreeSelectionTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxTreeSelectionThemeData data;

  static DxTreeSelectionThemeData of(BuildContext context) {
    final DxTreeSelectionTheme? treeSelectionTheme = context.dependOnInheritedWidgetOfExactType<DxTreeSelectionTheme>();
    return treeSelectionTheme?.data ?? DxTheme.of(context).treeSelectionTheme;
  }

  @override
  bool updateShouldNotify(DxTreeSelectionTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxTreeSelectionTheme(data: data, child: child);
}

class DxTreeSelectionThemeData {
  final double? fontSize;
  final Color? navBackgroundColor;
  final Color? contentBackgroundColor;
  final EdgeInsets? navItemPadding;
  final double? itemHeight;
  final Color? itemActiveColor;
  final Color? itemDisabledColor;
  final double? itemSelectedSize;

  factory DxTreeSelectionThemeData({
    double? fontSize,
    Color? navBackgroundColor,
    Color? contentBackgroundColor,
    EdgeInsets? navItemPadding,
    double? itemHeight,
    Color? itemActiveColor,
    Color? itemDisabledColor,
    double? itemSelectedSize,
  }) {
    return DxTreeSelectionThemeData.raw(
      fontSize: fontSize ?? DxStyle.fontSizeMd,
      navBackgroundColor: navBackgroundColor ?? DxStyle.backgroundColor,
      contentBackgroundColor: contentBackgroundColor ?? DxStyle.white,
      navItemPadding: navItemPadding ?? const EdgeInsets.symmetric(vertical: 14.0, horizontal: DxStyle.paddingSm),
      itemHeight: itemHeight ?? 48.0,
      itemActiveColor: itemActiveColor ?? DxStyle.red,
      itemDisabledColor: itemDisabledColor ?? DxStyle.gray5,
      itemSelectedSize: itemSelectedSize ?? 16.0,
    );
  }

  const DxTreeSelectionThemeData.raw({
    required this.fontSize,
    required this.navBackgroundColor,
    required this.contentBackgroundColor,
    required this.navItemPadding,
    required this.itemHeight,
    required this.itemActiveColor,
    required this.itemDisabledColor,
    required this.itemSelectedSize,
  });

  DxTreeSelectionThemeData copyWith({
    double? fontSize,
    Color? navBackgroundColor,
    Color? contentBackgroundColor,
    EdgeInsets? navItemPadding,
    double? itemHeight,
    Color? itemActiveColor,
    Color? itemDisabledColor,
    double? itemSelectedSize,
  }) {
    return DxTreeSelectionThemeData(
      fontSize: fontSize ?? this.fontSize,
      navBackgroundColor: navBackgroundColor ?? this.navBackgroundColor,
      contentBackgroundColor: contentBackgroundColor ?? this.contentBackgroundColor,
      navItemPadding: navItemPadding ?? this.navItemPadding,
      itemHeight: itemHeight ?? this.itemHeight,
      itemActiveColor: itemActiveColor ?? this.itemActiveColor,
      itemDisabledColor: itemDisabledColor ?? this.itemDisabledColor,
      itemSelectedSize: itemSelectedSize ?? this.itemSelectedSize,
    );
  }

  DxTreeSelectionThemeData merge(DxTreeSelectionThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      fontSize: other.fontSize,
      navBackgroundColor: other.navBackgroundColor,
      contentBackgroundColor: other.contentBackgroundColor,
      navItemPadding: other.navItemPadding,
      itemHeight: other.itemHeight,
      itemActiveColor: other.itemActiveColor,
      itemDisabledColor: other.itemDisabledColor,
      itemSelectedSize: other.itemSelectedSize,
    );
  }

  static DxTreeSelectionThemeData lerp(DxTreeSelectionThemeData? a, DxTreeSelectionThemeData? b, double t) {
    return DxTreeSelectionThemeData(
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      navBackgroundColor: Color.lerp(a?.navBackgroundColor, b?.navBackgroundColor, t),
      contentBackgroundColor: Color.lerp(a?.contentBackgroundColor, b?.contentBackgroundColor, t),
      navItemPadding: EdgeInsets.lerp(a?.navItemPadding, b?.navItemPadding, t),
      itemHeight: lerpDouble(a?.itemHeight, b?.itemHeight, t),
      itemActiveColor: Color.lerp(a?.itemActiveColor, b?.itemActiveColor, t),
      itemDisabledColor: Color.lerp(a?.itemDisabledColor, b?.itemDisabledColor, t),
      itemSelectedSize: lerpDouble(a?.itemSelectedSize, b?.itemSelectedSize, t),
    );
  }
}
