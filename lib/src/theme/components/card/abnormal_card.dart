import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 异常页面主题
class DxAbnormalCardTheme extends InheritedTheme {
  const DxAbnormalCardTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxAbnormalCardThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxAbnormalCardTheme(
          key: key,
          data: DxAbnormalCardTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxAbnormalCardThemeData data;

  static DxAbnormalCardThemeData of(BuildContext context) {
    final DxAbnormalCardTheme? abnormalCardTheme = context.dependOnInheritedWidgetOfExactType<DxAbnormalCardTheme>();
    return abnormalCardTheme?.data ?? DxTheme.of(context).abnormalCardTheme;
  }

  @override
  bool updateShouldNotify(DxAbnormalCardTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxAbnormalCardTheme(data: data, child: child);
}

class DxAbnormalCardThemeData {
  /// 文案区域标题
  final TextStyle? titleTextStyle;

  /// 文案区域内容
  final TextStyle? contentTextStyle;

  /// 圆角
  final double? btnRadius;

  /// 按钮颜色
  final Color? buttonColor;

  factory DxAbnormalCardThemeData({
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    TextStyle? operateTextStyle,
    double? btnRadius,
    Color? buttonColor,
  }) {
    return DxAbnormalCardThemeData.raw(
      titleTextStyle: titleTextStyle ?? DxStyle.$22222$16$500,
      contentTextStyle: contentTextStyle ?? DxStyle.$CCCCCC$14,
      btnRadius: btnRadius ?? 5,
      buttonColor: buttonColor ?? DxStyle.$4078F4,
    );
  }

  const DxAbnormalCardThemeData.raw({
    required this.titleTextStyle,
    required this.contentTextStyle,
    required this.btnRadius,
    required this.buttonColor,
  });

  DxAbnormalCardThemeData copyWith({
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    double? btnRadius,
    Color? buttonColor,
    Gradient? gradient,
  }) {
    return DxAbnormalCardThemeData(
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      btnRadius: btnRadius ?? this.btnRadius,
      buttonColor: buttonColor ?? this.buttonColor,
    );
  }

  DxAbnormalCardThemeData merge(DxAbnormalCardThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      titleTextStyle: other.titleTextStyle,
      contentTextStyle: other.contentTextStyle,
      btnRadius: other.btnRadius,
      buttonColor: other.buttonColor,
    );
  }

  static DxAbnormalCardThemeData lerp(DxAbnormalCardThemeData? a, DxAbnormalCardThemeData? b, double t) {
    return DxAbnormalCardThemeData(
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
      contentTextStyle: TextStyle.lerp(a?.contentTextStyle, b?.contentTextStyle, t),
      btnRadius: lerpDouble(a?.btnRadius, b?.btnRadius, t),
      buttonColor: Color.lerp(a?.buttonColor, b?.buttonColor, t),
    );
  }
}
