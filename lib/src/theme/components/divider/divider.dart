import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

class DxDividerTheme extends InheritedTheme {
  const DxDividerTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxDividerThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxDividerTheme(
          key: key,
          data: DxDividerTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxDividerThemeData data;

  static DxDividerThemeData of(BuildContext context) {
    final DxDividerTheme? dividerTheme = context.dependOnInheritedWidgetOfExactType<DxDividerTheme>();
    return dividerTheme?.data ?? DxTheme.of(context).dividerTheme;
  }

  @override
  bool updateShouldNotify(DxDividerTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxDividerTheme(data: data, child: child);
}

class DxDividerThemeData {
  final EdgeInsets margin;
  final Color textColor;
  final double fontSize;
  final double lineHeight;
  final Color borderColor;
  final double contentPadding;
  final double contentLeftWidthPercent;
  final double contentRightWidthPercent;

  factory DxDividerThemeData({
    EdgeInsets? margin,
    Color? textColor,
    double? fontSize,
    double? lineHeight,
    Color? borderColor,
    double? contentPadding,
    double? contentLeftWidthPercent,
    double? contentRightWidthPercent,
  }) {
    final double $fontSize = fontSize ?? DxStyle.fontSizeMd;
    return DxDividerThemeData.raw(
      margin: margin ?? EdgeInsets.zero,
      textColor: textColor ?? DxStyle.gray6,
      fontSize: $fontSize,
      lineHeight: lineHeight ?? (24.0 / $fontSize),
      borderColor: borderColor ?? DxStyle.dividerBorderColor,
      contentPadding: contentPadding ?? DxStyle.paddingXs,
      contentLeftWidthPercent: contentLeftWidthPercent ?? 0.1,
      contentRightWidthPercent: contentRightWidthPercent ?? 0.1,
    );
  }

  const DxDividerThemeData.raw({
    required this.margin,
    required this.textColor,
    required this.fontSize,
    required this.lineHeight,
    required this.borderColor,
    required this.contentPadding,
    required this.contentLeftWidthPercent,
    required this.contentRightWidthPercent,
  });

  DxDividerThemeData copyWith({
    EdgeInsets? margin,
    Color? textColor,
    double? fontSize,
    double? lineHeight,
    Color? borderColor,
    double? contentPadding,
    double? contentLeftWidthPercent,
    double? contentRightWidthPercent,
  }) {
    return DxDividerThemeData(
      margin: margin ?? this.margin,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      borderColor: borderColor ?? this.borderColor,
      contentPadding: contentPadding ?? this.contentPadding,
      contentLeftWidthPercent: contentLeftWidthPercent ?? this.contentLeftWidthPercent,
      contentRightWidthPercent: contentRightWidthPercent ?? this.contentRightWidthPercent,
    );
  }

  DxDividerThemeData merge(DxDividerThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      margin: other.margin,
      textColor: other.textColor,
      fontSize: other.fontSize,
      lineHeight: other.lineHeight,
      borderColor: other.borderColor,
      contentPadding: other.contentPadding,
      contentLeftWidthPercent: other.contentLeftWidthPercent,
      contentRightWidthPercent: other.contentRightWidthPercent,
    );
  }

  static DxDividerThemeData lerp(DxDividerThemeData? a, DxDividerThemeData? b, double t) {
    return DxDividerThemeData(
      margin: EdgeInsets.lerp(a?.margin, b?.margin, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      lineHeight: lerpDouble(a?.lineHeight, b?.lineHeight, t),
      borderColor: Color.lerp(a?.borderColor, b?.borderColor, t),
      contentPadding: lerpDouble(a?.contentPadding, b?.contentPadding, t),
      contentLeftWidthPercent: lerpDouble(a?.contentLeftWidthPercent, b?.contentLeftWidthPercent, t),
      contentRightWidthPercent: lerpDouble(a?.contentRightWidthPercent, b?.contentRightWidthPercent, t),
    );
  }
}
