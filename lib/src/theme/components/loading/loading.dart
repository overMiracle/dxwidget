import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 加载主题
class DxLoadingTheme extends InheritedTheme {
  const DxLoadingTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxLoadingThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxLoadingTheme(
          key: key,
          data: DxLoadingTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxLoadingThemeData data;

  static DxLoadingThemeData of(BuildContext context) {
    final DxLoadingTheme? loadingTheme = context.dependOnInheritedWidgetOfExactType<DxLoadingTheme>();
    return loadingTheme?.data ?? DxTheme.of(context).loadingTheme;
  }

  @override
  bool updateShouldNotify(DxLoadingTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) => DxLoadingTheme(data: data, child: child);
}

class DxLoadingThemeData {
  final Color textColor;
  final double textFontSize;
  final Color spinnerColor;
  final double spinnerSize;
  final Duration spinnerAnimationDuration;

  factory DxLoadingThemeData({
    Color? textColor,
    double? textFontSize,
    Color? spinnerColor,
    double? spinnerSize,
    Duration? spinnerAnimationDuration,
  }) {
    return DxLoadingThemeData.raw(
      textColor: textColor ?? DxStyle.gray6,
      textFontSize: textFontSize ?? DxStyle.fontSizeMd,
      spinnerColor: spinnerColor ?? DxStyle.gray5,
      spinnerSize: spinnerSize ?? 30.0,
      spinnerAnimationDuration: spinnerAnimationDuration ?? const Duration(milliseconds: 800),
    );
  }

  const DxLoadingThemeData.raw({
    required this.textColor,
    required this.textFontSize,
    required this.spinnerColor,
    required this.spinnerSize,
    required this.spinnerAnimationDuration,
  });

  DxLoadingThemeData copyWith({
    Color? textColor,
    double? textFontSize,
    Color? spinnerColor,
    double? spinnerSize,
    Duration? spinnerAnimationDuration,
  }) {
    return DxLoadingThemeData(
      textColor: textColor ?? this.textColor,
      textFontSize: textFontSize ?? this.textFontSize,
      spinnerColor: spinnerColor ?? this.spinnerColor,
      spinnerSize: spinnerSize ?? this.spinnerSize,
      spinnerAnimationDuration: spinnerAnimationDuration ?? this.spinnerAnimationDuration,
    );
  }

  DxLoadingThemeData merge(DxLoadingThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      textColor: other.textColor,
      textFontSize: other.textFontSize,
      spinnerColor: other.spinnerColor,
      spinnerSize: other.spinnerSize,
      spinnerAnimationDuration: other.spinnerAnimationDuration,
    );
  }

  static DxLoadingThemeData lerp(DxLoadingThemeData? a, DxLoadingThemeData? b, double t) {
    return DxLoadingThemeData(
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      textFontSize: lerpDouble(a?.textFontSize, b?.textFontSize, t),
      spinnerColor: Color.lerp(a?.spinnerColor, b?.spinnerColor, t),
      spinnerSize: lerpDouble(a?.spinnerSize, b?.spinnerSize, t),
      spinnerAnimationDuration: lerpDuration(
        a?.spinnerAnimationDuration ?? Duration.zero,
        b?.spinnerAnimationDuration ?? Duration.zero,
        t,
      ),
    );
  }
}
