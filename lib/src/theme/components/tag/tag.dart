import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 标签主题
class DxTagTheme extends InheritedTheme {
  const DxTagTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxTagThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxTagTheme(
          key: key,
          data: DxTagTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxTagThemeData data;

  static DxTagThemeData of(BuildContext context) {
    final DxTagTheme? tagTheme = context.dependOnInheritedWidgetOfExactType<DxTagTheme>();
    return tagTheme?.data ?? DxTheme.of(context).tagTheme;
  }

  @override
  bool updateShouldNotify(DxTagTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxTagTheme(data: data, child: child);
}

class DxTagThemeData {
  factory DxTagThemeData({
    EdgeInsets? padding,
    Color? textColor,
    double? fontSize,
    double? borderRadius,
    Color? dangerColor,
    Color? primaryColor,
    Color? successColor,
    Color? warningColor,
    Color? defaultColor,
    Color? plainBackgroundColor,
  }) {
    final double $fontSize = fontSize ?? DxStyle.fontSizeSm;
    return DxTagThemeData.raw(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: DxStyle.paddingBase),
      textColor: textColor ?? DxStyle.gray6,
      fontSize: $fontSize,
      borderRadius: borderRadius ?? 2.0,
      dangerColor: dangerColor ?? DxStyle.red,
      primaryColor: primaryColor ?? DxStyle.blue,
      successColor: successColor ?? DxStyle.green,
      warningColor: warningColor ?? DxStyle.orange,
      defaultColor: defaultColor ?? DxStyle.gray6,
      plainBackgroundColor: plainBackgroundColor ?? DxStyle.white,
    );
  }

  const DxTagThemeData.raw({
    required this.padding,
    required this.textColor,
    required this.fontSize,
    required this.borderRadius,
    required this.dangerColor,
    required this.primaryColor,
    required this.successColor,
    required this.warningColor,
    required this.defaultColor,
    required this.plainBackgroundColor,
  });

  final EdgeInsets padding;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final Color dangerColor;
  final Color primaryColor;
  final Color successColor;
  final Color warningColor;
  final Color defaultColor;
  final Color plainBackgroundColor;

  DxTagThemeData copyWith({
    EdgeInsets? padding,
    Color? textColor,
    double? fontSize,
    double? borderRadius,
    double? lineHeight,
    Color? dangerColor,
    Color? primaryColor,
    Color? successColor,
    Color? warningColor,
    Color? defaultColor,
    Color? plainBackgroundColor,
  }) {
    return DxTagThemeData(
      padding: padding ?? this.padding,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      borderRadius: borderRadius ?? this.borderRadius,
      dangerColor: dangerColor ?? this.dangerColor,
      primaryColor: primaryColor ?? this.primaryColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      defaultColor: defaultColor ?? this.defaultColor,
      plainBackgroundColor: plainBackgroundColor ?? this.plainBackgroundColor,
    );
  }

  DxTagThemeData merge(DxTagThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      padding: other.padding,
      textColor: other.textColor,
      fontSize: other.fontSize,
      borderRadius: other.borderRadius,
      dangerColor: other.dangerColor,
      primaryColor: other.primaryColor,
      successColor: other.successColor,
      warningColor: other.warningColor,
      defaultColor: other.defaultColor,
      plainBackgroundColor: other.plainBackgroundColor,
    );
  }

  static DxTagThemeData lerp(DxTagThemeData? a, DxTagThemeData? b, double t) {
    return DxTagThemeData(
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      borderRadius: lerpDouble(a?.borderRadius, b?.borderRadius, t),
      dangerColor: Color.lerp(a?.dangerColor, b?.dangerColor, t),
      primaryColor: Color.lerp(a?.primaryColor, b?.primaryColor, t),
      successColor: Color.lerp(a?.successColor, b?.successColor, t),
      warningColor: Color.lerp(a?.warningColor, b?.warningColor, t),
      defaultColor: Color.lerp(a?.defaultColor, b?.defaultColor, t),
      plainBackgroundColor: Color.lerp(a?.plainBackgroundColor, b?.plainBackgroundColor, t),
    );
  }
}
