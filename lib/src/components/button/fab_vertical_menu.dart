import 'package:flutter/material.dart';

/// 弹出垂直菜单的悬浮响应按钮组件
class DxVerticalMenuFab extends StatefulWidget {
  /// list of Floating Action Buttons.
  final List<Widget> child;

  final AnimatedIconData animatedIconData;
  final int durationAnimation;
  final Color startColor;
  final Color endColor;
  final Curve curve;
  final double spaceBetween;

  /// The [fabButtons] and [animatedIconData] arguments must not be null.
  /// The [durationAnimation], [colorStartAnimation], [colorEndAnimation],
  /// [curve] and [spaceBetween] default to the value given by the library
  /// but also the should not be null.
  const DxVerticalMenuFab({
    Key? key,
    required this.child,
    required this.animatedIconData,
    this.durationAnimation = 500,
    this.startColor = Colors.blue,
    this.endColor = Colors.red,
    this.curve = Curves.easeOut,
    this.spaceBetween = -6.0,
  })  : assert(
          durationAnimation > 150 && durationAnimation < 1250,
          'The duration of the animation should be greater than 150 and smaller than 12500.',
        ),
        assert(
          child.length > 0,
          'The number of FABs should be more than 1 FAB.',
        ),
        assert(
          spaceBetween <= -5,
          'This is a space between the FABs when they are expanded, '
          'and the value should be lower than or '
          'equal to -5 to have a reasonable space between them.',
        ),
        super(key: key);

  @override
  State<DxVerticalMenuFab> createState() => _DxVerticalMenuFabState();
}

class _DxVerticalMenuFabState extends State<DxVerticalMenuFab> with SingleTickerProviderStateMixin {
  /// AnimationController object to control over the whole animation.
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final double _fabHeight = 56.0;
  bool _isOpened = false;

  bool get isOpened => _isOpened;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.durationAnimation,
      ),
    )..addListener(
        () {
          /// We here changing the state of the widget
          /// upon any changes from animation controller.
          setState(() {});
        },
      );

    /// This Tween is to animate the icon of the main FAB.
    _animateIcon = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      _animationController,
    );

    /// This ColorTween is to animate the background Color of main FAB.
    _buttonColor = ColorTween(
      begin: widget.startColor,
      end: widget.endColor,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.00, 1.00, curve: Curves.linear),
      ),
    );

    /// This Tween is to animate position of the current fab
    /// according to its position in the list.
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: widget.spaceBetween,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          0.75,
          curve: widget.curve,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _buildFABs(),
    );
  }

  Widget _buildMainFAB() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: _animateFABs,
      child: AnimatedIcon(
        icon: widget.animatedIconData,
        progress: _animateIcon,
      ),
    );
  }

  List<Widget> _buildFABs() {
    List<Widget> processButtons = [];
    for (int i = 0; i < widget.child.length; i++) {
      processButtons.add(
        Opacity(
          opacity: _animateIcon.value,
          child: _TransformFloatActionButton(
            floatButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.child[i],
              ],
            ),
            translateValue: _translateButton.value * (widget.child.length - i),
          ),
        ),
      );
    }
    processButtons.add(_buildMainFAB());
    return processButtons;
  }

  void _animateFABs() {
    _isOpened ? _animationController.reverse() : _animationController.forward();
    _isOpened = !_isOpened;
  }

  /// This method is visible from outside of this state widget throw
  /// GlobalKey<AnimatedFloatingActionButtonState>() object which is created
  /// and assign as a key object to [AnimatedFloatingActionButton] by user
  /// to close the [fabButtons] list.
  void closeFABs() {
    _animateFABs();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

///
/// An animated widget to move the FAB from base position to its end position
/// according to its position in the list and
/// the changed value from animation controller
/// [floatButton] the current FAB and [translateValue] is a double value.
/// and we do the transformation on the OY axis.
class _TransformFloatActionButton extends StatelessWidget {
  final Widget floatButton;
  final double translateValue;

  _TransformFloatActionButton({
    required this.floatButton,
    required this.translateValue,
  }) : super(
          key: ObjectKey(floatButton),
        );

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        translateValue,
        0.0,
      ),
      child: floatButton,
    );
  }
}
