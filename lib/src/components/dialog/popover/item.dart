import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

import 'context.dart';
import 'position_widget.dart';

class DxPopoverItem extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final DxPopoverDirection? direction;
  final double? radius;
  final List<BoxShadow>? boxShadow;
  final Animation<double>? animation;
  final double? arrowWidth;
  final double? arrowHeight;
  final BoxConstraints? constraints;
  final BuildContext context;
  final double? arrowDxOffset;
  final double? arrowDyOffset;
  final double? contentDyOffset;
  final bool Function()? isParentAlive;
  final DxPopoverTransition transition;

  const DxPopoverItem({
    required this.child,
    required this.context,
    required this.transition,
    this.backgroundColor,
    this.direction,
    this.radius,
    this.boxShadow,
    this.animation,
    this.arrowWidth,
    this.arrowHeight,
    this.constraints,
    this.arrowDxOffset,
    this.arrowDyOffset,
    this.contentDyOffset,
    this.isParentAlive,
    Key? key,
  }) : super(key: key);

  @override
  State<DxPopoverItem> createState() => _DxPopoverItemState();
}

class _DxPopoverItemState extends State<DxPopoverItem> {
  late BoxConstraints constraints;
  late Offset offset;
  late Rect bounds;
  late Rect attachRect;

  @override
  void initState() {
    super.initState();
    final bool isParentAlive;

    if (widget.isParentAlive != null) {
      isParentAlive = widget.isParentAlive!();
    } else {
      isParentAlive = true;
    }

    if (!isParentAlive) {
      return;
    }

    final box = widget.context.findRenderObject() as RenderBox;
    if (mounted && box.owner != null) {
      _configureConstraints();
      _configureRect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, __) {
        return Stack(
          children: [
            DxPopoverPositionWidget(
              attachRect: attachRect,
              scale: widget.animation,
              constraints: constraints,
              direction: widget.direction,
              arrowHeight: widget.arrowHeight,
              child: DxPopoverContext(
                attachRect: attachRect,
                animation: widget.animation,
                radius: widget.radius,
                backgroundColor: widget.backgroundColor,
                boxShadow: widget.boxShadow,
                direction: widget.direction,
                arrowWidth: widget.arrowWidth,
                arrowHeight: widget.arrowHeight,
                transition: widget.transition,
                child: Material(type: MaterialType.transparency, child: widget.child),
              ),
            )
          ],
        );
      },
    );
  }

  void _configureConstraints() {
    if (widget.constraints != null) {
      constraints = BoxConstraints(maxHeight: 1.sh / 2, maxWidth: 1.sw / 2).copyWith(
        minWidth: widget.constraints!.minWidth.isFinite ? widget.constraints!.minWidth : null,
        minHeight: widget.constraints!.minHeight.isFinite ? widget.constraints!.minHeight : null,
        maxWidth: widget.constraints!.maxWidth.isFinite ? widget.constraints!.maxWidth : null,
        maxHeight: widget.constraints!.maxHeight.isFinite ? widget.constraints!.maxHeight : null,
      );
    } else {
      constraints = BoxConstraints(maxHeight: 1.sh / 2, maxWidth: 1.sw / 2);
    }
    if (widget.direction == DxPopoverDirection.top || widget.direction == DxPopoverDirection.bottom) {
      constraints = constraints.copyWith(
        maxHeight: constraints.maxHeight + widget.arrowHeight!,
        maxWidth: constraints.maxWidth,
      );
    } else {
      constraints = constraints.copyWith(
        maxHeight: constraints.maxHeight + widget.arrowHeight!,
        maxWidth: constraints.maxWidth + widget.arrowWidth!,
      );
    }
  }

  void _configureRect() {
    offset = BuildContextExtension.getWidgetLocalToGlobal(widget.context);
    bounds = BuildContextExtension.getWidgetBounds(widget.context);
    attachRect = Rect.fromLTWH(
      offset.dx + (widget.arrowDxOffset ?? 0.0),
      offset.dy + (widget.arrowDyOffset ?? 0.0),
      bounds.width,
      bounds.height + (widget.contentDyOffset ?? 0.0),
    );
  }
}

extension BuildContextExtension on BuildContext {
  static Rect getWidgetBounds(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return (box != null) ? box.semanticBounds : Rect.zero;
  }

  static Offset getWidgetLocalToGlobal(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return box == null ? Offset.zero : box.localToGlobal(Offset.zero);
  }
}
