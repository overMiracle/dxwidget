import 'package:flutter/widgets.dart';

import 'action_pane.dart';
import 'flex_entrance_transition.dart';
import 'slidable.dart';

/// An [DxActionPane] motion which reveals actions as if they were behind the
/// [DxSlidable].
///
class DxBehindMotion extends StatelessWidget {
  /// Creates a [BehindMotion].
  ///
  /// {@animation 664 200 https://raw.githubusercontent.com/letsar/flutter_slidable/assets/behind_motion.mp4}
  const DxBehindMotion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paneData = DxActionPane.of(context)!;
    return Flex(
      direction: paneData.direction,
      children: paneData.children,
    );
  }
}

/// An [DxActionPane] motion which reveals actions by stretching their extent
/// while sliding the [DxSlidable].
class DxStretchMotion extends StatelessWidget {
  /// Creates a [StretchMotion].
  ///
  /// {@animation 664 200 https://raw.githubusercontent.com/letsar/flutter_slidable/assets/stretch_motion.mp4}
  const DxStretchMotion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paneData = DxActionPane.of(context);
    final controller = DxSlidable.of(context)!;

    return AnimatedBuilder(
      animation: controller.animation,
      builder: (BuildContext context, Widget? child) {
        final value = controller.animation.value / paneData!.extentRatio;

        return FractionallySizedBox(
          alignment: paneData.alignment,
          widthFactor: paneData.direction == Axis.horizontal ? value : 1,
          heightFactor: paneData.direction == Axis.horizontal ? 1 : value,
          child: child,
        );
      },
      child: const DxBehindMotion(),
    );
  }
}

/// An [DxActionPane] motion which reveals actions as if they were scrolling
/// from the outside.
class DxScrollMotion extends StatelessWidget {
  /// Creates a [ScrollMotion].
  ///
  /// {@animation 664 200 https://raw.githubusercontent.com/letsar/flutter_slidable/assets/scroll_motion.mp4}
  const DxScrollMotion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paneData = DxActionPane.of(context)!;
    final controller = DxSlidable.of(context)!;

    // Each child starts just outside of the DxSlidable.
    final startOffset = Offset(paneData.alignment.x, paneData.alignment.y);

    final animation = controller.animation
        .drive(CurveTween(curve: Interval(0, paneData.extentRatio)))
        .drive(Tween(begin: startOffset, end: Offset.zero));

    return SlideTransition(
      position: animation,
      child: const DxBehindMotion(),
    );
  }
}

/// An [DxActionPane] motion which reveals actions as if they were drawers.
class DxDrawerMotion extends StatelessWidget {
  /// Creates a [DrawerMotion].
  ///
  /// {@animation 664 200 https://raw.githubusercontent.com/letsar/flutter_slidable/assets/drawer_motion.mp4}
  const DxDrawerMotion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paneData = DxActionPane.of(context)!;
    final controller = DxSlidable.of(context)!;
    final animation = controller.animation.drive(CurveTween(curve: Interval(0, paneData.extentRatio)));

    return FlexEntranceTransition(
      mainAxisPosition: animation,
      direction: paneData.direction,
      startToEnd: paneData.fromStart,
      children: paneData.children,
    );
  }
}
