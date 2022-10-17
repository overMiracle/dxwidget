import 'dart:math';
import 'dart:ui' as ui;

import 'package:dxwidget/src/components/timeline/tile/index.dart';
import 'package:flutter/material.dart';

/// The axis used on the [DxTileTimeline].
enum DxTileTimelineAxis {
  /// Renders the tile in the [vertical] axis.
  vertical,

  /// Renders the tile in the [horizontal] axis.
  horizontal,
}

/// The alignment used on the [DxTileTimeline].
enum DxTileTimelineAlign {
  /// Automatically align the line to the start according to [DxTileTimelineAxis],
  /// only the ([DxTileTimeline.rightChild]) will be available.
  start,

  /// Automatically align the line to the end according to [DxTileTimelineAxis],
  /// only the ([DxTileTimeline.leftChild]) will be available.
  end,

  /// Automatically align the line to the center, both ([DxTileTimeline.leftChild])
  /// and ([DxTileTimeline.rightChild]) will be available.
  center,

  /// Indicates that the line will be aligned manually and must be used with ([DxTileTimeline.lineX]),
  /// both ([DxTileTimeline.leftChild]) and ([DxTileTimeline.rightChild]) will be available
  /// depending on the free space.
  manual,
}

/// A tile that renders a timeline format.
class DxTileTimeline extends StatelessWidget {
  const DxTileTimeline({
    Key? key,
    this.axis = DxTileTimelineAxis.vertical,
    this.alignment = DxTileTimelineAlign.start,
    this.startChild,
    this.endChild,
    this.lineXY,
    this.hasIndicator = true,
    this.isFirst = false,
    this.isLast = false,
    this.indicatorStyle = const DxTileTimelineIndicatorStyle(width: 25),
    this.beforeLineStyle = const DxTileTimelineLineStyle(),
    DxTileTimelineLineStyle? afterLineStyle,
  })  : afterLineStyle = afterLineStyle ?? beforeLineStyle,
        assert(alignment != DxTileTimelineAlign.start || startChild == null,
            'Cannot provide startChild with automatic alignment to the left'),
        assert(alignment != DxTileTimelineAlign.end || endChild == null,
            'Cannot provide endChild with automatic alignment to the right'),
        assert(
            alignment != DxTileTimelineAlign.manual || (lineXY != null && lineXY >= 0.0 && lineXY <= 1.0),
            'The lineX must be provided when aligning manually, '
            'and must be a value between 0.0 and 1.0 inclusive'),
        super(key: key);

  /// The axis used on the tile. See [DxTileTimelineAxis].
  /// It defaults to [DxTileTimelineAxis.vertical]
  final DxTileTimelineAxis axis;

  /// The alignment used on the line. See [DxTileTimelineAlign].
  /// It defaults to [DxTileTimelineAlign.start]
  final DxTileTimelineAlign alignment;

  /// The child widget positioned at the start
  final Widget? startChild;

  /// The child widget positioned at the end
  final Widget? endChild;

  /// The X (in case of [DxTileTimelineAxis.vertical]) or Y (in case of [DxTileTimelineAxis.horizontal])
  /// axis value used to position the line when [DxTileTimelineAlign.manual].
  /// Must be a value from 0.0 to 1.0
  final double? lineXY;

  /// Whether it should have an indicator (default or custom).
  /// It defaults to true.
  final bool hasIndicator;

  /// Whether this is the first tile from the timeline.
  /// In this case, it won't be rendered a line before the indicator.
  final bool isFirst;

  /// Whether this is the last tile from the timeline.
  /// In this case, it won't be rendered a line after the indicator.
  final bool isLast;

  /// The style used to customize the indicator.
  final DxTileTimelineIndicatorStyle indicatorStyle;

  /// The style used to customize the line rendered before the indicator.
  final DxTileTimelineLineStyle beforeLineStyle;

  /// The style used to customize the line rendered after the indicator.
  /// If null, it defaults to [beforeLineStyle].
  final DxTileTimelineLineStyle afterLineStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double startCrossAxisSpace = 0;
        double endCrossAxisSpace = 0;
        if (axis == DxTileTimelineAxis.vertical) {
          startCrossAxisSpace = indicatorStyle.padding.left;
          endCrossAxisSpace = indicatorStyle.padding.right;
        } else {
          startCrossAxisSpace = indicatorStyle.padding.top;
          endCrossAxisSpace = indicatorStyle.padding.bottom;
        }

        final children = <Widget>[
          if (startCrossAxisSpace > 0)
            SizedBox(
              height: axis == DxTileTimelineAxis.vertical ? null : startCrossAxisSpace,
              width: axis == DxTileTimelineAxis.vertical ? startCrossAxisSpace : null,
            ),
          _Indicator(
            axis: axis,
            beforeLineStyle: beforeLineStyle,
            afterLineStyle: afterLineStyle,
            indicatorStyle: indicatorStyle,
            hasIndicator: hasIndicator,
            isLast: isLast,
            isFirst: isFirst,
          ),
          if (endCrossAxisSpace > 0)
            SizedBox(
              height: axis == DxTileTimelineAxis.vertical ? null : endCrossAxisSpace,
              width: axis == DxTileTimelineAxis.vertical ? endCrossAxisSpace : null,
            ),
        ];

        final defaultChild = axis == DxTileTimelineAxis.vertical ? Container(height: 100) : Container(width: 100);
        if (alignment == DxTileTimelineAlign.start) {
          children.add(Expanded(child: endChild ?? defaultChild));
        } else if (alignment == DxTileTimelineAlign.end) {
          children.insert(0, Expanded(child: startChild ?? defaultChild));
        } else {
          final indicatorAxisXY = alignment == DxTileTimelineAlign.center ? 0.5 : lineXY!;
          final indicatorTotalSize = _indicatorTotalSize();

          final positioning = calculateAxisPositioning(
            totalSize: axis == DxTileTimelineAxis.vertical ? constraints.maxWidth : constraints.maxHeight,
            objectSize: indicatorTotalSize,
            axisPosition: indicatorAxisXY,
          );

          if (positioning.firstSpace.size > 0) {
            children.insert(
              0,
              SizedBox(
                height: axis == DxTileTimelineAxis.horizontal ? positioning.firstSpace.size : null,
                width: axis == DxTileTimelineAxis.vertical ? positioning.firstSpace.size : null,
                child: startChild ?? defaultChild,
              ),
            );
          }

          if (positioning.secondSpace.size > 0) {
            children.add(
              SizedBox(
                height: axis == DxTileTimelineAxis.horizontal ? positioning.secondSpace.size : null,
                width: axis == DxTileTimelineAxis.vertical ? positioning.secondSpace.size : null,
                child: endChild ?? defaultChild,
              ),
            );
          }
        }

        return axis == DxTileTimelineAxis.vertical
            ? IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: children,
                ),
              )
            : IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: children,
                ),
              );
      },
    );
  }

  double _indicatorTotalSize() {
    if (axis == DxTileTimelineAxis.vertical) {
      return indicatorStyle.padding.left +
          indicatorStyle.padding.right +
          (hasIndicator ? indicatorStyle.width : max(beforeLineStyle.thickness, afterLineStyle.thickness));
    }

    return indicatorStyle.padding.top +
        indicatorStyle.padding.bottom +
        (hasIndicator ? indicatorStyle.height : max(beforeLineStyle.thickness, afterLineStyle.thickness));
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.axis,
    required this.beforeLineStyle,
    required this.afterLineStyle,
    required this.indicatorStyle,
    required this.hasIndicator,
    required this.isFirst,
    required this.isLast,
  });

  /// See [DxTileTimeline.axis]
  final DxTileTimelineAxis axis;

  /// See [DxTileTimeline.beforeLineStyle]
  final DxTileTimelineLineStyle beforeLineStyle;

  /// See [DxTileTimeline.afterLineStyle]
  final DxTileTimelineLineStyle afterLineStyle;

  /// See [DxTileTimeline.indicatorStyle]
  final DxTileTimelineIndicatorStyle indicatorStyle;

  /// See [DxTileTimeline.hasIndicator]
  final bool hasIndicator;

  /// See [DxTileTimeline.isFirst]
  final bool isFirst;

  /// See [DxTileTimeline.isLast]
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    double size;
    if (axis == DxTileTimelineAxis.vertical) {
      size = hasIndicator ? indicatorStyle.width : max(beforeLineStyle.thickness, afterLineStyle.thickness);
    } else {
      size = hasIndicator ? indicatorStyle.height : max(beforeLineStyle.thickness, afterLineStyle.thickness);
    }

    final childrenStack = <Widget>[
      SizedBox(
        height: axis == DxTileTimelineAxis.vertical ? double.infinity : size,
        width: axis == DxTileTimelineAxis.vertical ? size : double.infinity,
      )
    ];

    final renderDefaultIndicator = hasIndicator && indicatorStyle.indicator == null;
    if (!renderDefaultIndicator) {
      childrenStack.add(
        _buildCustomIndicator(),
      );
    }

    final painter = _TimelinePainter(
      axis: axis,
      beforeLineStyle: beforeLineStyle,
      afterLineStyle: afterLineStyle,
      indicatorStyle: indicatorStyle,
      paintIndicator: renderDefaultIndicator,
      isFirst: isFirst,
      isLast: isLast,
    );

    return CustomPaint(
      painter: painter,
      child: Stack(
        children: childrenStack,
      ),
    );
  }

  Widget _buildCustomIndicator() {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          DxTileTimelineAxisPosition position;
          EdgeInsets spaceChildren;
          EdgeInsets spacePadding;
          if (axis == DxTileTimelineAxis.vertical) {
            position = calculateAxisPositioning(
              totalSize: constraints.maxHeight,
              objectSize: indicatorStyle.totalHeight,
              axisPosition: indicatorStyle.indicatorXY,
            );
            spaceChildren = EdgeInsets.only(
              top: position.firstSpace.size,
              bottom: position.secondSpace.size,
            );
            spacePadding = EdgeInsets.only(
              top: indicatorStyle.padding.top,
              bottom: indicatorStyle.padding.bottom,
            );
          } else {
            position = calculateAxisPositioning(
              totalSize: constraints.maxWidth,
              objectSize: indicatorStyle.totalWidth,
              axisPosition: indicatorStyle.indicatorXY,
            );
            spaceChildren = EdgeInsets.only(
              left: position.firstSpace.size,
              right: position.secondSpace.size,
            );
            spacePadding = EdgeInsets.only(
              left: indicatorStyle.padding.left,
              right: indicatorStyle.padding.right,
            );
          }

          return Padding(
            padding: spaceChildren,
            child: Padding(
              padding: spacePadding,
              child: SizedBox(
                height: indicatorStyle.height,
                width: indicatorStyle.width,
                child: indicatorStyle.indicator,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A custom painter that renders a line and an indicator
class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.axis,
    this.paintIndicator = true,
    this.isFirst = false,
    this.isLast = false,
    required DxTileTimelineIndicatorStyle indicatorStyle,
    required DxTileTimelineLineStyle beforeLineStyle,
    required DxTileTimelineLineStyle afterLineStyle,
  })  : beforeLinePaint = Paint()
          ..color = beforeLineStyle.color
          ..strokeWidth = beforeLineStyle.thickness,
        afterLinePaint = Paint()
          ..color = afterLineStyle.color
          ..strokeWidth = afterLineStyle.thickness,
        indicatorPaint = !paintIndicator ? null : (Paint()..color = indicatorStyle.color),
        indicatorXY = indicatorStyle.indicatorXY,
        indicatorSize = axis == DxTileTimelineAxis.vertical
            ? (paintIndicator ? indicatorStyle.width : (indicatorStyle.indicator != null ? indicatorStyle.height : 0))
            : (paintIndicator ? indicatorStyle.height : (indicatorStyle.indicator != null ? indicatorStyle.width : 0)),
        indicatorStartGap =
            axis == DxTileTimelineAxis.vertical ? indicatorStyle.padding.top : indicatorStyle.padding.left,
        indicatorEndGap =
            axis == DxTileTimelineAxis.vertical ? indicatorStyle.padding.bottom : indicatorStyle.padding.right,
        drawGap = indicatorStyle.drawGap,
        iconData = indicatorStyle.iconStyle?.iconData,
        iconColor = indicatorStyle.iconStyle?.color,
        iconSize = indicatorStyle.iconStyle?.fontSize;

  /// The axis used to render the line at the [DxTileTimelineAxis.vertical]
  /// or [DxTileTimelineAxis.horizontal].
  final DxTileTimelineAxis axis;

  /// Value from 0.0 to 1.0 indicating the percentage in which the indicator
  /// should be positioned on the line, either on Y if [DxTileTimelineAxis.vertical]
  /// or X if [DxTileTimelineAxis.horizontal].
  /// For widget, 0.2 means 20% from start to end. It defaults to 0.5.
  final double indicatorXY;

  /// A gap/space between the line and the indicator
  final double indicatorStartGap;

  /// A gap/space between the line and the indicator
  final double indicatorEndGap;

  /// The size from the indicator. If it is the default indicator, the height
  /// will be equal to the width (when axis vertical), or the width will be
  /// equal to the height (when axis horizontal), which is the equivalent of the
  /// diameter of the circumference.
  final double indicatorSize;

  /// Used to paint the top line
  final Paint beforeLinePaint;

  /// Used to paint the bottom line
  final Paint afterLinePaint;

  /// Used to paint the indicator
  final Paint? indicatorPaint;

  /// Whether it should paint a default indicator. It defaults to true.
  final bool paintIndicator;

  /// Whether this paint should start the line somewhere in the middle,
  /// according to [indicatorY]. It defaults to false.
  final bool isFirst;

  /// Whether this paint should end the line somewhere in the middle,
  /// according to [indicatorY]. It defaults to false.
  final bool isLast;

  /// If there must be a gap between the lines. The gap size will always be the
  /// [indicatorSize] + [indicatorStartGap] + [indicatorEndGap].
  final bool drawGap;

  /// The icon rendered with the default indicator.
  final IconData? iconData;

  /// The icon color.
  final Color? iconColor;

  /// The icon size. If not provided, the size will be adjusted according to [indicatorRadius].
  final double? iconSize;

  @override
  void paint(Canvas canvas, Size size) {
    final hasGap = indicatorStartGap > 0 || indicatorEndGap > 0 || drawGap;

    final centerAxis = axis == DxTileTimelineAxis.vertical ? size.width / 2 : size.height / 2;
    final indicatorTotalSize = indicatorSize + indicatorEndGap + indicatorStartGap;
    final position = calculateAxisPositioning(
      totalSize: axis == DxTileTimelineAxis.vertical ? size.height : size.width,
      objectSize: indicatorTotalSize,
      axisPosition: indicatorXY,
    );

    if (!hasGap) {
      _drawSingleLine(canvas, centerAxis, position);
    } else {
      if (!isFirst) {
        _drawBeforeLine(canvas, centerAxis, position);
      }
      if (!isLast) {
        _drawAfterLine(canvas, centerAxis, position);
      }
    }

    if (paintIndicator) {
      final indicatorRadius = (position.objectSpace.size - indicatorStartGap - indicatorEndGap) / 2;
      final indicatorCenterPoint = position.objectSpace.start + indicatorStartGap + indicatorRadius;

      final indicatorCenter = axis == DxTileTimelineAxis.vertical
          ? Offset(centerAxis, indicatorCenterPoint)
          : Offset(indicatorCenterPoint, centerAxis);
      canvas.drawCircle(indicatorCenter, indicatorRadius, indicatorPaint!);

      if (iconData != null) {
        var fontSize = iconSize;
        fontSize ??= (indicatorRadius * 2) - 10;

        final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
          fontFamily: iconData!.fontFamily,
        ));
        builder.pushStyle(ui.TextStyle(
          fontSize: fontSize,
          color: iconColor,
        ));
        builder.addText(String.fromCharCode(iconData!.codePoint));

        final paragraph = builder.build();
        paragraph.layout(const ui.ParagraphConstraints(width: 0.0));

        final halfIconSize = fontSize / 2;
        final offsetIcon = Offset(indicatorCenter.dx - halfIconSize, indicatorCenter.dy - halfIconSize);
        canvas.drawParagraph(paragraph, offsetIcon);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _drawSingleLine(Canvas canvas, double centerAxis, DxTileTimelineAxisPosition position) {
    if (!isFirst) {
      final beginTopLine = axis == DxTileTimelineAxis.vertical ? Offset(centerAxis, 0) : Offset(0, centerAxis);
      final endTopLine = axis == DxTileTimelineAxis.vertical
          ? Offset(
              centerAxis,
              paintIndicator || !drawGap ? position.objectSpace.center : position.firstSpace.end,
            )
          : Offset(
              paintIndicator || !drawGap ? position.objectSpace.center : position.firstSpace.end,
              centerAxis,
            );
      canvas.drawLine(beginTopLine, endTopLine, beforeLinePaint);
    }

    if (!isLast) {
      final beginBottomLine = axis == DxTileTimelineAxis.vertical
          ? Offset(
              centerAxis,
              paintIndicator || !drawGap ? position.objectSpace.center : position.objectSpace.end,
            )
          : Offset(
              paintIndicator || !drawGap ? position.objectSpace.center : position.objectSpace.end,
              centerAxis,
            );
      final endBottomLine = axis == DxTileTimelineAxis.vertical
          ? Offset(centerAxis, position.secondSpace.end)
          : Offset(position.secondSpace.end, centerAxis);
      canvas.drawLine(beginBottomLine, endBottomLine, afterLinePaint);
    }
  }

  void _drawBeforeLine(Canvas canvas, double centerAxis, DxTileTimelineAxisPosition position) {
    final beginTopLine = axis == DxTileTimelineAxis.vertical ? Offset(centerAxis, 0) : Offset(0, centerAxis);
    final endTopLine = axis == DxTileTimelineAxis.vertical
        ? Offset(centerAxis, position.firstSpace.end)
        : Offset(position.firstSpace.end, centerAxis);

    final lineSize = axis == DxTileTimelineAxis.vertical ? endTopLine.dy : endTopLine.dx;
    // if the line size is less or equal than 0, the line shouldn't be rendered
    if (lineSize > 0) {
      canvas.drawLine(beginTopLine, endTopLine, beforeLinePaint);
    }
  }

  void _drawAfterLine(Canvas canvas, double centerAxis, DxTileTimelineAxisPosition position) {
    final beginBottomLine = axis == DxTileTimelineAxis.vertical
        ? Offset(centerAxis, position.secondSpace.start)
        : Offset(position.secondSpace.start, centerAxis);
    final endBottomLine = axis == DxTileTimelineAxis.vertical
        ? Offset(centerAxis, position.secondSpace.end)
        : Offset(position.secondSpace.end, centerAxis);

    final lineSize = axis == DxTileTimelineAxis.vertical
        ? endBottomLine.dy - beginBottomLine.dy
        : endBottomLine.dx - beginBottomLine.dx;
    // if the line size is less or equal than 0, the line shouldn't be rendered
    if (lineSize > 0) {
      canvas.drawLine(beginBottomLine, endBottomLine, afterLinePaint);
    }
  }
}

/// This is a port from the original [Divider].
/// Except that this one allows to define the start and end
/// according to the width available, with percentage values
/// from 0.0 to 1.0
class TimelineDivider extends StatelessWidget {
  /// Creates a material design divider that can be used in conjunction to [TimelineTile].
  const TimelineDivider({
    Key? key,
    this.axis = DxTileTimelineAxis.horizontal,
    this.thickness = 2,
    this.begin = 0.0,
    this.end = 1.0,
    this.color = Colors.grey,
  })  : assert(thickness >= 0.0, 'The thickness must be a positive value'),
        assert(begin >= 0.0 && begin <= 1.0, 'The begin value must be between 0.0 and 1.0'),
        assert(end >= 0.0 && end <= 1.0, 'The end value must be between 0.0 and 1.0'),
        assert(end > begin, 'The end value must be bigger than the begin'),
        super(key: key);

  /// The axis used to render the line at the [DxTileTimelineAxis.vertical]
  /// or [DxTileTimelineAxis.horizontal]. Usually, the opposite axis from the tiles.
  /// It defaults to [DxTileTimelineAxis.horizontal].
  final DxTileTimelineAxis axis;

  /// The thickness of the line drawn within the divider.
  ///
  /// It must be a positive value. It defaults to 2.
  final double thickness;

  /// Where the line must start to be drawn.
  /// This represents a percentage from the available width.
  ///
  /// It must be less than [end] and defaults to 0.0.
  final double begin;

  /// Where the drawn from the line must end.
  /// This represents a percentage from the available width.
  ///
  /// It must be bigger than [begin] and defaults to 1.0.
  final double end;

  /// The color to use when painting the line.
  ///
  /// It defaults to [Colors.grey].
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double halfThickness = thickness / 2;

        EdgeInsetsDirectional margin;
        if (axis == DxTileTimelineAxis.horizontal) {
          final double width = constraints.maxWidth;
          final double beginX = width * begin;
          final double endX = width * end;

          margin = EdgeInsetsDirectional.only(
            start: beginX - halfThickness,
            end: width - endX - halfThickness,
          );
        } else {
          final double height = constraints.maxHeight;
          final double beginY = height * begin;
          final double endY = height * end;

          margin = EdgeInsetsDirectional.only(
            top: beginY - halfThickness,
            bottom: height - endY - halfThickness,
          );
        }

        return Container(
          height: thickness,
          margin: margin,
          decoration: BoxDecoration(
            border: Border(
              left: axis == DxTileTimelineAxis.vertical
                  ? BorderSide(
                      color: color,
                      width: thickness,
                    )
                  : BorderSide.none,
              bottom: axis == DxTileTimelineAxis.horizontal
                  ? BorderSide(
                      color: color,
                      width: thickness,
                    )
                  : BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
