import 'package:flutter/widgets.dart';

import 'action_pane.dart';
import 'flex_exit_transition.dart';
import 'slidable.dart';

/// A [DxDismissiblePane] motion which will make the furthest action grows faster
/// as the [DxSlidable] dismisses.
class DxInverseDrawerMotion extends StatelessWidget {
  /// Creates a [InverseDrawerMotion].
  const DxInverseDrawerMotion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paneData = DxActionPane.of(context)!;
    final controller = DxSlidable.of(context)!;
    final animation = controller.animation.drive(CurveTween(curve: Interval(paneData.extentRatio, 1)));

    return FlexExitTransition(
      mainAxisExtent: animation,
      initialExtentRatio: paneData.extentRatio,
      direction: paneData.direction,
      startToEnd: paneData.fromStart,
      children: paneData.children,
    );
  }
}
