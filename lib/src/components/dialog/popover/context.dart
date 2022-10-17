import 'package:flutter/material.dart';

import 'defined.dart';
import 'render_shifted_box.dart';

class DxPopoverContext extends SingleChildRenderObjectWidget {
  final Rect? attachRect;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Animation<double>? animation;
  final double? radius;
  final DxPopoverDirection? direction;
  final double? arrowWidth;
  final double? arrowHeight;
  final DxPopoverTransition transition;

  const DxPopoverContext({
    super.key,
    required this.transition,
    Widget? child,
    this.attachRect,
    this.backgroundColor,
    this.boxShadow,
    this.animation,
    this.radius,
    this.direction,
    this.arrowWidth,
    this.arrowHeight,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return DxPopoverRenderShiftedBox(
      attachRect: attachRect,
      color: backgroundColor,
      boxShadow: boxShadow,
      scale: animation!.value,
      direction: direction,
      radius: radius,
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    DxPopoverRenderShiftedBox renderObject,
  ) {
    renderObject
      ..attachRect = attachRect
      ..color = backgroundColor
      ..boxShadow = boxShadow
      ..scale = transition == DxPopoverTransition.scale ? animation!.value : 1.0
      ..direction = direction
      ..radius = radius
      ..arrowWidth = arrowWidth
      ..arrowHeight = arrowHeight;
  }
}
