import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 图片主题
class DxImageTheme extends InheritedTheme {
  const DxImageTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxImageThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxImageTheme(
          key: key,
          data: DxImageTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxImageThemeData data;

  static DxImageThemeData of(BuildContext context) {
    final DxImageTheme? imageTheme = context.dependOnInheritedWidgetOfExactType<DxImageTheme>();
    return imageTheme?.data ?? DxTheme.of(context).imageTheme;
  }

  @override
  bool updateShouldNotify(DxImageTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxImageTheme(data: data, child: child);
  }
}

class DxImageThemeData {
  final Color placeholderTextColor;
  final double placeholderFontSize;
  final Color placeholderBackgroundColor;
  final double loadingIconSize;
  final Color loadingIconColor;
  final double errorIconSize;
  final Color errorIconColor;

  factory DxImageThemeData({
    Color? placeholderTextColor,
    double? placeholderFontSize,
    Color? placeholderBackgroundColor,
    double? loadingIconSize,
    Color? loadingIconColor,
    double? errorIconSize,
    Color? errorIconColor,
  }) {
    return DxImageThemeData.raw(
      placeholderTextColor: placeholderTextColor ?? DxStyle.gray6,
      placeholderFontSize: placeholderFontSize ?? DxStyle.fontSizeMd,
      placeholderBackgroundColor: placeholderBackgroundColor ?? DxStyle.backgroundColor,
      loadingIconSize: loadingIconSize ?? 32.0,
      loadingIconColor: loadingIconColor ?? DxStyle.gray4,
      errorIconSize: errorIconSize ?? 32.0,
      errorIconColor: errorIconColor ?? DxStyle.gray4,
    );
  }

  const DxImageThemeData.raw({
    required this.placeholderTextColor,
    required this.placeholderFontSize,
    required this.placeholderBackgroundColor,
    required this.loadingIconSize,
    required this.loadingIconColor,
    required this.errorIconSize,
    required this.errorIconColor,
  });

  DxImageThemeData copyWith({
    Color? placeholderTextColor,
    double? placeholderFontSize,
    Color? placeholderBackgroundColor,
    double? loadingIconSize,
    Color? loadingIconColor,
    double? errorIconSize,
    Color? errorIconColor,
  }) {
    return DxImageThemeData(
      placeholderTextColor: placeholderTextColor ?? this.placeholderTextColor,
      placeholderFontSize: placeholderFontSize ?? this.placeholderFontSize,
      placeholderBackgroundColor: placeholderBackgroundColor ?? this.placeholderBackgroundColor,
      loadingIconSize: loadingIconSize ?? this.loadingIconSize,
      loadingIconColor: loadingIconColor ?? this.loadingIconColor,
      errorIconSize: errorIconSize ?? this.errorIconSize,
      errorIconColor: errorIconColor ?? this.errorIconColor,
    );
  }

  DxImageThemeData merge(DxImageThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      placeholderTextColor: other.placeholderTextColor,
      placeholderFontSize: other.placeholderFontSize,
      placeholderBackgroundColor: other.placeholderBackgroundColor,
      loadingIconSize: other.loadingIconSize,
      loadingIconColor: other.loadingIconColor,
      errorIconSize: other.errorIconSize,
      errorIconColor: other.errorIconColor,
    );
  }

  static DxImageThemeData lerp(DxImageThemeData? a, DxImageThemeData? b, double t) {
    return DxImageThemeData(
      placeholderTextColor: Color.lerp(a?.placeholderTextColor, b?.placeholderTextColor, t),
      placeholderFontSize: lerpDouble(a?.placeholderFontSize, b?.placeholderFontSize, t),
      placeholderBackgroundColor: Color.lerp(a?.placeholderBackgroundColor, b?.placeholderBackgroundColor, t),
      loadingIconSize: lerpDouble(a?.loadingIconSize, b?.loadingIconSize, t),
      loadingIconColor: Color.lerp(a?.loadingIconColor, b?.loadingIconColor, t),
      errorIconSize: lerpDouble(a?.errorIconSize, b?.errorIconSize, t),
      errorIconColor: Color.lerp(a?.errorIconColor, b?.errorIconColor, t),
    );
  }
}
