import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 单元格组主题
class DxCellGroupTheme extends InheritedTheme {
  const DxCellGroupTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxCellGroupThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxCellGroupTheme(
          key: key,
          data: DxCellGroupTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxCellGroupThemeData data;

  static DxCellGroupThemeData of(BuildContext context) {
    final DxCellGroupTheme? cellGroupTheme = context.dependOnInheritedWidgetOfExactType<DxCellGroupTheme>();
    return cellGroupTheme?.data ?? DxTheme.of(context).cellGroupTheme;
  }

  @override
  bool updateShouldNotify(DxCellGroupTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxCellGroupTheme(data: data, child: child);
  }
}

class DxCellGroupThemeData {
  final Color titleColor;
  final double titleFontSize;
  final double titleLineHeight;

  factory DxCellGroupThemeData({
    Color? backgroundColor,
    Color? titleColor,
    EdgeInsets? titlePadding,
    double? titleFontSize,
    double? titleLineHeight,
  }) {
    final double $titleFontSize = titleFontSize ?? DxStyle.fontSizeMd;
    return DxCellGroupThemeData.raw(
      titleColor: titleColor ?? DxStyle.gray6,
      titleFontSize: $titleFontSize,
      titleLineHeight: titleLineHeight ?? (16.0 / $titleFontSize),
    );
  }

  const DxCellGroupThemeData.raw({
    required this.titleColor,
    required this.titleFontSize,
    required this.titleLineHeight,
  });

  DxCellGroupThemeData copyWith({
    Color? backgroundColor,
    Color? titleColor,
    double? titleFontSize,
    double? titleLineHeight,
  }) {
    return DxCellGroupThemeData(
      titleColor: titleColor ?? this.titleColor,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleLineHeight: titleLineHeight ?? this.titleLineHeight,
    );
  }

  DxCellGroupThemeData merge(DxCellGroupThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      titleColor: other.titleColor,
      titleFontSize: other.titleFontSize,
      titleLineHeight: other.titleLineHeight,
    );
  }

  static DxCellGroupThemeData lerp(DxCellGroupThemeData? a, DxCellGroupThemeData? b, double t) {
    return DxCellGroupThemeData(
      titleColor: Color.lerp(a?.titleColor, b?.titleColor, t),
      titleFontSize: lerpDouble(a?.titleFontSize, b?.titleFontSize, t),
      titleLineHeight: lerpDouble(a?.titleLineHeight, b?.titleLineHeight, t),
    );
  }
}
