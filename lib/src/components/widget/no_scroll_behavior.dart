import 'package:flutter/material.dart';

/// 去除listview水印
/// ScrollConfiguration behavior
class DxNoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    TargetPlatform plantForm = getPlatform(context);
    if (plantForm == TargetPlatform.android ||
        plantForm == TargetPlatform.fuchsia) {
      return GlowingOverscrollIndicator(
        showLeading: false,
        showTrailing: false,
        axisDirection: axisDirection,
        color: Theme.of(context).colorScheme.secondary,
        child: child,
      );
    }
    return child;
  }
}
