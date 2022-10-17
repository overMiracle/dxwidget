import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 切换按钮主题
class DxSwitchTheme extends InheritedTheme {
  const DxSwitchTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static Widget merge({
    Key? key,
    required DxSwitchThemeData data,
    required Widget child,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return DxSwitchTheme(
          key: key,
          data: DxSwitchTheme.of(context).merge(data),
          child: child,
        );
      },
    );
  }

  final DxSwitchThemeData data;

  static DxSwitchThemeData of(BuildContext context) {
    final DxSwitchTheme? switchTheme = context.dependOnInheritedWidgetOfExactType<DxSwitchTheme>();
    return switchTheme?.data ?? DxTheme.of(context).switchTheme;
  }

  @override
  bool updateShouldNotify(DxSwitchTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxSwitchTheme(data: data, child: child);
  }
}

class DxSwitchThemeData {
  final double size;
  final double width;
  final double height;
  final double nodeSize;
  final Color nodeBackgroundColor;
  final List<BoxShadow>? nodeBoxShadow;
  final Color backgroundColor;
  final Color onBackgroundColor;
  final Duration transitionDuration;
  final double disabledOpacity;
  final BorderSide border;

  factory DxSwitchThemeData({
    double? size,
    double? width,
    double? height,
    double? nodeSize,
    Color? nodeBackgroundColor,
    List<BoxShadow>? nodeBoxShadow,
    Color? backgroundColor,
    Color? onBackgroundColor,
    Duration? transitionDuration,
    double? disabledOpacity,
    BorderSide? border,
  }) {
    return DxSwitchThemeData.raw(
      size: size ?? 30.0,
      width: width ?? 2.0,
      height: height ?? 1.0,
      nodeSize: nodeSize ?? 1.0,
      nodeBackgroundColor: nodeBackgroundColor ?? DxStyle.white,
      nodeBoxShadow: nodeBoxShadow ??
          <BoxShadow>[
            const BoxShadow(
              offset: Offset(0.0, 3.0),
              blurRadius: 1.0,
              spreadRadius: 0.0,
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
            const BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
            const BoxShadow(
              offset: Offset(0.0, 3.0),
              blurRadius: 3.0,
              spreadRadius: 0.0,
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
          ],
      backgroundColor: backgroundColor ?? DxStyle.white,
      onBackgroundColor: onBackgroundColor ?? DxStyle.blue,
      transitionDuration: transitionDuration ?? DxStyle.animationDurationBase,
      disabledOpacity: disabledOpacity ?? DxStyle.disabledOpacity,
      border: border ??
          const BorderSide(
            width: DxStyle.borderWidthBase,
            style: BorderStyle.solid,
            color: Color.fromRGBO(0, 0, 0, .1),
          ),
    );
  }

  const DxSwitchThemeData.raw({
    required this.size,
    required this.width,
    required this.height,
    required this.nodeSize,
    required this.nodeBackgroundColor,
    required this.nodeBoxShadow,
    required this.backgroundColor,
    required this.onBackgroundColor,
    required this.transitionDuration,
    required this.disabledOpacity,
    required this.border,
  });

  DxSwitchThemeData copyWith({
    double? size,
    double? width,
    double? height,
    double? nodeSize,
    Color? nodeBackgroundColor,
    List<BoxShadow>? nodeBoxShadow,
    Color? backgroundColor,
    Color? onBackgroundColor,
    Duration? transitionDuration,
    double? disabledOpacity,
    BorderSide? border,
  }) {
    return DxSwitchThemeData(
      size: size ?? this.size,
      width: width ?? this.width,
      height: height ?? this.height,
      nodeSize: nodeSize ?? this.nodeSize,
      nodeBackgroundColor: nodeBackgroundColor ?? this.nodeBackgroundColor,
      nodeBoxShadow: nodeBoxShadow ?? this.nodeBoxShadow,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      onBackgroundColor: onBackgroundColor ?? this.onBackgroundColor,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      border: border ?? this.border,
    );
  }

  DxSwitchThemeData merge(DxSwitchThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      size: other.size,
      width: other.width,
      height: other.height,
      nodeSize: other.nodeSize,
      nodeBackgroundColor: other.nodeBackgroundColor,
      nodeBoxShadow: other.nodeBoxShadow,
      backgroundColor: other.backgroundColor,
      onBackgroundColor: other.onBackgroundColor,
      transitionDuration: other.transitionDuration,
      disabledOpacity: other.disabledOpacity,
      border: other.border,
    );
  }

  static DxSwitchThemeData lerp(DxSwitchThemeData? a, DxSwitchThemeData? b, double t) {
    return DxSwitchThemeData(
      size: lerpDouble(a?.size, b?.size, t),
      width: lerpDouble(a?.width, b?.width, t),
      height: lerpDouble(a?.height, b?.height, t),
      nodeSize: lerpDouble(a?.nodeSize, b?.nodeSize, t),
      nodeBackgroundColor: Color.lerp(a?.nodeBackgroundColor, b?.nodeBackgroundColor, t),
      nodeBoxShadow: BoxShadow.lerpList(a?.nodeBoxShadow, b?.nodeBoxShadow, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      onBackgroundColor: Color.lerp(a?.onBackgroundColor, b?.onBackgroundColor, t),
      transitionDuration:
          lerpDuration(a?.transitionDuration ?? Duration.zero, b?.transitionDuration ?? Duration.zero, t),
      disabledOpacity: lerpDouble(a?.disabledOpacity, b?.disabledOpacity, t),
      border: BorderSide.lerp(a?.border ?? BorderSide.none, b?.border ?? BorderSide.none, t),
    );
  }
}
