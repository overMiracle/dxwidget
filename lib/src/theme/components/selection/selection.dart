import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 选择主题
class DxSelectionTheme extends InheritedTheme {
  const DxSelectionTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxSelectionThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxSelectionTheme(
          key: key,
          data: DxSelectionTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxSelectionThemeData data;

  static DxSelectionThemeData of(BuildContext context) {
    final DxSelectionTheme? selectionTheme = context.dependOnInheritedWidgetOfExactType<DxSelectionTheme>();
    return selectionTheme?.data ?? DxTheme.of(context).selectionTheme;
  }

  @override
  bool updateShouldNotify(DxSelectionTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxSelectionTheme(data: data, child: child);
}

class DxSelectionThemeData {
  /// menu 正常文本样式
  final TextStyle? menuNormalTextStyle;

  /// menu 选中文本样式
  final TextStyle? menuSelectedTextStyle;

  /// tag 正常文本样式
  final TextStyle tagNormalTextStyle;

  /// tag 选中文本样式
  final TextStyle tagSelectedTextStyle;

  /// tag 圆角
  final double tagRadius;

  /// tag 正常背景色
  final Color? tagNormalBackgroundColor;

  /// tag 选中背景色
  final Color? tagSelectedBackgroundColor;

  /// 输入选项标题文本样式
  final TextStyle? rangeTitleTextStyle;

  /// 输入提示文本样式
  final TextStyle? hintTextStyle;

  /// 输入框默认文本样式
  final TextStyle? inputTextStyle;

  /// item 正常字体样式
  final TextStyle? itemNormalTextStyle;

  /// item 选中文本样式
  final TextStyle? itemSelectedTextStyle;

  /// item 仅加粗样式
  final TextStyle? itemBoldTextStyle;

  /// 三级 item 背景色
  final Color deepNormalBgColor;

  /// 三级 item 选中背景色
  final Color deepSelectBgColor;

  /// 二级 item 背景色
  final Color middleNormalBgColor;

  /// 二级 item 选中背景色
  final Color middleSelectBgColor;

  /// 一级 item 背景色
  final Color lightNormalBgColor;

  /// 一级 item 选中背景色
  final Color lightSelectBgColor;

  /// 重置按钮颜色
  final TextStyle? resetTextStyle;

  /// 更多筛选-标题文本样式
  final TextStyle? titleForMoreTextStyle;

  /// 选项-显示文本
  final TextStyle? optionTextStyle;

  /// 更多文本样式
  final TextStyle? moreTextStyle;

  /// 跳转二级页-正常文本样式
  final TextStyle flayerNormalTextStyle;

  /// 跳转二级页-选中文本样式
  final TextStyle flayerSelectedTextStyle;

  /// 跳转二级页-加粗文本样式
  final TextStyle flayerBoldTextStyle;

  factory DxSelectionThemeData({
    TextStyle? menuNormalTextStyle,
    TextStyle? menuSelectedTextStyle,
    TextStyle? tagNormalTextStyle,
    TextStyle? tagSelectedTextStyle,
    double? tagRadius,
    Color? tagNormalBackgroundColor,
    Color? tagSelectedBackgroundColor,
    TextStyle? hintTextStyle,
    TextStyle? rangeTitleTextStyle,
    TextStyle? inputTextStyle,
    TextStyle? itemNormalTextStyle,
    TextStyle? itemSelectedTextStyle,
    TextStyle? itemBoldTextStyle,
    Color? deepNormalBgColor,
    Color? deepSelectBgColor,
    Color? middleNormalBgColor,
    Color? middleSelectBgColor,
    Color? lightNormalBgColor,
    Color? lightSelectBgColor,
    TextStyle? resetTextStyle,
    TextStyle? titleForMoreTextStyle,
    TextStyle? optionTextStyle,
    TextStyle? moreTextStyle,
    TextStyle? flayerNormalTextStyle,
    TextStyle? flayerSelectedTextStyle,
    TextStyle? flayerBoldTextStyle,
  }) {
    return DxSelectionThemeData.raw(
      menuNormalTextStyle: menuNormalTextStyle ?? DxStyle.$5E5E5E$14,
      menuSelectedTextStyle: menuSelectedTextStyle ?? DxStyle.$0984F9$14,
      tagNormalTextStyle: tagNormalTextStyle ?? DxStyle.$222222$12,
      tagSelectedTextStyle: tagSelectedTextStyle ?? DxStyle.$0984F9$12,
      tagRadius: tagRadius ?? 4.0,
      tagNormalBackgroundColor: tagNormalBackgroundColor ?? DxStyle.$F8F8F8,
      tagSelectedBackgroundColor: tagSelectedBackgroundColor ?? DxStyle.$0984F9.withOpacity(0.12),
      hintTextStyle: hintTextStyle ?? DxStyle.$CCCCCC$14,
      rangeTitleTextStyle: rangeTitleTextStyle ?? DxStyle.$22222$16$500,
      inputTextStyle: inputTextStyle ?? DxStyle.$222222$14,
      itemNormalTextStyle: itemNormalTextStyle ?? DxStyle.$222222$14,
      itemSelectedTextStyle: itemSelectedTextStyle ?? DxStyle.$0984F9$14$W500,
      itemBoldTextStyle: itemBoldTextStyle ?? DxStyle.$222222$14$W500,
      deepNormalBgColor: deepNormalBgColor ?? DxStyle.$F0F0F0,
      deepSelectBgColor: deepSelectBgColor ?? DxStyle.$F8F8F8,
      middleNormalBgColor: middleNormalBgColor ?? DxStyle.$F8F8F8,
      middleSelectBgColor: middleSelectBgColor ?? DxStyle.white,
      lightNormalBgColor: lightNormalBgColor ?? DxStyle.white,
      lightSelectBgColor: lightSelectBgColor ?? DxStyle.white,
      resetTextStyle: resetTextStyle ?? DxStyle.$666666$14,
      titleForMoreTextStyle: titleForMoreTextStyle ?? DxStyle.$222222$14$W500,
      optionTextStyle: optionTextStyle ?? DxStyle.$0984F9$14,
      moreTextStyle: moreTextStyle ?? DxStyle.$999999$12,
      flayerNormalTextStyle: flayerNormalTextStyle ?? DxStyle.$22222$15,
      flayerSelectedTextStyle: flayerSelectedTextStyle ?? DxStyle.$0984F9$15,
      flayerBoldTextStyle: flayerBoldTextStyle ?? DxStyle.$22222$15,
    );
  }

  const DxSelectionThemeData.raw({
    required this.menuNormalTextStyle,
    required this.menuSelectedTextStyle,
    required this.tagNormalTextStyle,
    required this.tagSelectedTextStyle,
    required this.tagRadius,
    required this.tagNormalBackgroundColor,
    required this.tagSelectedBackgroundColor,
    required this.hintTextStyle,
    required this.rangeTitleTextStyle,
    required this.inputTextStyle,
    required this.itemNormalTextStyle,
    required this.itemSelectedTextStyle,
    required this.itemBoldTextStyle,
    required this.deepNormalBgColor,
    required this.deepSelectBgColor,
    required this.middleNormalBgColor,
    required this.middleSelectBgColor,
    required this.lightNormalBgColor,
    required this.lightSelectBgColor,
    required this.resetTextStyle,
    required this.titleForMoreTextStyle,
    required this.optionTextStyle,
    required this.moreTextStyle,
    required this.flayerNormalTextStyle,
    required this.flayerSelectedTextStyle,
    required this.flayerBoldTextStyle,
  });

  DxSelectionThemeData copyWith({
    TextStyle? menuNormalTextStyle,
    TextStyle? menuSelectedTextStyle,
    TextStyle? tagNormalTextStyle,
    TextStyle? tagSelectedTextStyle,
    double? tagRadius,
    Color? tagNormalBackgroundColor,
    Color? tagSelectedBackgroundColor,
    TextStyle? hintTextStyle,
    TextStyle? rangeTitleTextStyle,
    TextStyle? inputTextStyle,
    TextStyle? itemNormalTextStyle,
    TextStyle? itemSelectedTextStyle,
    TextStyle? itemBoldTextStyle,
    Color? deepNormalBgColor,
    Color? deepSelectBgColor,
    Color? middleNormalBgColor,
    Color? middleSelectBgColor,
    Color? lightNormalBgColor,
    Color? lightSelectBgColor,
    TextStyle? resetTextStyle,
    TextStyle? titleForMoreTextStyle,
    TextStyle? optionTextStyle,
    TextStyle? moreTextStyle,
    TextStyle? flayerNormalTextStyle,
    TextStyle? flayerSelectedTextStyle,
    TextStyle? flayerBoldTextStyle,
  }) {
    return DxSelectionThemeData(
      menuNormalTextStyle: menuNormalTextStyle ?? this.menuNormalTextStyle,
      menuSelectedTextStyle: menuSelectedTextStyle ?? this.menuSelectedTextStyle,
      tagNormalTextStyle: tagNormalTextStyle ?? this.tagNormalTextStyle,
      tagSelectedTextStyle: tagSelectedTextStyle ?? this.tagSelectedTextStyle,
      tagRadius: tagRadius ?? this.tagRadius,
      tagNormalBackgroundColor: tagNormalBackgroundColor ?? this.tagNormalBackgroundColor,
      tagSelectedBackgroundColor: tagSelectedBackgroundColor ?? this.tagSelectedBackgroundColor,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      rangeTitleTextStyle: rangeTitleTextStyle ?? this.rangeTitleTextStyle,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      itemNormalTextStyle: itemNormalTextStyle ?? this.itemNormalTextStyle,
      itemSelectedTextStyle: itemSelectedTextStyle ?? this.itemSelectedTextStyle,
      itemBoldTextStyle: itemBoldTextStyle ?? this.itemBoldTextStyle,
      deepNormalBgColor: deepNormalBgColor ?? this.deepNormalBgColor,
      deepSelectBgColor: deepSelectBgColor ?? this.deepSelectBgColor,
      middleNormalBgColor: middleNormalBgColor ?? this.middleNormalBgColor,
      middleSelectBgColor: middleSelectBgColor ?? this.middleSelectBgColor,
      lightNormalBgColor: lightNormalBgColor ?? this.lightNormalBgColor,
      lightSelectBgColor: lightSelectBgColor ?? this.lightSelectBgColor,
      resetTextStyle: resetTextStyle ?? this.resetTextStyle,
      titleForMoreTextStyle: titleForMoreTextStyle ?? this.titleForMoreTextStyle,
      optionTextStyle: optionTextStyle ?? this.optionTextStyle,
      moreTextStyle: moreTextStyle ?? this.moreTextStyle,
      flayerNormalTextStyle: flayerNormalTextStyle ?? this.flayerNormalTextStyle,
      flayerSelectedTextStyle: flayerSelectedTextStyle ?? this.flayerSelectedTextStyle,
      flayerBoldTextStyle: flayerBoldTextStyle ?? this.flayerBoldTextStyle,
    );
  }

  DxSelectionThemeData merge(DxSelectionThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      menuNormalTextStyle: other.menuNormalTextStyle,
      menuSelectedTextStyle: other.menuSelectedTextStyle,
      tagNormalTextStyle: other.tagNormalTextStyle,
      tagSelectedTextStyle: other.tagSelectedTextStyle,
      tagRadius: other.tagRadius,
      tagNormalBackgroundColor: other.tagNormalBackgroundColor,
      tagSelectedBackgroundColor: other.tagSelectedBackgroundColor,
      hintTextStyle: other.hintTextStyle,
      rangeTitleTextStyle: other.rangeTitleTextStyle,
      inputTextStyle: other.inputTextStyle,
      itemNormalTextStyle: other.itemNormalTextStyle,
      itemSelectedTextStyle: other.itemSelectedTextStyle,
      itemBoldTextStyle: other.itemBoldTextStyle,
      deepNormalBgColor: other.deepNormalBgColor,
      deepSelectBgColor: other.deepSelectBgColor,
      middleNormalBgColor: other.middleNormalBgColor,
      middleSelectBgColor: other.middleSelectBgColor,
      lightNormalBgColor: other.lightNormalBgColor,
      lightSelectBgColor: other.lightSelectBgColor,
      resetTextStyle: other.resetTextStyle,
      titleForMoreTextStyle: other.titleForMoreTextStyle,
      optionTextStyle: other.optionTextStyle,
      moreTextStyle: other.moreTextStyle,
      flayerNormalTextStyle: other.flayerNormalTextStyle,
      flayerSelectedTextStyle: other.flayerSelectedTextStyle,
      flayerBoldTextStyle: other.flayerBoldTextStyle,
    );
  }

  static DxSelectionThemeData lerp(DxSelectionThemeData? a, DxSelectionThemeData? b, double t) {
    return DxSelectionThemeData(
      menuNormalTextStyle: TextStyle.lerp(a?.menuNormalTextStyle, b?.menuNormalTextStyle, t),
      menuSelectedTextStyle: TextStyle.lerp(a?.menuSelectedTextStyle, b?.menuSelectedTextStyle, t),
      tagNormalTextStyle: TextStyle.lerp(a?.tagNormalTextStyle, b?.tagNormalTextStyle, t),
      tagSelectedTextStyle: TextStyle.lerp(a?.tagSelectedTextStyle, b?.tagSelectedTextStyle, t),
      tagRadius: lerpDouble(a?.tagRadius, b?.tagRadius, t),
      tagNormalBackgroundColor: Color.lerp(a?.tagNormalBackgroundColor, b?.tagNormalBackgroundColor, t),
      tagSelectedBackgroundColor: Color.lerp(a?.tagSelectedBackgroundColor, b?.tagSelectedBackgroundColor, t),
      hintTextStyle: TextStyle.lerp(a?.hintTextStyle, b?.hintTextStyle, t),
      rangeTitleTextStyle: TextStyle.lerp(a?.rangeTitleTextStyle, b?.rangeTitleTextStyle, t),
      inputTextStyle: TextStyle.lerp(a?.inputTextStyle, b?.inputTextStyle, t),
      itemNormalTextStyle: TextStyle.lerp(a?.itemNormalTextStyle, b?.itemNormalTextStyle, t),
      itemSelectedTextStyle: TextStyle.lerp(a?.itemSelectedTextStyle, b?.itemSelectedTextStyle, t),
      deepNormalBgColor: Color.lerp(a?.deepNormalBgColor, b?.deepNormalBgColor, t),
      deepSelectBgColor: Color.lerp(a?.deepSelectBgColor, b?.deepSelectBgColor, t),
      middleNormalBgColor: Color.lerp(a?.middleNormalBgColor, b?.middleNormalBgColor, t),
      middleSelectBgColor: Color.lerp(a?.middleSelectBgColor, b?.middleSelectBgColor, t),
      lightNormalBgColor: Color.lerp(a?.lightNormalBgColor, b?.lightNormalBgColor, t),
      lightSelectBgColor: Color.lerp(a?.lightSelectBgColor, b?.lightSelectBgColor, t),
      resetTextStyle: TextStyle.lerp(a?.resetTextStyle, b?.resetTextStyle, t),
      titleForMoreTextStyle: TextStyle.lerp(a?.titleForMoreTextStyle, b?.titleForMoreTextStyle, t),
      optionTextStyle: TextStyle.lerp(a?.optionTextStyle, b?.optionTextStyle, t),
      moreTextStyle: TextStyle.lerp(a?.moreTextStyle, b?.moreTextStyle, t),
      flayerNormalTextStyle: TextStyle.lerp(a?.flayerNormalTextStyle, b?.flayerNormalTextStyle, t),
      flayerSelectedTextStyle: TextStyle.lerp(a?.flayerSelectedTextStyle, b?.flayerSelectedTextStyle, t),
      flayerBoldTextStyle: TextStyle.lerp(a?.flayerBoldTextStyle, b?.flayerBoldTextStyle, t),
    );
  }
}
