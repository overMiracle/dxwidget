import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 提交订单栏主题
class DxSubmitBarTheme extends InheritedTheme {
  const DxSubmitBarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxSubmitBarThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxSubmitBarTheme(
          key: key,
          data: DxSubmitBarTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxSubmitBarThemeData data;

  static DxSubmitBarThemeData of(BuildContext context) {
    final DxSubmitBarTheme? submitBarTheme = context.dependOnInheritedWidgetOfExactType<DxSubmitBarTheme>();
    return submitBarTheme?.data ?? DxTheme.of(context).submitBarTheme;
  }

  @override
  bool updateShouldNotify(DxSubmitBarTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxSubmitBarTheme(data: data, child: child);
  }
}

class DxSubmitBarThemeData {
  final double height;
  final Color backgroundColor;
  final double buttonWidth;
  final Color priceColor;
  final double priceFontSize;
  final double currencyFontSize;
  final Color textColor;
  final double textFontSize;
  final EdgeInsets tipPadding;
  final double tipFontSize;
  final double tipLineHeight;
  final Color tipColor;
  final Color tipBackgroundColor;
  final double tipIconSize;
  final double buttonHeight;
  final EdgeInsets padding;
  final double priceIntegerFontSize;

  factory DxSubmitBarThemeData({
    double? height,
    Color? backgroundColor,
    double? buttonWidth,
    Color? priceColor,
    double? priceFontSize,
    double? currencyFontSize,
    Color? textColor,
    double? textFontSize,
    EdgeInsets? tipPadding,
    double? tipFontSize,
    double? tipLineHeight,
    Color? tipColor,
    Color? tipBackgroundColor,
    double? tipIconSize,
    double? buttonHeight,
    EdgeInsets? padding,
    double? priceIntegerFontSize,
  }) {
    return DxSubmitBarThemeData.raw(
      height: height ?? 50.0,
      backgroundColor: backgroundColor ?? DxStyle.white,
      buttonWidth: buttonWidth ?? 110.0,
      priceColor: priceColor ?? DxStyle.red,
      priceFontSize: priceFontSize ?? DxStyle.fontSizeMd,
      currencyFontSize: currencyFontSize ?? DxStyle.fontSizeMd,
      textColor: textColor ?? DxStyle.textColor,
      textFontSize: textFontSize ?? DxStyle.fontSizeMd,
      tipPadding: tipPadding ?? const EdgeInsets.symmetric(vertical: DxStyle.paddingXs, horizontal: DxStyle.paddingSm),
      tipFontSize: tipFontSize ?? DxStyle.fontSizeSm,
      tipLineHeight: tipLineHeight ?? 1.5,
      tipColor: tipColor ?? const Color(0xfff56723),
      tipBackgroundColor: tipBackgroundColor ?? const Color(0xfffff7cc),
      tipIconSize: tipIconSize ?? 12.0,
      buttonHeight: buttonHeight ?? 40.0,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 0.0, horizontal: DxStyle.paddingMd),
      priceIntegerFontSize: priceIntegerFontSize ?? 20.0,
    );
  }

  const DxSubmitBarThemeData.raw({
    required this.height,
    required this.backgroundColor,
    required this.buttonWidth,
    required this.priceColor,
    required this.priceFontSize,
    required this.currencyFontSize,
    required this.textColor,
    required this.textFontSize,
    required this.tipPadding,
    required this.tipFontSize,
    required this.tipLineHeight,
    required this.tipColor,
    required this.tipBackgroundColor,
    required this.tipIconSize,
    required this.buttonHeight,
    required this.padding,
    required this.priceIntegerFontSize,
  });

  DxSubmitBarThemeData copyWith({
    double? height,
    Color? backgroundColor,
    double? buttonWidth,
    Color? priceColor,
    double? priceFontSize,
    double? currencyFontSize,
    Color? textColor,
    double? textFontSize,
    EdgeInsets? tipPadding,
    double? tipFontSize,
    double? tipLineHeight,
    Color? tipColor,
    Color? tipBackgroundColor,
    double? tipIconSize,
    double? buttonHeight,
    EdgeInsets? padding,
    double? priceIntegerFontSize,
    String? priceFontFamily,
  }) {
    return DxSubmitBarThemeData(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      buttonWidth: buttonWidth ?? this.buttonWidth,
      priceColor: priceColor ?? this.priceColor,
      priceFontSize: priceFontSize ?? this.priceFontSize,
      currencyFontSize: currencyFontSize ?? this.currencyFontSize,
      textColor: textColor ?? this.textColor,
      textFontSize: textFontSize ?? this.textFontSize,
      tipPadding: tipPadding ?? this.tipPadding,
      tipFontSize: tipFontSize ?? this.tipFontSize,
      tipLineHeight: tipLineHeight ?? this.tipLineHeight,
      tipColor: tipColor ?? this.tipColor,
      tipBackgroundColor: tipBackgroundColor ?? this.tipBackgroundColor,
      tipIconSize: tipIconSize ?? this.tipIconSize,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      padding: padding ?? this.padding,
      priceIntegerFontSize: priceIntegerFontSize ?? this.priceIntegerFontSize,
    );
  }

  DxSubmitBarThemeData merge(DxSubmitBarThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      height: other.height,
      backgroundColor: other.backgroundColor,
      buttonWidth: other.buttonWidth,
      priceColor: other.priceColor,
      priceFontSize: other.priceFontSize,
      currencyFontSize: other.currencyFontSize,
      textColor: other.textColor,
      textFontSize: other.textFontSize,
      tipPadding: other.tipPadding,
      tipFontSize: other.tipFontSize,
      tipLineHeight: other.tipLineHeight,
      tipColor: other.tipColor,
      tipBackgroundColor: other.tipBackgroundColor,
      tipIconSize: other.tipIconSize,
      buttonHeight: other.buttonHeight,
      padding: other.padding,
      priceIntegerFontSize: other.priceIntegerFontSize,
    );
  }

  static DxSubmitBarThemeData lerp(DxSubmitBarThemeData? a, DxSubmitBarThemeData? b, double t) {
    return DxSubmitBarThemeData(
      height: lerpDouble(a?.height, b?.height, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      buttonWidth: lerpDouble(a?.buttonWidth, b?.buttonWidth, t),
      priceColor: Color.lerp(a?.priceColor, b?.priceColor, t),
      priceFontSize: lerpDouble(a?.priceFontSize, b?.priceFontSize, t),
      currencyFontSize: lerpDouble(a?.currencyFontSize, b?.currencyFontSize, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      textFontSize: lerpDouble(a?.textFontSize, b?.textFontSize, t),
      tipPadding: EdgeInsets.lerp(a?.tipPadding, b?.tipPadding, t),
      tipFontSize: lerpDouble(a?.tipFontSize, b?.tipFontSize, t),
      tipLineHeight: lerpDouble(a?.tipLineHeight, b?.tipLineHeight, t),
      tipColor: Color.lerp(a?.tipColor, b?.tipColor, t),
      tipBackgroundColor: Color.lerp(a?.tipBackgroundColor, b?.tipBackgroundColor, t),
      tipIconSize: lerpDouble(a?.tipIconSize, b?.tipIconSize, t),
      buttonHeight: lerpDouble(a?.buttonHeight, b?.buttonHeight, t),
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t),
      priceIntegerFontSize: lerpDouble(a?.priceIntegerFontSize, b?.priceIntegerFontSize, t),
    );
  }
}
