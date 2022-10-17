import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 按钮主题
class DxButtonTheme extends InheritedTheme {
  const DxButtonTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxButtonThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxButtonTheme(
          key: key,
          data: DxButtonTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxButtonThemeData data;

  static DxButtonThemeData of(BuildContext context) {
    final DxButtonTheme? buttonTheme = context.dependOnInheritedWidgetOfExactType<DxButtonTheme>();
    return buttonTheme?.data ?? DxTheme.of(context).buttonTheme;
  }

  @override
  bool updateShouldNotify(DxButtonTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxButtonTheme(data: data, child: child);
  }
}

class DxButtonThemeData {
  final EdgeInsets defaultPadding;
  final double defaultHeight;
  final double defaultLineHeight;
  final double defaultFontSize;
  final Color defaultColor;
  final Color defaultBackgroundColor;
  final Color defaultBorderColor;
  final Color primaryColor;
  final Color primaryBackgroundColor;
  final Color primaryBorderColor;
  final Color successColor;
  final Color successBackgroundColor;
  final Color successBorderColor;
  final Color dangerColor;
  final Color dangerBackgroundColor;
  final Color dangerBorderColor;
  final Color warningColor;
  final Color warningBackgroundColor;
  final Color warningBorderColor;
  final double borderWidth;
  final double borderRadius;
  final double roundBorderRadius;
  final Color plainBackgroundColor;
  final double disabledOpacity;
  final double iconSize;
  final double loadingIconSize;

  factory DxButtonThemeData({
    EdgeInsets? defaultPadding,
    double? defaultHeight,
    double? defaultLineHeight,
    double? defaultFontSize,
    Color? defaultColor,
    Color? defaultBackgroundColor,
    Color? defaultBorderColor,
    Color? primaryColor,
    Color? primaryBackgroundColor,
    Color? primaryBorderColor,
    Color? successColor,
    Color? successBackgroundColor,
    Color? successBorderColor,
    Color? dangerColor,
    Color? dangerBackgroundColor,
    Color? dangerBorderColor,
    Color? warningColor,
    Color? warningBackgroundColor,
    Color? warningBorderColor,
    double? borderWidth,
    double? borderRadius,
    double? roundBorderRadius,
    Color? plainBackgroundColor,
    double? disabledOpacity,
    double? iconSize,
    double? loadingIconSize,
  }) {
    return DxButtonThemeData.raw(
      defaultPadding: defaultPadding ?? const EdgeInsets.symmetric(horizontal: 10.0),
      defaultHeight: defaultHeight ?? 50.0,
      defaultLineHeight: defaultLineHeight ?? 1.2,
      defaultFontSize: defaultFontSize ?? DxStyle.fontSizeMd,
      defaultColor: defaultColor ?? DxStyle.textColor,
      defaultBackgroundColor: defaultBackgroundColor ?? DxStyle.white,
      defaultBorderColor: defaultBorderColor ?? DxStyle.borderColor,
      primaryColor: primaryColor ?? DxStyle.white,
      primaryBackgroundColor: primaryBackgroundColor ?? DxStyle.blue,
      primaryBorderColor: primaryBorderColor ?? DxStyle.blue,
      successColor: successColor ?? DxStyle.white,
      successBackgroundColor: successBackgroundColor ?? DxStyle.green,
      successBorderColor: successBorderColor ?? DxStyle.green,
      dangerColor: dangerColor ?? DxStyle.white,
      dangerBackgroundColor: dangerBackgroundColor ?? DxStyle.red,
      dangerBorderColor: dangerBorderColor ?? DxStyle.red,
      warningColor: warningColor ?? DxStyle.white,
      warningBackgroundColor: warningBackgroundColor ?? DxStyle.orange,
      warningBorderColor: warningBorderColor ?? DxStyle.orange,
      borderWidth: borderWidth ?? DxStyle.borderWidthBase,
      borderRadius: borderRadius ?? DxStyle.borderRadiusMd,
      roundBorderRadius: roundBorderRadius ?? DxStyle.borderRadiusMax,
      plainBackgroundColor: plainBackgroundColor ?? DxStyle.white,
      disabledOpacity: disabledOpacity ?? DxStyle.disabledOpacity,
      iconSize: iconSize ?? (DxStyle.fontSizeLg * 1.2),
      loadingIconSize: loadingIconSize ?? 20.0,
    );
  }

  const DxButtonThemeData.raw({
    required this.defaultPadding,
    required this.defaultHeight,
    required this.defaultLineHeight,
    required this.defaultFontSize,
    required this.defaultColor,
    required this.defaultBackgroundColor,
    required this.defaultBorderColor,
    required this.primaryColor,
    required this.primaryBackgroundColor,
    required this.primaryBorderColor,
    required this.successColor,
    required this.successBackgroundColor,
    required this.successBorderColor,
    required this.dangerColor,
    required this.dangerBackgroundColor,
    required this.dangerBorderColor,
    required this.warningColor,
    required this.warningBackgroundColor,
    required this.warningBorderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.roundBorderRadius,
    required this.plainBackgroundColor,
    required this.disabledOpacity,
    required this.iconSize,
    required this.loadingIconSize,
  });

  DxButtonThemeData copyWith({
    EdgeInsets? defaultPadding,
    double? defaultHeight,
    double? defaultLineHeight,
    double? defaultFontSize,
    Color? defaultColor,
    Color? defaultBackgroundColor,
    Color? defaultBorderColor,
    Color? primaryColor,
    Color? primaryBackgroundColor,
    Color? primaryBorderColor,
    Color? successColor,
    Color? successBackgroundColor,
    Color? successBorderColor,
    Color? dangerColor,
    Color? dangerBackgroundColor,
    Color? dangerBorderColor,
    Color? warningColor,
    Color? warningBackgroundColor,
    Color? warningBorderColor,
    double? borderWidth,
    double? borderRadius,
    double? roundBorderRadius,
    Color? plainBackgroundColor,
    double? disabledOpacity,
    double? iconSize,
    double? loadingIconSize,
  }) {
    return DxButtonThemeData(
      defaultPadding: defaultPadding ?? this.defaultPadding,
      defaultHeight: defaultHeight ?? this.defaultHeight,
      defaultLineHeight: defaultLineHeight ?? this.defaultLineHeight,
      defaultFontSize: defaultFontSize ?? this.defaultFontSize,
      defaultColor: defaultColor ?? this.defaultColor,
      defaultBackgroundColor: defaultBackgroundColor ?? this.defaultBackgroundColor,
      defaultBorderColor: defaultBorderColor ?? this.defaultBorderColor,
      primaryColor: primaryColor ?? this.primaryColor,
      primaryBackgroundColor: primaryBackgroundColor ?? this.primaryBackgroundColor,
      primaryBorderColor: primaryBorderColor ?? this.primaryBorderColor,
      successColor: successColor ?? this.successColor,
      successBackgroundColor: successBackgroundColor ?? this.successBackgroundColor,
      successBorderColor: successBorderColor ?? this.successBorderColor,
      dangerColor: dangerColor ?? this.dangerColor,
      dangerBackgroundColor: dangerBackgroundColor ?? this.dangerBackgroundColor,
      dangerBorderColor: dangerBorderColor ?? this.dangerBorderColor,
      warningColor: warningColor ?? this.warningColor,
      warningBackgroundColor: warningBackgroundColor ?? this.warningBackgroundColor,
      warningBorderColor: warningBorderColor ?? this.warningBorderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      roundBorderRadius: roundBorderRadius ?? this.roundBorderRadius,
      plainBackgroundColor: plainBackgroundColor ?? this.plainBackgroundColor,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      iconSize: iconSize ?? this.iconSize,
      loadingIconSize: loadingIconSize ?? this.loadingIconSize,
    );
  }

  DxButtonThemeData merge(DxButtonThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      defaultPadding: other.defaultPadding,
      defaultHeight: other.defaultHeight,
      defaultLineHeight: other.defaultLineHeight,
      defaultFontSize: other.defaultFontSize,
      defaultColor: other.defaultColor,
      defaultBackgroundColor: other.defaultBackgroundColor,
      defaultBorderColor: other.defaultBorderColor,
      primaryColor: other.primaryColor,
      primaryBackgroundColor: other.primaryBackgroundColor,
      primaryBorderColor: other.primaryBorderColor,
      successColor: other.successColor,
      successBackgroundColor: other.successBackgroundColor,
      successBorderColor: other.successBorderColor,
      dangerColor: other.dangerColor,
      dangerBackgroundColor: other.dangerBackgroundColor,
      dangerBorderColor: other.dangerBorderColor,
      warningColor: other.warningColor,
      warningBackgroundColor: other.warningBackgroundColor,
      warningBorderColor: other.warningBorderColor,
      borderWidth: other.borderWidth,
      borderRadius: other.borderRadius,
      roundBorderRadius: other.roundBorderRadius,
      plainBackgroundColor: other.plainBackgroundColor,
      disabledOpacity: other.disabledOpacity,
      iconSize: other.iconSize,
      loadingIconSize: other.loadingIconSize,
    );
  }

  static DxButtonThemeData lerp(DxButtonThemeData? a, DxButtonThemeData? b, double t) {
    return DxButtonThemeData(
      defaultPadding: EdgeInsets.lerp(a?.defaultPadding, b?.defaultPadding, t),
      defaultHeight: lerpDouble(a?.defaultHeight, b?.defaultHeight, t),
      defaultLineHeight: lerpDouble(a?.defaultLineHeight, b?.defaultLineHeight, t),
      defaultFontSize: lerpDouble(a?.defaultFontSize, b?.defaultFontSize, t),
      defaultColor: Color.lerp(a?.defaultColor, b?.defaultColor, t),
      defaultBackgroundColor: Color.lerp(a?.defaultBackgroundColor, b?.defaultBackgroundColor, t),
      defaultBorderColor: Color.lerp(a?.defaultBorderColor, b?.defaultBorderColor, t),
      primaryColor: Color.lerp(a?.primaryColor, b?.primaryColor, t),
      primaryBackgroundColor: Color.lerp(a?.primaryBackgroundColor, b?.primaryBackgroundColor, t),
      primaryBorderColor: Color.lerp(a?.primaryBorderColor, b?.primaryBorderColor, t),
      successColor: Color.lerp(a?.successColor, b?.successColor, t),
      successBackgroundColor: Color.lerp(a?.successBackgroundColor, b?.successBackgroundColor, t),
      successBorderColor: Color.lerp(a?.successBorderColor, b?.successBorderColor, t),
      dangerColor: Color.lerp(a?.dangerColor, b?.dangerColor, t),
      dangerBackgroundColor: Color.lerp(a?.dangerBackgroundColor, b?.dangerBackgroundColor, t),
      dangerBorderColor: Color.lerp(a?.dangerBorderColor, b?.dangerBorderColor, t),
      warningColor: Color.lerp(a?.warningColor, b?.warningColor, t),
      warningBackgroundColor: Color.lerp(a?.warningBackgroundColor, b?.warningBackgroundColor, t),
      warningBorderColor: Color.lerp(a?.warningBorderColor, b?.warningBorderColor, t),
      borderWidth: lerpDouble(a?.borderWidth, b?.borderWidth, t),
      borderRadius: lerpDouble(a?.borderRadius, b?.borderRadius, t),
      roundBorderRadius: lerpDouble(a?.roundBorderRadius, b?.roundBorderRadius, t),
      plainBackgroundColor: Color.lerp(a?.plainBackgroundColor, b?.plainBackgroundColor, t),
      disabledOpacity: lerpDouble(a?.disabledOpacity, b?.disabledOpacity, t),
      iconSize: lerpDouble(a?.iconSize, b?.iconSize, t),
      loadingIconSize: lerpDouble(a?.loadingIconSize, b?.loadingIconSize, t),
    );
  }
}
