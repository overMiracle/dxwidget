import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 折叠面板主题
class DxCollapseTheme extends InheritedTheme {
  const DxCollapseTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxCollapseThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxCollapseTheme(
          key: key,
          data: DxCollapseTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxCollapseThemeData data;

  static DxCollapseThemeData of(BuildContext context) {
    final DxCollapseTheme? collapseTheme = context.dependOnInheritedWidgetOfExactType<DxCollapseTheme>();
    return collapseTheme?.data ?? DxTheme.of(context).collapseTheme;
  }

  @override
  bool updateShouldNotify(DxCollapseTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxCollapseTheme(data: data, child: child);
  }
}

class DxCollapseThemeData {
  final Duration itemTransitionDuration;
  final EdgeInsets itemContentPadding;
  final double itemContentFontSize;
  final double itemContentLineHeight;
  final Color itemContentTextColor;
  final Color itemContentBackgroundColor;
  final Color itemTitleDisabledColor;

  factory DxCollapseThemeData({
    Duration? itemTransitionDuration,
    EdgeInsets? itemContentPadding,
    double? itemContentFontSize,
    double? itemContentLineHeight,
    Color? itemContentTextColor,
    Color? itemContentBackgroundColor,
    Color? itemTitleDisabledColor,
  }) {
    return DxCollapseThemeData.raw(
      itemTransitionDuration: itemTransitionDuration ?? DxStyle.animationDuration200,
      itemContentPadding:
          itemContentPadding ?? const EdgeInsets.symmetric(vertical: DxStyle.paddingSm, horizontal: DxStyle.paddingMd),
      itemContentFontSize: itemContentFontSize ?? DxStyle.fontSizeMd,
      itemContentLineHeight: itemContentLineHeight ?? 1.5,
      itemContentTextColor: itemContentTextColor ?? DxStyle.gray6,
      itemContentBackgroundColor: itemContentBackgroundColor ?? DxStyle.white,
      itemTitleDisabledColor: itemTitleDisabledColor ?? DxStyle.gray5,
    );
  }

  const DxCollapseThemeData.raw({
    required this.itemTransitionDuration,
    required this.itemContentPadding,
    required this.itemContentFontSize,
    required this.itemContentLineHeight,
    required this.itemContentTextColor,
    required this.itemContentBackgroundColor,
    required this.itemTitleDisabledColor,
  });

  DxCollapseThemeData copyWith({
    Duration? itemTransitionDuration,
    EdgeInsets? itemContentPadding,
    double? itemContentFontSize,
    double? itemContentLineHeight,
    Color? itemContentTextColor,
    Color? itemContentBackgroundColor,
    Color? itemTitleDisabledColor,
  }) {
    return DxCollapseThemeData(
      itemTransitionDuration: itemTransitionDuration ?? this.itemTransitionDuration,
      itemContentPadding: itemContentPadding ?? this.itemContentPadding,
      itemContentFontSize: itemContentFontSize ?? this.itemContentFontSize,
      itemContentLineHeight: itemContentLineHeight ?? this.itemContentLineHeight,
      itemContentTextColor: itemContentTextColor ?? this.itemContentTextColor,
      itemContentBackgroundColor: itemContentBackgroundColor ?? this.itemContentBackgroundColor,
      itemTitleDisabledColor: itemTitleDisabledColor ?? this.itemTitleDisabledColor,
    );
  }

  DxCollapseThemeData merge(DxCollapseThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      itemTransitionDuration: other.itemTransitionDuration,
      itemContentPadding: other.itemContentPadding,
      itemContentFontSize: other.itemContentFontSize,
      itemContentLineHeight: other.itemContentLineHeight,
      itemContentTextColor: other.itemContentTextColor,
      itemContentBackgroundColor: other.itemContentBackgroundColor,
      itemTitleDisabledColor: other.itemTitleDisabledColor,
    );
  }

  static DxCollapseThemeData lerp(DxCollapseThemeData? a, DxCollapseThemeData? b, double t) {
    return DxCollapseThemeData(
      // itemTransitionDuration:
      //     lerpDuration(a?.itemTransitionDuration, b?.itemTransitionDuration, t),
      itemContentPadding: EdgeInsets.lerp(a?.itemContentPadding, b?.itemContentPadding, t),
      itemContentFontSize: lerpDouble(a?.itemContentFontSize, b?.itemContentFontSize, t),
      itemContentLineHeight: lerpDouble(a?.itemContentLineHeight, b?.itemContentLineHeight, t),
      itemContentTextColor: Color.lerp(a?.itemContentTextColor, b?.itemContentTextColor, t),
      itemContentBackgroundColor: Color.lerp(a?.itemContentBackgroundColor, b?.itemContentBackgroundColor, t),
      itemTitleDisabledColor: Color.lerp(a?.itemTitleDisabledColor, b?.itemTitleDisabledColor, t),
    );
  }
}
