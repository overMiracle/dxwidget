import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 侧边导航主题
class DxSidebarTheme extends InheritedTheme {
  const DxSidebarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxSidebarThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxSidebarTheme(
          key: key,
          data: DxSidebarTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxSidebarThemeData data;

  static DxSidebarThemeData of(BuildContext context) {
    final DxSidebarTheme? sidebarTheme = context.dependOnInheritedWidgetOfExactType<DxSidebarTheme>();
    return sidebarTheme?.data ?? DxTheme.of(context).sidebarTheme;
  }

  @override
  bool updateShouldNotify(DxSidebarTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxSidebarTheme(data: data, child: child);
  }
}

class DxSidebarThemeData {
  final double width;
  final double fontSize;
  final double lineHeight;
  final Color disabledTextColor;
  final EdgeInsets padding;
  final Color backgroundColor;
  final FontWeight selectedFontWeight;
  final Color selectedTextColor;
  final double selectedBorderWidth;
  final double selectedBorderHeight;
  final Color selectedBorderColor;
  final Color selectedBackgroundColor;

  factory DxSidebarThemeData({
    double? width,
    double? fontSize,
    double? lineHeight,
    Color? disabledTextColor,
    EdgeInsets? padding,
    Color? backgroundColor,
    FontWeight? selectedFontWeight,
    Color? selectedTextColor,
    double? selectedBorderWidth,
    double? selectedBorderHeight,
    Color? selectedBorderColor,
    Color? selectedBackgroundColor,
  }) {
    final double $fonSize = fontSize ?? DxStyle.fontSizeMd;
    return DxSidebarThemeData.raw(
      width: width ?? 80.0,
      fontSize: $fonSize,
      lineHeight: lineHeight ?? (DxStyle.lineHeightMd / $fonSize),
      disabledTextColor: disabledTextColor ?? DxStyle.gray5,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 20.0, horizontal: DxStyle.paddingSm),
      backgroundColor: backgroundColor ?? DxStyle.backgroundColor,
      selectedFontWeight: selectedFontWeight ?? DxStyle.fontWeightBold,
      selectedTextColor: selectedTextColor ?? DxStyle.textColor,
      selectedBorderWidth: selectedBorderWidth ?? 4.0,
      selectedBorderHeight: selectedBorderHeight ?? 100.0,
      selectedBorderColor: selectedBorderColor ?? DxStyle.red,
      selectedBackgroundColor: selectedBackgroundColor ?? DxStyle.white,
    );
  }

  const DxSidebarThemeData.raw({
    required this.width,
    required this.fontSize,
    required this.lineHeight,
    required this.disabledTextColor,
    required this.padding,
    required this.backgroundColor,
    required this.selectedFontWeight,
    required this.selectedTextColor,
    required this.selectedBorderWidth,
    required this.selectedBorderHeight,
    required this.selectedBorderColor,
    required this.selectedBackgroundColor,
  });

  DxSidebarThemeData copyWith({
    double? width,
    double? fontSize,
    double? lineHeight,
    Color? disabledTextColor,
    EdgeInsets? padding,
    Color? backgroundColor,
    FontWeight? selectedFontWeight,
    Color? selectedTextColor,
    double? selectedBorderWidth,
    double? selectedBorderHeight,
    Color? selectedBorderColor,
    Color? selectedBackgroundColor,
  }) {
    return DxSidebarThemeData(
      width: width ?? this.width,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedFontWeight: selectedFontWeight ?? this.selectedFontWeight,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      selectedBorderWidth: selectedBorderWidth ?? this.selectedBorderWidth,
      selectedBorderHeight: selectedBorderHeight ?? this.selectedBorderHeight,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
    );
  }

  DxSidebarThemeData merge(DxSidebarThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      width: other.width,
      fontSize: other.fontSize,
      lineHeight: other.lineHeight,
      disabledTextColor: other.disabledTextColor,
      padding: other.padding,
      backgroundColor: other.backgroundColor,
      selectedFontWeight: other.selectedFontWeight,
      selectedTextColor: other.selectedTextColor,
      selectedBorderWidth: other.selectedBorderWidth,
      selectedBorderHeight: other.selectedBorderHeight,
      selectedBorderColor: other.selectedBorderColor,
      selectedBackgroundColor: other.selectedBackgroundColor,
    );
  }

  static DxSidebarThemeData lerp(DxSidebarThemeData? a, DxSidebarThemeData? b, double t) {
    return DxSidebarThemeData(
      width: lerpDouble(a?.width, b?.width, t),
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      lineHeight: lerpDouble(a?.lineHeight, b?.lineHeight, t),
      disabledTextColor: Color.lerp(a?.disabledTextColor, b?.disabledTextColor, t),
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      selectedFontWeight: FontWeight.lerp(a?.selectedFontWeight, b?.selectedFontWeight, t),
      selectedTextColor: Color.lerp(a?.selectedTextColor, b?.selectedTextColor, t),
      selectedBorderWidth: lerpDouble(a?.selectedBorderWidth, b?.selectedBorderWidth, t),
      selectedBorderHeight: lerpDouble(a?.selectedBorderHeight, b?.selectedBorderHeight, t),
      selectedBorderColor: Color.lerp(a?.selectedBorderColor, b?.selectedBorderColor, t),
      selectedBackgroundColor: Color.lerp(a?.selectedBackgroundColor, b?.selectedBackgroundColor, t),
    );
  }
}
