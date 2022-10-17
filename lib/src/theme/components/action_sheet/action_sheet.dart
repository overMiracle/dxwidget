import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 吸底列表弹框主题
class DxActionSheetTheme extends InheritedTheme {
  const DxActionSheetTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxActionSheetThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxActionSheetTheme(
          key: key,
          data: DxActionSheetTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxActionSheetThemeData data;

  static DxActionSheetThemeData of(BuildContext context) {
    final DxActionSheetTheme? actionSheetTheme = context.dependOnInheritedWidgetOfExactType<DxActionSheetTheme>();
    return actionSheetTheme?.data ?? DxTheme.of(context).actionSheetTheme;
  }

  @override
  bool updateShouldNotify(DxActionSheetTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxActionSheetTheme(data: data, child: child);
}

class DxActionSheetThemeData {
  /// 顶部圆角
  final double topRadius;

  /// 标题样式
  final TextStyle titleStyle;

  /// 元素标题默认样式
  final TextStyle itemTitleStyle;

  /// 元素标题链接样式,蓝色
  final TextStyle itemTitleStyleLink;

  /// 元素标题成功样式
  final TextStyle itemTitleStyleSuccess;

  /// 元素警示项标题样式，红色
  final TextStyle itemTitleStyleWarning;

  /// 元素描述默认样式
  final TextStyle itemDescStyle;

  /// 元素描述链接样式
  final TextStyle itemDescStyleLink;

  /// 元素描述成功样式
  final TextStyle itemDescStyleSuccess;

  /// 元素描述警示样式
  final TextStyle itemDescStyleWarning;

  /// 取消按钮样式
  final TextStyle cancelStyle;

  /// 内容左右间距
  final EdgeInsets contentPadding;

  /// 标题左右间距
  final EdgeInsets titlePadding;

  factory DxActionSheetThemeData({
    double? topRadius,
    TextStyle? titleStyle,
    TextStyle? itemTitleStyle,
    TextStyle? itemTitleStyleLink,
    TextStyle? itemTitleStyleSuccess,
    TextStyle? itemTitleStyleWarning,
    TextStyle? itemDescStyle,
    TextStyle? itemDescStyleLink,
    TextStyle? itemDescStyleSuccess,
    TextStyle? itemDescStyleWarning,
    TextStyle? cancelStyle,
    EdgeInsets? contentPadding,
    EdgeInsets? titlePadding,
  }) {
    return DxActionSheetThemeData.raw(
      topRadius: topRadius ?? 8.0,
      titleStyle: titleStyle ?? DxStyle.$999999$14,
      itemTitleStyle: itemTitleStyle ?? DxStyle.$222222$14$W500,
      itemTitleStyleLink: itemTitleStyleLink ?? DxStyle.$0984F9$14$W500,
      itemTitleStyleSuccess: itemTitleStyleSuccess ?? DxStyle.$00AE66$14$W500,
      itemTitleStyleWarning: itemTitleStyleWarning ?? DxStyle.$FA3F3F$14$W500,
      itemDescStyle: itemTitleStyle ?? TextStyle(color: DxStyle.$222222.withOpacity(0.6), fontSize: 12),
      itemDescStyleLink: itemTitleStyleLink ?? TextStyle(color: DxStyle.$0984F9.withOpacity(0.6), fontSize: 12),
      itemDescStyleSuccess: itemTitleStyleSuccess ?? TextStyle(color: DxStyle.$00AE66.withOpacity(0.6), fontSize: 12),
      itemDescStyleWarning: itemTitleStyleWarning ?? TextStyle(color: DxStyle.$FA3F3F.withOpacity(0.6), fontSize: 12),
      cancelStyle: cancelStyle ?? DxStyle.$222222$14$W500,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0),
      titlePadding: titlePadding ?? const EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
    );
  }

  const DxActionSheetThemeData.raw({
    required this.topRadius,
    required this.titleStyle,
    required this.itemTitleStyle,
    required this.itemTitleStyleLink,
    required this.itemTitleStyleSuccess,
    required this.itemTitleStyleWarning,
    required this.itemDescStyle,
    required this.itemDescStyleLink,
    required this.itemDescStyleSuccess,
    required this.itemDescStyleWarning,
    required this.cancelStyle,
    required this.contentPadding,
    required this.titlePadding,
  });

  DxActionSheetThemeData copyWith({
    double? topRadius,
    TextStyle? titleStyle,
    TextStyle? itemTitleStyle,
    TextStyle? itemTitleStyleLink,
    TextStyle? itemTitleStyleSuccess,
    TextStyle? itemTitleStyleWarning,
    TextStyle? itemDescStyle,
    TextStyle? itemDescStyleLink,
    TextStyle? itemDescStyleSuccess,
    TextStyle? itemDescStyleWarning,
    TextStyle? cancelStyle,
    EdgeInsets? contentPadding,
    EdgeInsets? titlePadding,
  }) {
    return DxActionSheetThemeData(
      topRadius: topRadius ?? this.topRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      itemTitleStyle: itemTitleStyle ?? this.itemTitleStyle,
      itemTitleStyleLink: itemTitleStyleLink ?? this.itemTitleStyleLink,
      itemTitleStyleSuccess: itemTitleStyleSuccess ?? this.itemTitleStyleSuccess,
      itemTitleStyleWarning: itemTitleStyleWarning ?? this.itemTitleStyleWarning,
      itemDescStyle: itemDescStyle ?? this.itemDescStyle,
      itemDescStyleLink: itemDescStyleLink ?? this.itemDescStyle,
      itemDescStyleSuccess: itemDescStyleSuccess ?? this.itemDescStyleSuccess,
      itemDescStyleWarning: itemDescStyleWarning ?? this.itemDescStyleWarning,
      cancelStyle: cancelStyle ?? this.cancelStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      titlePadding: titlePadding ?? this.titlePadding,
    );
  }

  DxActionSheetThemeData merge(DxActionSheetThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      topRadius: other.topRadius,
      titleStyle: other.titleStyle,
      itemTitleStyle: other.itemTitleStyle,
      itemTitleStyleLink: other.itemTitleStyleLink,
      itemTitleStyleSuccess: other.itemTitleStyleSuccess,
      itemTitleStyleWarning: other.itemTitleStyleWarning,
      itemDescStyle: other.itemDescStyle,
      itemDescStyleLink: other.itemDescStyleLink,
      itemDescStyleSuccess: other.itemDescStyleSuccess,
      itemDescStyleWarning: other.itemDescStyleWarning,
      cancelStyle: other.cancelStyle,
      contentPadding: other.contentPadding,
      titlePadding: other.titlePadding,
    );
  }

  static DxActionSheetThemeData lerp(DxActionSheetThemeData? a, DxActionSheetThemeData? b, double t) {
    return DxActionSheetThemeData(
      topRadius: lerpDouble(a?.topRadius, b?.topRadius, t),
      titleStyle: TextStyle.lerp(a?.titleStyle, b?.titleStyle, t),
      itemTitleStyle: TextStyle.lerp(a?.itemTitleStyle, b?.itemTitleStyle, t),
      itemTitleStyleLink: TextStyle.lerp(a?.itemTitleStyleLink, b?.itemTitleStyleLink, t),
      itemTitleStyleSuccess: TextStyle.lerp(a?.itemTitleStyleSuccess, b?.itemTitleStyleSuccess, t),
      itemTitleStyleWarning: TextStyle.lerp(a?.itemTitleStyleWarning, b?.itemTitleStyleWarning, t),
      itemDescStyle: TextStyle.lerp(a?.itemDescStyle, b?.itemDescStyle, t),
      itemDescStyleLink: TextStyle.lerp(a?.itemDescStyleLink, b?.itemDescStyleLink, t),
      itemDescStyleSuccess: TextStyle.lerp(a?.itemDescStyleSuccess, b?.itemDescStyleSuccess, t),
      itemDescStyleWarning: TextStyle.lerp(a?.itemDescStyleWarning, b?.itemDescStyleWarning, t),
      cancelStyle: TextStyle.lerp(a?.cancelStyle, b?.cancelStyle, t),
      contentPadding: EdgeInsets.lerp(a?.contentPadding, b?.contentPadding, t),
      titlePadding: EdgeInsets.lerp(a?.titlePadding, b?.titlePadding, t),
    );
  }
}
