import 'package:dxwidget/src/components/timeline/bubble/index.dart';
import 'package:flutter/material.dart';

/// The widget to render the top and bottom dots of the timeline
class DxBubbleTimelineTerminalWidget extends StatelessWidget {
  /// the color of the line and the dot
  final Color terminalWidgetColor;

  /// The direction of the dot ([DxBubbleTimelineTerminalDirection.top] or [DxBubbleTimelineTerminalDirection.bottom])
  final DxBubbleTimelineTerminalDirection direction;

  /// The height of the line is equal with the space between items
  final double spaceBetweenItems;

  /// The size of the dot
  final double dotSize;

  /// Constructor
  const DxBubbleTimelineTerminalWidget({
    Key? key,
    required this.terminalWidgetColor,
    required this.direction,
    this.spaceBetweenItems = 20.0,
    this.dotSize = 20.0,
  })  : assert(direction == DxBubbleTimelineTerminalDirection.top ||
            direction == DxBubbleTimelineTerminalDirection.bottom),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstWidget = Container(
      decoration: BoxDecoration(
        color: terminalWidgetColor,
        shape: BoxShape.circle,
      ),
      height: dotSize,
    );

    final secondWidget = Container(
      height: spaceBetweenItems,
      width: 6,
      color: terminalWidgetColor,
    );

    return Column(
      children: <Widget>[
        if (direction == DxBubbleTimelineTerminalDirection.top) ...[
          Transform.translate(
            offset: const Offset(0.0, 0.3),
            child: firstWidget,
          ),
          // secondWidget,
        ] else if (direction == DxBubbleTimelineTerminalDirection.bottom) ...[
          secondWidget,
          Transform.translate(
            offset: const Offset(0.0, -0.3),
            child: firstWidget,
          ),
        ],
      ],
    );
  }
}
