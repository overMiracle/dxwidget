import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 倒计时主题
class DxCountDownTheme extends InheritedTheme {
  const DxCountDownTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxCountDownThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxCountDownTheme(
          key: key,
          data: DxCountDownTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxCountDownThemeData data;

  static DxCountDownThemeData of(BuildContext context) {
    final DxCountDownTheme? countDownTheme = context.dependOnInheritedWidgetOfExactType<DxCountDownTheme>();
    return countDownTheme?.data ?? DxTheme.of(context).countDownTheme;
  }

  @override
  bool updateShouldNotify(DxCountDownTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxCountDownTheme(data: data, child: child);
  }
}

class DxCountDownThemeData {
  final Color textColor;
  final double fontSize;
  final double lineHeight;

  factory DxCountDownThemeData({
    Color? textColor,
    double? fontSize,
    double? lineHeight,
  }) {
    final double $fontSize = fontSize ?? DxStyle.fontSizeMd;
    return DxCountDownThemeData.raw(
      textColor: textColor ?? DxStyle.textColor,
      fontSize: $fontSize,
      lineHeight: lineHeight ?? (DxStyle.lineHeightMd / $fontSize),
    );
  }

  const DxCountDownThemeData.raw({
    required this.textColor,
    required this.fontSize,
    required this.lineHeight,
  });

  DxCountDownThemeData copyWith({
    Color? textColor,
    double? fontSize,
    double? lineHeight,
  }) {
    return DxCountDownThemeData(
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }

  DxCountDownThemeData merge(DxCountDownThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      textColor: other.textColor,
      fontSize: other.fontSize,
      lineHeight: other.lineHeight,
    );
  }

  static DxCountDownThemeData lerp(DxCountDownThemeData? a, DxCountDownThemeData? b, double t) {
    return DxCountDownThemeData(
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      lineHeight: lerpDouble(a?.lineHeight, b?.lineHeight, t),
    );
  }
}
