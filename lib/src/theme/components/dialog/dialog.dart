import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 弹窗主题
class DxDialogTheme extends InheritedTheme {
  const DxDialogTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxDialogThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxDialogTheme(
          key: key,
          data: DxDialogTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxDialogThemeData data;

  static DxDialogThemeData of(BuildContext context) {
    final DxDialogTheme? dialogTheme = context.dependOnInheritedWidgetOfExactType<DxDialogTheme>();
    return dialogTheme?.data ?? DxTheme.of(context).dialogTheme;
  }

  @override
  bool updateShouldNotify(DxDialogTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxDialogTheme(data: data, child: child);
  }
}

class DxDialogThemeData {
  final double width;
  final double smallScreenWidthFactor;
  final double fontSize;
  final Duration transition;
  final double borderRadius;
  final Color backgroundColor;
  final FontWeight headerFontWeight;
  final double headerLineHeight;
  final double headerPaddingTop;
  final EdgeInsets headerIsolatedPadding;
  final double messagePadding;
  final double messageFontSize;
  final double messageLineHeight;
  final double messageMaxHeight;
  final Color hasTitleMessageTextColor;
  final double hasTitleMessagePaddingTop;
  final double buttonHeight;
  final double roundButtonHeight;
  final Color confirmButtonTextColor;

  factory DxDialogThemeData({
    double? width,
    double? smallScreenWidthFactor,
    double? fontSize,
    Duration? transition,
    double? borderRadius,
    Color? backgroundColor,
    FontWeight? headerFontWeight,
    double? headerLineHeight,
    double? headerPaddingTop,
    EdgeInsets? headerIsolatedPadding,
    double? messagePadding,
    double? messageFontSize,
    double? messageLineHeight,
    double? messageMaxHeight,
    Color? hasTitleMessageTextColor,
    double? hasTitleMessagePaddingTop,
    double? buttonHeight,
    double? roundButtonHeight,
    Color? confirmButtonTextColor,
  }) {
    final double $fontSize = fontSize ?? DxStyle.fontSizeLg;
    final double $messageFontSize = messageFontSize ?? DxStyle.fontSizeMd;
    return DxDialogThemeData.raw(
      width: width ?? 320.0,
      smallScreenWidthFactor: smallScreenWidthFactor ?? .9,
      fontSize: $fontSize,
      transition: transition ?? DxStyle.animationDurationBase,
      borderRadius: borderRadius ?? 16.0,
      backgroundColor: backgroundColor ?? DxStyle.white,
      headerFontWeight: headerFontWeight ?? DxStyle.fontWeightBold,
      headerLineHeight: headerLineHeight ?? (24.0 / $fontSize),
      headerPaddingTop: headerPaddingTop ?? 15.0,
      headerIsolatedPadding:
          headerIsolatedPadding ?? const EdgeInsets.symmetric(vertical: DxStyle.paddingLg, horizontal: 0.0),
      messagePadding: messagePadding ?? DxStyle.paddingXl,
      messageFontSize: $messageFontSize,
      messageLineHeight: messageLineHeight ?? (DxStyle.lineHeightMd / $messageFontSize),
      messageMaxHeight: messageMaxHeight ?? .6,
      hasTitleMessageTextColor: hasTitleMessageTextColor ?? DxStyle.gray7,
      hasTitleMessagePaddingTop: hasTitleMessagePaddingTop ?? DxStyle.paddingXs,
      buttonHeight: buttonHeight ?? 48.0,
      roundButtonHeight: roundButtonHeight ?? 36.0,
      confirmButtonTextColor: confirmButtonTextColor ?? DxStyle.red,
    );
  }

  const DxDialogThemeData.raw({
    required this.width,
    required this.smallScreenWidthFactor,
    required this.fontSize,
    required this.transition,
    required this.borderRadius,
    required this.backgroundColor,
    required this.headerFontWeight,
    required this.headerLineHeight,
    required this.headerPaddingTop,
    required this.headerIsolatedPadding,
    required this.messagePadding,
    required this.messageFontSize,
    required this.messageLineHeight,
    required this.messageMaxHeight,
    required this.hasTitleMessageTextColor,
    required this.hasTitleMessagePaddingTop,
    required this.buttonHeight,
    required this.roundButtonHeight,
    required this.confirmButtonTextColor,
  });

  DxDialogThemeData copyWith({
    double? width,
    double? smallScreenWidthFactor,
    double? fontSize,
    Duration? transition,
    double? borderRadius,
    Color? backgroundColor,
    FontWeight? headerFontWeight,
    double? headerLineHeight,
    double? headerPaddingTop,
    EdgeInsets? headerIsolatedPadding,
    double? messagePadding,
    double? messageFontSize,
    double? messageLineHeight,
    double? messageMaxHeight,
    Color? hasTitleMessageTextColor,
    double? hasTitleMessagePaddingTop,
    double? buttonHeight,
    double? roundButtonHeight,
    Color? confirmButtonTextColor,
  }) {
    return DxDialogThemeData(
      width: width ?? this.width,
      smallScreenWidthFactor: smallScreenWidthFactor ?? this.smallScreenWidthFactor,
      fontSize: fontSize ?? this.fontSize,
      transition: transition ?? this.transition,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerFontWeight: headerFontWeight ?? this.headerFontWeight,
      headerLineHeight: headerLineHeight ?? this.headerLineHeight,
      headerPaddingTop: headerPaddingTop ?? this.headerPaddingTop,
      headerIsolatedPadding: headerIsolatedPadding ?? this.headerIsolatedPadding,
      messagePadding: messagePadding ?? this.messagePadding,
      messageFontSize: messageFontSize ?? this.messageFontSize,
      messageLineHeight: messageLineHeight ?? this.messageLineHeight,
      messageMaxHeight: messageMaxHeight ?? this.messageMaxHeight,
      hasTitleMessageTextColor: hasTitleMessageTextColor ?? this.hasTitleMessageTextColor,
      hasTitleMessagePaddingTop: hasTitleMessagePaddingTop ?? this.hasTitleMessagePaddingTop,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      roundButtonHeight: roundButtonHeight ?? this.roundButtonHeight,
      confirmButtonTextColor: confirmButtonTextColor ?? this.confirmButtonTextColor,
    );
  }

  DxDialogThemeData merge(DxDialogThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      width: other.width,
      smallScreenWidthFactor: other.smallScreenWidthFactor,
      fontSize: other.fontSize,
      transition: other.transition,
      borderRadius: other.borderRadius,
      backgroundColor: other.backgroundColor,
      headerFontWeight: other.headerFontWeight,
      headerLineHeight: other.headerLineHeight,
      headerPaddingTop: other.headerPaddingTop,
      headerIsolatedPadding: other.headerIsolatedPadding,
      messagePadding: other.messagePadding,
      messageFontSize: other.messageFontSize,
      messageLineHeight: other.messageLineHeight,
      messageMaxHeight: other.messageMaxHeight,
      hasTitleMessageTextColor: other.hasTitleMessageTextColor,
      hasTitleMessagePaddingTop: other.hasTitleMessagePaddingTop,
      buttonHeight: other.buttonHeight,
      roundButtonHeight: other.roundButtonHeight,
      confirmButtonTextColor: other.confirmButtonTextColor,
    );
  }

  static DxDialogThemeData lerp(DxDialogThemeData? a, DxDialogThemeData? b, double t) {
    return DxDialogThemeData(
      width: lerpDouble(a?.width, b?.width, t),
      smallScreenWidthFactor: lerpDouble(a?.smallScreenWidthFactor, b?.smallScreenWidthFactor, t),
      fontSize: lerpDouble(a?.fontSize, b?.fontSize, t),
      transition: b?.transition, // transition: lerpDuration(a?.transition, b?.transition, t),
      borderRadius: lerpDouble(a?.borderRadius, b?.borderRadius, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      headerFontWeight: FontWeight.lerp(a?.headerFontWeight, b?.headerFontWeight, t),
      headerLineHeight: lerpDouble(a?.headerLineHeight, b?.headerLineHeight, t),
      headerPaddingTop: lerpDouble(a?.headerPaddingTop, b?.headerPaddingTop, t),
      headerIsolatedPadding: EdgeInsets.lerp(a?.headerIsolatedPadding, b?.headerIsolatedPadding, t),
      messagePadding: lerpDouble(a?.messagePadding, b?.messagePadding, t),
      messageFontSize: lerpDouble(a?.messageFontSize, b?.messageFontSize, t),
      messageLineHeight: lerpDouble(a?.messageLineHeight, b?.messageLineHeight, t),
      messageMaxHeight: lerpDouble(a?.messageMaxHeight, b?.messageMaxHeight, t),
      hasTitleMessageTextColor: Color.lerp(a?.hasTitleMessageTextColor, b?.hasTitleMessageTextColor, t),
      hasTitleMessagePaddingTop: lerpDouble(a?.hasTitleMessagePaddingTop, b?.hasTitleMessagePaddingTop, t),
      buttonHeight: lerpDouble(a?.buttonHeight, b?.buttonHeight, t),
      roundButtonHeight: lerpDouble(a?.roundButtonHeight, b?.roundButtonHeight, t),
      confirmButtonTextColor: Color.lerp(a?.confirmButtonTextColor, b?.confirmButtonTextColor, t),
    );
  }
}
