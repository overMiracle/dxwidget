import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

class DxActionBarTheme extends InheritedTheme {
  const DxActionBarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxActionBarThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxActionBarTheme(
          key: key,
          data: DxActionBarTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxActionBarThemeData data;

  static DxActionBarThemeData of(BuildContext context) {
    final DxActionBarTheme? actionBarTheme = context.dependOnInheritedWidgetOfExactType<DxActionBarTheme>();
    return actionBarTheme?.data ?? DxTheme.of(context).actionBarTheme;
  }

  @override
  bool updateShouldNotify(DxActionBarTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxActionBarTheme(data: data, child: child);
  }
}

class DxActionBarThemeData {
  final Color backgroundColor;
  final double height;
  final double iconWidth;
  final double iconHeight;
  final Color iconColor;
  final double iconFontSize;
  final Color iconActiveColor;
  final Color iconTextColor;
  final double buttonHeight;
  final LinearGradient buttonWarningColor;
  final LinearGradient buttonDangerColor;

  factory DxActionBarThemeData({
    Color? backgroundColor,
    double? height,
    double? iconWidth,
    double? iconHeight,
    Color? iconColor,
    double? iconFontSize,
    Color? iconActiveColor,
    Color? iconTextColor,
    double? buttonHeight,
    LinearGradient? buttonWarningColor,
    LinearGradient? buttonDangerColor,
  }) {
    return DxActionBarThemeData.raw(
      backgroundColor: backgroundColor ?? DxStyle.white,
      height: height ?? 66.0,
      iconWidth: iconWidth ?? 48.0,
      iconHeight: iconHeight ?? 24.0,
      iconColor: iconColor ?? DxStyle.gray8,
      iconFontSize: iconFontSize ?? DxStyle.fontSizeXs,
      iconActiveColor: iconActiveColor ?? DxStyle.activeColor,
      iconTextColor: iconTextColor ?? DxStyle.gray7,
      buttonHeight: buttonHeight ?? 46.0,
      buttonWarningColor: buttonWarningColor ?? DxStyle.gradientOrange,
      buttonDangerColor: buttonDangerColor ?? DxStyle.gradientRed,
    );
  }

  const DxActionBarThemeData.raw({
    required this.backgroundColor,
    required this.height,
    required this.iconWidth,
    required this.iconHeight,
    required this.iconColor,
    required this.iconFontSize,
    required this.iconActiveColor,
    required this.iconTextColor,
    required this.buttonHeight,
    required this.buttonWarningColor,
    required this.buttonDangerColor,
  });

  DxActionBarThemeData copyWith({
    Color? backgroundColor,
    double? height,
    double? iconWidth,
    double? iconHeight,
    Color? iconColor,
    double? iconFontSize,
    Color? iconActiveColor,
    Color? iconTextColor,
    double? buttonHeight,
    LinearGradient? buttonWarningColor,
    LinearGradient? buttonDangerColor,
  }) {
    return DxActionBarThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      height: height ?? this.height,
      iconWidth: iconWidth ?? this.iconWidth,
      iconHeight: iconHeight ?? this.iconHeight,
      iconColor: iconColor ?? this.iconColor,
      iconFontSize: iconFontSize ?? this.iconFontSize,
      iconActiveColor: iconActiveColor ?? this.iconActiveColor,
      iconTextColor: iconTextColor ?? this.iconTextColor,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      buttonWarningColor: buttonWarningColor ?? this.buttonWarningColor,
      buttonDangerColor: buttonDangerColor ?? this.buttonDangerColor,
    );
  }

  DxActionBarThemeData merge(DxActionBarThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      backgroundColor: other.backgroundColor,
      height: other.height,
      iconWidth: other.iconWidth,
      iconHeight: other.iconHeight,
      iconColor: other.iconColor,
      iconFontSize: other.iconFontSize,
      iconActiveColor: other.iconActiveColor,
      iconTextColor: other.iconTextColor,
      buttonHeight: other.buttonHeight,
      buttonWarningColor: other.buttonWarningColor,
      buttonDangerColor: other.buttonDangerColor,
    );
  }

  static DxActionBarThemeData lerp(DxActionBarThemeData? a, DxActionBarThemeData? b, double t) {
    return DxActionBarThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      height: lerpDouble(a?.height, b?.height, t),
      iconWidth: lerpDouble(a?.iconWidth, b?.iconWidth, t),
      iconHeight: lerpDouble(a?.iconHeight, b?.iconHeight, t),
      iconColor: Color.lerp(a?.iconColor, b?.iconColor, t),
      iconFontSize: lerpDouble(a?.iconFontSize, b?.iconFontSize, t),
      iconActiveColor: Color.lerp(a?.iconActiveColor, b?.iconActiveColor, t),
      iconTextColor: Color.lerp(a?.iconTextColor, b?.iconTextColor, t),
      buttonHeight: lerpDouble(a?.buttonHeight, b?.buttonHeight, t),
      buttonWarningColor: LinearGradient.lerp(a?.buttonWarningColor, b?.buttonWarningColor, t),
      buttonDangerColor: LinearGradient.lerp(a?.buttonDangerColor, b?.buttonDangerColor, t),
    );
  }
}
