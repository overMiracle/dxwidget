import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 单元格主题
class DxCellTheme extends InheritedTheme {
  const DxCellTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxCellThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxCellTheme(
          key: key,
          data: DxCellTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxCellThemeData data;

  static DxCellThemeData of(BuildContext context) {
    final DxCellTheme? cellTheme = context.dependOnInheritedWidgetOfExactType<DxCellTheme>();
    return cellTheme?.data ?? DxTheme.of(context).cellTheme;
  }

  @override
  bool updateShouldNotify(DxCellTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxCellTheme(data: data, child: child);
  }
}

class DxCellThemeData {
  final double fontSize;
  final double lineHeight;
  final double verticalPadding;
  final double horizontalPadding;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color activeColor;
  final Color requiredColor;
  final Color labelColor;
  final double labelFontSize;
  final double labelLineHeight;
  final double labelMarginTop;
  final Color valueColor;
  final double iconSize;
  final Color rightIconColor;
  final double largeVerticalPadding;
  final double largeTitleFontSize;
  final double largeLabelFontSize;

  factory DxCellThemeData({
    double? fontSize,
    double? lineHeight,
    double? verticalPadding,
    double? horizontalPadding,
    Color? textColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? activeColor,
    Color? requiredColor,
    Color? labelColor,
    double? labelFontSize,
    double? labelLineHeight,
    double? labelMarginTop,
    Color? valueColor,
    double? iconSize,
    Color? rightIconColor,
    double? largeVerticalPadding,
    double? largeTitleFontSize,
    double? largeLabelFontSize,
  }) {
    final double $fontSize = fontSize ?? DxStyle.fontSizeMd;
    final double $labelFontSize = labelFontSize ?? DxStyle.fontSizeSm;
    return DxCellThemeData.raw(
      fontSize: $fontSize,
      lineHeight: lineHeight ?? (24.0 / $fontSize),
      verticalPadding: verticalPadding ?? 14.0,
      horizontalPadding: horizontalPadding ?? DxStyle.paddingMd,
      textColor: textColor ?? DxStyle.textColor,
      backgroundColor: backgroundColor ?? DxStyle.white,
      borderColor: borderColor ?? DxStyle.borderColor,
      activeColor: activeColor ?? DxStyle.activeColor,
      requiredColor: requiredColor ?? DxStyle.red,
      labelColor: labelColor ?? DxStyle.gray6,
      labelFontSize: $labelFontSize,
      labelLineHeight: labelLineHeight ?? (DxStyle.lineHeightSm / $labelFontSize),
      labelMarginTop: labelMarginTop ?? DxStyle.paddingBase,
      valueColor: valueColor ?? DxStyle.gray6,
      iconSize: iconSize ?? 16.0,
      rightIconColor: rightIconColor ?? DxStyle.gray6,
      largeVerticalPadding: largeVerticalPadding ?? DxStyle.paddingSm,
      largeTitleFontSize: largeTitleFontSize ?? DxStyle.fontSizeLg,
      largeLabelFontSize: largeLabelFontSize ?? DxStyle.fontSizeMd,
    );
  }

  const DxCellThemeData.raw({
    required this.fontSize,
    required this.lineHeight,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.activeColor,
    required this.requiredColor,
    required this.labelColor,
    required this.labelFontSize,
    required this.labelLineHeight,
    required this.labelMarginTop,
    required this.valueColor,
    required this.iconSize,
    required this.rightIconColor,
    required this.largeVerticalPadding,
    required this.largeTitleFontSize,
    required this.largeLabelFontSize,
  });

  DxCellThemeData copyWith({
    double? fontSize,
    double? lineHeight,
    double? verticalPadding,
    double? horizontalPadding,
    Color? textColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? activeColor,
    Color? requiredColor,
    Color? labelColor,
    double? labelFontSize,
    double? labelLineHeight,
    double? labelMarginTop,
    Color? valueColor,
    double? iconSize,
    Color? rightIconColor,
    double? largeVerticalPadding,
    double? largeTitleFontSize,
    double? largeLabelFontSize,
  }) {
    return DxCellThemeData(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      activeColor: activeColor ?? this.activeColor,
      requiredColor: requiredColor ?? this.requiredColor,
      labelColor: labelColor ?? this.labelColor,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelLineHeight: labelLineHeight ?? this.labelLineHeight,
      labelMarginTop: labelMarginTop ?? this.labelMarginTop,
      valueColor: valueColor ?? this.valueColor,
      iconSize: iconSize ?? this.iconSize,
      rightIconColor: rightIconColor ?? this.rightIconColor,
      largeVerticalPadding: largeVerticalPadding ?? this.largeVerticalPadding,
      largeTitleFontSize: largeTitleFontSize ?? this.largeTitleFontSize,
      largeLabelFontSize: largeLabelFontSize ?? this.largeLabelFontSize,
    );
  }

  DxCellThemeData merge(DxCellThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      fontSize: other.fontSize,
      lineHeight: other.lineHeight,
      verticalPadding: other.verticalPadding,
      horizontalPadding: other.horizontalPadding,
      textColor: other.textColor,
      backgroundColor: other.backgroundColor,
      borderColor: other.borderColor,
      activeColor: other.activeColor,
      requiredColor: other.requiredColor,
      labelColor: other.labelColor,
      labelFontSize: other.labelFontSize,
      labelLineHeight: other.labelLineHeight,
      labelMarginTop: other.labelMarginTop,
      valueColor: other.valueColor,
      iconSize: other.iconSize,
      rightIconColor: other.rightIconColor,
      largeVerticalPadding: other.largeVerticalPadding,
      largeTitleFontSize: other.largeTitleFontSize,
      largeLabelFontSize: other.largeLabelFontSize,
    );
  }

  static DxCellThemeData lerp(DxCellThemeData? a, DxCellThemeData? b, double t) {
    return DxCellThemeData(
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      lineHeight: lerpDouble(a?.lineHeight, b?.lineHeight, t),
      verticalPadding: lerpDouble(a?.verticalPadding, b?.verticalPadding, t),
      horizontalPadding: lerpDouble(a?.horizontalPadding, b?.horizontalPadding, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      borderColor: Color.lerp(a?.borderColor, b?.borderColor, t),
      activeColor: Color.lerp(a?.activeColor, b?.activeColor, t),
      requiredColor: Color.lerp(a?.requiredColor, b?.requiredColor, t),
      labelColor: Color.lerp(a?.labelColor, b?.labelColor, t),
      labelFontSize: lerpDouble(a?.labelFontSize, b?.labelFontSize, t),
      labelLineHeight: lerpDouble(a?.labelLineHeight, b?.labelLineHeight, t),
      labelMarginTop: lerpDouble(a?.labelMarginTop, b?.labelMarginTop, t),
      valueColor: Color.lerp(a?.valueColor, b?.valueColor, t),
      iconSize: lerpDouble(a?.iconSize, b?.iconSize, t),
      rightIconColor: Color.lerp(a?.rightIconColor, b?.rightIconColor, t),
      largeVerticalPadding: lerpDouble(a?.largeVerticalPadding, b?.largeVerticalPadding, t),
      largeTitleFontSize: lerpDouble(a?.largeTitleFontSize, b?.largeTitleFontSize, t),
      largeLabelFontSize: lerpDouble(a?.largeLabelFontSize, b?.largeLabelFontSize, t),
    );
  }
}
