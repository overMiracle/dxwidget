import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// Popup 弹出层
class DxPopupTheme extends InheritedTheme {
  const DxPopupTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxPopupThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxPopupTheme(
          key: key,
          data: DxPopupTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxPopupThemeData data;

  static DxPopupThemeData of(BuildContext context) {
    final DxPopupTheme? popupTheme = context.dependOnInheritedWidgetOfExactType<DxPopupTheme>();
    return popupTheme?.data ?? DxTheme.of(context).popupTheme;
  }

  @override
  bool updateShouldNotify(DxPopupTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxPopupTheme(data: data, child: child);
  }
}

class DxPopupThemeData {
  final Color backgroundColor;
  final Duration transitionDuration;
  final double roundBorderRadius;
  final double closeIconSize;
  final Color closeIconColor;
  final Color closeIconActiveColor;
  final double closeIconMargin;

  factory DxPopupThemeData({
    Color? backgroundColor,
    Duration? transitionDuration,
    double? roundBorderRadius,
    double? closeIconSize,
    Color? closeIconColor,
    Color? closeIconActiveColor,
    double? closeIconMargin,
  }) {
    return DxPopupThemeData.raw(
      backgroundColor: backgroundColor ?? DxStyle.white,
      transitionDuration: transitionDuration ?? DxStyle.animationDuration200,
      roundBorderRadius: roundBorderRadius ?? 16.0,
      closeIconSize: closeIconSize ?? 22.0,
      closeIconColor: closeIconColor ?? DxStyle.gray5,
      closeIconActiveColor: closeIconActiveColor ?? DxStyle.gray6,
      closeIconMargin: closeIconMargin ?? 16.0,
    );
  }

  const DxPopupThemeData.raw({
    required this.backgroundColor,
    required this.transitionDuration,
    required this.roundBorderRadius,
    required this.closeIconSize,
    required this.closeIconColor,
    required this.closeIconActiveColor,
    required this.closeIconMargin,
  });

  DxPopupThemeData copyWith({
    Color? backgroundColor,
    Duration? transitionDuration,
    double? roundBorderRadius,
    double? closeIconSize,
    Color? closeIconColor,
    Color? closeIconActiveColor,
    double? closeIconMargin,
  }) {
    return DxPopupThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      roundBorderRadius: roundBorderRadius ?? this.roundBorderRadius,
      closeIconSize: closeIconSize ?? this.closeIconSize,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      closeIconActiveColor: closeIconActiveColor ?? this.closeIconActiveColor,
      closeIconMargin: closeIconMargin ?? this.closeIconMargin,
    );
  }

  DxPopupThemeData merge(DxPopupThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      backgroundColor: other.backgroundColor,
      transitionDuration: other.transitionDuration,
      roundBorderRadius: other.roundBorderRadius,
      closeIconSize: other.closeIconSize,
      closeIconColor: other.closeIconColor,
      closeIconActiveColor: other.closeIconActiveColor,
      closeIconMargin: other.closeIconMargin,
    );
  }

  static DxPopupThemeData lerp(DxPopupThemeData? a, DxPopupThemeData? b, double t) {
    return DxPopupThemeData(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      transitionDuration: b?.transitionDuration, // lerpDuration(a?.transitionDuration, b?.transitionDuration, t),
      roundBorderRadius: lerpDouble(a?.roundBorderRadius, b?.roundBorderRadius, t),
      closeIconSize: lerpDouble(a?.closeIconSize, b?.closeIconSize, t),
      closeIconColor: Color.lerp(a?.closeIconColor, b?.closeIconColor, t),
      closeIconActiveColor: Color.lerp(a?.closeIconActiveColor, b?.closeIconActiveColor, t),
      closeIconMargin: lerpDouble(a?.closeIconMargin, b?.closeIconMargin, t),
    );
  }
}
