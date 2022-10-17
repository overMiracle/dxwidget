import 'package:dxwidget/src/components/expand/indicator.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// Default expand animation duration.
const _kExpandDuration = Duration(milliseconds: 200);

/// github地址：https://github.com/jesusrp98/expand_widget
/// This widget unfolds a hidden widget to the user, called [child].
/// This action is performed when the user clicks the 'expand' indicator.
class DxExpandWidget extends StatefulWidget {
  /// This widget will be displayed if the user clicks the 'expand' indicator.
  final Widget child;

  /// How long the expanding animation takes. Default is 300ms.
  final Duration animationDuration;

  /// Ability to hide indicator from display when content is expanded.
  /// Defaults to `false`.
  final bool hideIndicatorOnExpand;

  /// Direction of expansion, vertical by default.
  final Axis direction;

  /// Method to override the [DxExpandIndicator] widget for expanding the content.
  final DxExpandIndicatorBuilder? indicatorBuilder;

  /// Defines indicator rendering style.
  final DxExpandIndicatorStyle indicatorStyle;

  /// Message used as a tooltip when the widget is minimized.
  /// Default value set to [MaterialLocalizations.of(context).collapsedIconTapHint].
  final String? collapsedHint;

  /// Message used as a tooltip when the widget is maximized.
  /// Default value set to [MaterialLocalizations.of(context).expandedIconTapHint].
  final String? expandedHint;

  /// Defines indicator padding value.
  ///
  /// Default value if this widget's icon-only: [EdgeInsets.all(4)].
  /// If text is shown: [EdgeInsets.all(8)].
  final EdgeInsets? indicatorPadding;

  /// Defines indicator icon's color. Defaults to the caption text style color.
  final Color indicatorIconColor;

  /// Defines icon's size. Default is [24].
  final double? indicatorIconSize;

  /// Icon that will be used for the indicator.
  /// Default is [Icons.expand_more].
  final IconData? indicatorIcon;

  /// Style of the displayed message.
  final TextStyle? indicatorHintTextStyle;

  /// Auto capitalize tooltip text. Defaults to `true`.
  final bool capitalizeIndicatorHintText;

  /// Percentage of how much of the 'hidden' widget is show when collapsed.
  /// Defaults to `0.0`.
  final double collapsedVisibilityFactor;

  /// Adjust horizontal alignment of the indicator.
  final Alignment? indicatorAlignment;

  const DxExpandWidget({
    super.key,
    this.animationDuration = _kExpandDuration,
    this.hideIndicatorOnExpand = false,
    this.direction = Axis.vertical,
    this.indicatorBuilder,
    this.indicatorStyle = DxExpandIndicatorStyle.both,
    this.collapsedHint,
    this.expandedHint,
    this.indicatorPadding,
    this.indicatorIconColor = DxStyle.$999999,
    this.indicatorIconSize = 18,
    this.indicatorIcon,
    this.indicatorHintTextStyle,
    this.capitalizeIndicatorHintText = true,
    this.collapsedVisibilityFactor = 0,
    this.indicatorAlignment,
    required this.child,
  }) : assert(
          collapsedVisibilityFactor >= 0 && collapsedVisibilityFactor <= 1,
          'The parameter collapsedHeightFactor must lay between 0 and 1',
        );

  @override
  State<DxExpandWidget> createState() => _DxExpandWidgetState();
}

class _DxExpandWidgetState extends State<DxExpandWidget> with SingleTickerProviderStateMixin {
  /// Custom animation curve for indicator icon control.
  static final _easeInCurve = CurveTween(curve: Curves.easeInOutCubic);

  /// Control the rotation of the indicator icon widget.
  static final _halfTurn = Tween(begin: 0.0, end: 0.5);

  /// General animation controller.
  late AnimationController _controller;

  /// Animations for height/width control.
  late Animation<double> _expandFactor;

  /// Animations for indicator icon's rotation control.
  late Animation<double> _iconTurns;

  /// Auxiliary variable to control expand status.
  var _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Initializing the animation controller with the [duration] parameter
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Initializing both animations, depending on the [_easeInCurve] curve
    _expandFactor = _controller.drive(
      Tween(
        begin: widget.collapsedVisibilityFactor,
        end: 1.0,
      ).chain(_easeInCurve),
    );
    _iconTurns = _controller.drive(_halfTurn.chain(_easeInCurve));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  /// Method called when the user clicks on the expand indicator
  void _handleTap() => setState(() {
        _isExpanded = !_isExpanded;
        _isExpanded ? _controller.forward() : _controller.reverse();
      });

  /// Builds the widget itself. If the [_isExpanded] parameter is 'true',
  /// the [child] parameter will contain the child information, passed to
  /// this instance of the object.
  Widget _buildChild(BuildContext context, Widget? child) {
    return Flex(
      direction: widget.direction,
      children: [
        _DxExpandChildContent(
          value: _controller.value,
          direction: widget.direction,
          heightFactor: widget.direction == Axis.vertical ? _expandFactor.value : null,
          widthFactor: widget.direction == Axis.horizontal ? _expandFactor.value : null,
          child: child,
        ),
        _DxExpandChildIndicator(
          heightIndicatorFactor: widget.hideIndicatorOnExpand ? 1 - _expandFactor.value : 1.0,
          alignment: widget.indicatorAlignment,
          child: widget.indicatorBuilder?.call(context, _handleTap, _isExpanded) ??
              DxExpandIndicator(
                animation: _iconTurns,
                expandIndicatorStyle: widget.indicatorStyle,
                onTap: _handleTap,
                collapsedHint: widget.collapsedHint,
                expandedHint: widget.expandedHint,
                padding: widget.indicatorPadding,
                iconColor: widget.indicatorIconColor,
                iconSize: widget.indicatorIconSize,
                icon: widget.direction == Axis.horizontal ? Icons.chevron_right : widget.indicatorIcon,
                hintTextStyle: widget.indicatorHintTextStyle,
                capitalizeHintText: widget.capitalizeIndicatorHintText,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChild,
      child: widget.child,
    );
  }
}

class _DxExpandChildContent extends StatelessWidget {
  final double value;
  final Axis direction;
  final Widget? child;
  final double? heightFactor;
  final double? widthFactor;

  const _DxExpandChildContent({
    required this.value,
    required this.direction,
    this.child,
    this.heightFactor,
    this.widthFactor,
  });

  Alignment get _childAlignment => direction == Axis.horizontal ? Alignment.centerLeft : Alignment.topCenter;

  Alignment get _beginGradientAlignment => direction == Axis.horizontal ? Alignment.centerLeft : Alignment.topCenter;

  Alignment get _endGradientAlignment => direction == Axis.horizontal ? Alignment.centerRight : Alignment.bottomCenter;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: LinearGradient(
        colors: [Colors.white, Colors.white.withAlpha(0)],
        begin: _beginGradientAlignment,
        end: _endGradientAlignment,
        stops: [value, 1],
      ).createShader,
      child: ClipRect(
        child: Align(
          alignment: _childAlignment,
          heightFactor: heightFactor,
          widthFactor: widthFactor,
          child: child,
        ),
      ),
    );
  }
}

class _DxExpandChildIndicator extends StatelessWidget {
  final double heightIndicatorFactor;
  final Widget child;
  final Alignment? alignment;

  const _DxExpandChildIndicator({
    required this.heightIndicatorFactor,
    required this.child,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: alignment ?? Alignment.center,
        heightFactor: heightIndicatorFactor,
        child: child,
      ),
    );
  }
}
