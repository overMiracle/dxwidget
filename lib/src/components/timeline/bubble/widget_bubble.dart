import 'package:dxwidget/src/components/timeline/bubble/index.dart';
import 'package:flutter/material.dart';

/// The widget to render the bubble for the timeline
class DxTimelineBubbleItemWidget extends StatelessWidget {
  /// The bubble's content direction (left or right)
  final DxBubbleTimelineTerminalDirection direction;

  /// The size of the bubble
  final double size;

  /// The bubble's title
  final String? title;

  /// The bubble's subtitle
  final String? subtitle;

  /// /// The bubble's description
  final String? description;

  /// The icon that will display in the middle of the bubble
  final Widget? icon;

  /// The color of the timeline
  final Color stripColor;

  /// The bubble's background color.
  /// This color should be the same with your Scaffold background color and different from the [stripColor]
  final Color bgColor;

  /// The bubble's color
  final Color bubbleColor;

  /// The TextStyle of the title text
  ///
  /// Default title's style is:
  ///
  /// ```dart
  /// const TextStyle(
  ///   fontWeight: FontWeight.w700,
  /// ),
  /// ```
  final TextStyle? titleStyle;

  /// The TextStyle of the subtitle text
  final TextStyle? subtitleStyle;

  /// The TextStyle of the description text
  final TextStyle? descriptionStyle;

  /// The distance between items in the timeline
  final double spaceBetweenItems;

  /// Provide your custom title widget if you don't want to use the default title widget
  final Widget? titleWidget;

  /// Provide your custom subtitle widget if you don't want to use the default subtitle widget
  final Widget? subtitleWidget;

  /// Provide your custom description widget if you don't want to use the default description widget
  final Widget? descriptionWidget;

  /// Constructor
  const DxTimelineBubbleItemWidget({
    Key? key,
    required this.direction,
    this.bubbleColor = Colors.blue,
    this.bgColor = Colors.white,
    this.stripColor = Colors.teal,
    this.icon,
    this.title,
    this.size = 120,
    this.subtitle,
    this.description,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.spaceBetweenItems = 20.0,
    this.titleWidget,
    this.subtitleWidget,
    this.descriptionWidget,
  })  : assert(direction == DxBubbleTimelineTerminalDirection.left ||
            direction == DxBubbleTimelineTerminalDirection.right),
        // assert(title != null || titleWidget != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: direction == DxBubbleTimelineTerminalDirection.left
                ? <Widget>[
                    if (title != null || subtitleWidget != null)
                      titleWidget ??
                          Text(
                            title!,
                            style: titleStyle ??
                                const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                            textAlign: TextAlign.right,
                          ),
                    if (subtitle != null || subtitleWidget != null) ...[
                      const SizedBox(
                        height: 5,
                      ),
                      subtitleWidget ??
                          Text(
                            subtitle!,
                            textAlign: TextAlign.right,
                            style: subtitleStyle,
                          ),
                    ],
                    if (description != null || descriptionWidget != null) ...[
                      const SizedBox(
                        height: 5,
                      ),
                      descriptionWidget ??
                          Text(
                            description!,
                            textAlign: TextAlign.right,
                            style: descriptionStyle,
                          ),
                    ],
                  ]
                : [],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: spaceBetweenItems,
              width: 6,
              color: stripColor,
            ),
            Container(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    height: size,
                    child: ClipPath(
                      clipper: direction == DxBubbleTimelineTerminalDirection.left
                          ? DxBubbleTimelineLeftClipper()
                          : DxBubbleTimelineRightClipper(),
                      child: Container(
                        width: size,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: stripColor),
                      ),
                    ),
                  ),
                  Container(
                    height: size - 10,
                    width: size - 10,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
                  ),
                  Container(
                    height: size - 20,
                    width: size - 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: bubbleColor),
                    child: icon,
                  ),
                ],
              ),
            ),
            // Container(height: spaceBetweenItems / 2, width: 5, color: stripColor),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: direction == DxBubbleTimelineTerminalDirection.right
                ? <Widget>[
                    if (title != null || titleWidget != null)
                      titleWidget ??
                          Text(
                            title!,
                            style: titleStyle ??
                                const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                            textAlign: TextAlign.left,
                          ),
                    if (subtitle != null) ...[
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.left,
                        style: subtitleStyle,
                      ),
                    ],
                    if (description != null) ...[
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        description!,
                        textAlign: TextAlign.left,
                        style: descriptionStyle,
                      ),
                    ],
                  ]
                : [],
          ),
        ),
      ],
    );
  }
}
