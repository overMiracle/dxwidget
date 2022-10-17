import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 选择主题
class DxPickerTheme extends InheritedTheme {
  const DxPickerTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxPickerThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxPickerTheme(
          key: key,
          data: DxPickerTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxPickerThemeData data;

  static DxPickerThemeData of(BuildContext context) {
    final DxPickerTheme? pickerTheme = context.dependOnInheritedWidgetOfExactType<DxPickerTheme>();
    return pickerTheme?.data ?? DxTheme.of(context).pickerTheme;
  }

  @override
  bool updateShouldNotify(DxPickerTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxPickerTheme(data: data, child: child);
}

class DxPickerThemeData {
  /// 选择器的背景色
  final Color backgroundColor;

  /// 高度
  final double pickerHeight;

  /// 选择器标题的高度
  final double titleHeight;

  /// 选择器列表的高度
  final double itemHeight;

  /// 分割线颜色
  final Color dividerColor;

  /// 边角弧度
  final double cornerRadius;

  /// 取消文字的样式
  final TextStyle cancelTextStyle;

  /// 标题文字的样式
  final TextStyle titleTextStyle;

  /// 确认文字的样式
  final TextStyle confirmTextStyle;

  /// 日期选择器列表的文字样式
  final TextStyle itemTextStyle;

  /// 日期选择器列表选中的文字样式
  final TextStyle itemTextSelectedStyle;

  /// tag 字体样式
  final TextStyle? tagTextStyle;

  /// tag 选中字体样式
  final TextStyle? tagSelectedTextStyle;

  /// tag背景颜色
  final Color? tagBgColor;

  /// tag选中的颜色
  final Color? tagSelectedBgColor;

  factory DxPickerThemeData({
    Color? backgroundColor,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    Color? dividerColor,
    double? cornerRadius,
    TextStyle? cancelTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? itemTextStyle,
    TextStyle? itemTextSelectedStyle,
    TextStyle? tagTextStyle,
    TextStyle? tagSelectedTextStyle,
    Color? tagBgColor,
    Color? tagSelectedBgColor,
  }) {
    return DxPickerThemeData.raw(
      backgroundColor: backgroundColor ?? Colors.white,
      pickerHeight: pickerHeight ?? 320.0,
      titleHeight: titleHeight ?? 48.0,
      itemHeight: itemHeight ?? 48.0,
      dividerColor: dividerColor ?? DxStyle.$F0F0F0,
      cornerRadius: cornerRadius ?? 8,
      cancelTextStyle: DxStyle.$666666$13$W500,
      titleTextStyle: DxStyle.$22222$15$W500,
      confirmTextStyle: DxStyle.$0984F9$13$W500,
      itemTextStyle: DxStyle.$222222$14$W500,
      itemTextSelectedStyle: DxStyle.$0984F9$14$W500,
      tagTextStyle: DxStyle.$666666$13$W500,
      tagSelectedTextStyle: DxStyle.$3E7AF5$13W500,
      tagBgColor: DxStyle.$F8F8F8,
      tagSelectedBgColor: DxStyle.$ECF5FF,
    );
  }

  const DxPickerThemeData.raw({
    required this.backgroundColor,
    required this.pickerHeight,
    required this.titleHeight,
    required this.itemHeight,
    required this.dividerColor,
    required this.cornerRadius,
    required this.cancelTextStyle,
    required this.titleTextStyle,
    required this.confirmTextStyle,
    required this.itemTextStyle,
    required this.itemTextSelectedStyle,
    required this.tagTextStyle,
    required this.tagSelectedTextStyle,
    required this.tagBgColor,
    required this.tagSelectedBgColor,
  });

  DxPickerThemeData copyWith({
    Color? backgroundColor,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    Color? dividerColor,
    double? cornerRadius,
    TextStyle? cancelTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? itemTextStyle,
    TextStyle? itemTextSelectedStyle,
    TextStyle? tagTextStyle,
    TextStyle? tagSelectedTextStyle,
    Color? tagBgColor,
    Color? tagSelectedBgColor,
  }) {
    return DxPickerThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pickerHeight: pickerHeight ?? this.pickerHeight,
      titleHeight: titleHeight ?? this.titleHeight,
      itemHeight: itemHeight ?? this.itemHeight,
      dividerColor: dividerColor ?? this.dividerColor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      cancelTextStyle: cancelTextStyle ?? this.cancelTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      confirmTextStyle: confirmTextStyle ?? this.confirmTextStyle,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      itemTextSelectedStyle: itemTextSelectedStyle ?? this.itemTextSelectedStyle,
      tagTextStyle: tagTextStyle ?? this.tagTextStyle,
      tagSelectedTextStyle: tagSelectedTextStyle ?? this.tagSelectedTextStyle,
      tagBgColor: tagBgColor ?? this.tagBgColor,
      tagSelectedBgColor: tagSelectedBgColor ?? this.tagSelectedBgColor,
    );
  }

  DxPickerThemeData merge(DxPickerThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      backgroundColor: other.backgroundColor,
      pickerHeight: other.pickerHeight,
      titleHeight: other.titleHeight,
      itemHeight: other.itemHeight,
      dividerColor: other.dividerColor,
      cornerRadius: other.cornerRadius,
      cancelTextStyle: other.cancelTextStyle,
      titleTextStyle: other.titleTextStyle,
      confirmTextStyle: other.confirmTextStyle,
      itemTextStyle: other.itemTextStyle,
      itemTextSelectedStyle: other.itemTextSelectedStyle,
      tagTextStyle: other.tagTextStyle,
      tagSelectedTextStyle: other.tagSelectedTextStyle,
      tagBgColor: other.tagBgColor,
      tagSelectedBgColor: other.tagSelectedBgColor,
    );
  }

  static DxPickerThemeData lerp(DxPickerThemeData? a, DxPickerThemeData? b, double t) {
    return DxPickerThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      pickerHeight: lerpDouble(a?.pickerHeight, b?.pickerHeight, t),
      titleHeight: lerpDouble(a?.titleHeight, b?.titleHeight, t),
      itemHeight: lerpDouble(a?.itemHeight, b?.itemHeight, t),
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      cornerRadius: lerpDouble(a?.cornerRadius, b?.cornerRadius, t),
      cancelTextStyle: TextStyle.lerp(a?.cancelTextStyle, b?.cancelTextStyle, t),
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
      confirmTextStyle: TextStyle.lerp(a?.confirmTextStyle, b?.confirmTextStyle, t),
      itemTextStyle: TextStyle.lerp(a?.itemTextStyle, b?.itemTextStyle, t),
      itemTextSelectedStyle: TextStyle.lerp(a?.itemTextSelectedStyle, b?.itemTextSelectedStyle, t),
      tagTextStyle: TextStyle.lerp(a?.tagTextStyle, b?.tagTextStyle, t),
      tagSelectedTextStyle: TextStyle.lerp(a?.tagSelectedTextStyle, b?.tagSelectedTextStyle, t),
      tagBgColor: Color.lerp(a?.tagBgColor, b?.tagBgColor, t),
      tagSelectedBgColor: Color.lerp(a?.tagSelectedBgColor, b?.tagSelectedBgColor, t),
    );
  }
}
