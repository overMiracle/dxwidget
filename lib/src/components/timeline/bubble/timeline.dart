import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/timeline/bubble/index.dart';
import 'package:flutter/material.dart';

/// A Bubble Timeline Widget.
/// pub地址：https://pub.dev/packages/lecle_bubble_timeline
class DxBubbleTimeline extends StatefulWidget {
  /// The size of the bubbles in the timeline. Default size is 120
  final double bubbleSize;

  /// The list contains info of the items in the timeline
  final List<DxBubbleTimelineItem> items;

  /// The color of the timeline
  final Color stripColor;

  /// The distance between the bubbles in the timeline widget
  final double spaceBetweenItems;

  /// The padding for the items list
  final EdgeInsets? padding;

  /// The size of the dots at top and bottom
  final double dotSize;

  /// This is color of your scaffold.
  /// Use same color as used for Scaffold background.
  final Color dividerCircleColor;

  /// Constructor
  const DxBubbleTimeline({
    Key? key,
    required this.items,
    this.stripColor = Colors.teal,
    this.bubbleSize = 120,
    this.dividerCircleColor = Colors.white,
    this.spaceBetweenItems = 20.0,
    this.padding,
    this.dotSize = 20.0,
  }) : super(key: key);

  @override
  State<DxBubbleTimeline> createState() => _DxBubbleTimelineState();
}

class _DxBubbleTimelineState extends State<DxBubbleTimeline> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: DxNoScrollBehavior(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: widget.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DxBubbleTimelineTerminalWidget(
              terminalWidgetColor: widget.stripColor,
              direction: DxBubbleTimelineTerminalDirection.top,
              spaceBetweenItems: widget.spaceBetweenItems,
              dotSize: widget.dotSize,
            ),
            ...List.generate(
              widget.items.length,
              (index) => DxTimelineBubbleItemWidget(
                direction:
                    index.isEven ? DxBubbleTimelineTerminalDirection.left : DxBubbleTimelineTerminalDirection.right,
                size: widget.bubbleSize,
                title: widget.items[index].title,
                subtitle: widget.items[index].subtitle,
                description: widget.items[index].description,
                icon: widget.items[index].icon,
                stripColor: widget.stripColor,
                bubbleColor: widget.items[index].bubbleColor,
                bgColor: widget.dividerCircleColor,
                spaceBetweenItems: widget.spaceBetweenItems,
                titleStyle: widget.items[index].titleStyle,
                subtitleStyle: widget.items[index].subtitleStyle,
                descriptionStyle: widget.items[index].descriptionStyle,
                titleWidget: widget.items[index].titleWidget,
                subtitleWidget: widget.items[index].subtitleWidget,
                descriptionWidget: widget.items[index].descriptionWidget,
              ),
            ),
            DxBubbleTimelineTerminalWidget(
              terminalWidgetColor: widget.stripColor,
              direction: DxBubbleTimelineTerminalDirection.bottom,
              spaceBetweenItems: widget.spaceBetweenItems,
              dotSize: widget.dotSize,
            ),
          ],
        ),
      ),
    );
  }
}

class DxBubbleTimelineItem {
  /// The title of the item's content
  final String? title;

  /// The subtitle of the item's content
  final String? subtitle;

  /// The description of the item's content
  final String? description;

  /// The custom icon for the item that will be displayed in the circle
  final Widget? icon;

  /// The color for the circle of the item
  final Color bubbleColor;

  /// The custom TextStyle for the item's title
  final TextStyle? titleStyle;

  /// The custom TextStyle of the item's subtitle
  final TextStyle? subtitleStyle;

  /// The custom TextStyle of the item's description
  final TextStyle? descriptionStyle;

  /// Provide your custom title widget if you don't want to use the default title widget
  final Widget? titleWidget;

  /// Provide your custom subtitle widget if you don't want to use the default subtitle widget
  final Widget? subtitleWidget;

  /// Provide your custom description widget if you don't want to use the default description widget
  final Widget? descriptionWidget;

  /// Constructor
  const DxBubbleTimelineItem({
    this.title,
    this.bubbleColor = Colors.blue,
    this.icon,
    this.subtitle,
    this.description,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.titleWidget,
    this.subtitleWidget,
    this.descriptionWidget,
  });
}
