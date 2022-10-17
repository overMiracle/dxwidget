import 'package:flutter/widgets.dart';

import 'controller.dart';
import 'dismissible_pane_motions.dart';
import 'slidable.dart';

const double _kDismissThreshold = 0.75;
const Duration _kDismissalDuration = Duration(milliseconds: 300);
const Duration _kResizeDuration = Duration(milliseconds: 300);

/// Signature used by [DxDismissiblePane] to give the application an opportunity
/// to confirm or veto a dismiss gesture.
///
/// Used by [DxDismissiblePane.confirmDismiss].
typedef ConfirmDismissCallback = Future<bool> Function();

/// A widget which controls how a [DxSlidable] dismisses.
class DxDismissiblePane extends StatefulWidget {
  /// Creates a [DxDismissiblePane].
  ///
  /// The [onDismissed], [dismissThreshold], [dismissalDuration],
  /// [resizeDuration], [closeOnCancel], and [motion] arguments must not be
  /// null.
  ///
  /// The [dismissThreshold] must be between 0 and 1 (both exclusives).
  ///
  /// You must set the key of the enclosing [DxSlidable] to use this widget.
  const DxDismissiblePane({
    Key? key,
    required this.onDismissed,
    this.dismissThreshold = _kDismissThreshold,
    this.dismissalDuration = _kDismissalDuration,
    this.resizeDuration = _kResizeDuration,
    this.confirmDismiss,
    this.closeOnCancel = false,
    this.motion = const DxInverseDrawerMotion(),
  })  : assert(dismissThreshold > 0 && dismissThreshold < 1),
        super(key: key);

  /// The threshold from which a dismiss will be triggered if the user stops
  /// to drag the [DxSlidable].
  ///
  /// This value must be between 0 and 1 (both exclusives.)
  ///
  /// Defaults to 0.75.
  final double dismissThreshold;

  /// The amount of simple the widget will spend to complete the dismiss
  /// animation.
  ///
  /// Defaults to 300ms.
  final Duration dismissalDuration;

  /// The amount of simple the widget will spend contracting before [onDismissed]
  /// is called.
  ///
  /// If null, the widget will not contract and [onDismissed] will be called
  /// immediately after the widget is dismissed.
  final Duration resizeDuration;

  /// Gives the app an opportunity to confirm or veto a pending dismissal.
  ///
  /// If the returned Future<bool> completes true, then this widget will be
  /// dismissed, otherwise it will be moved back to its original location.
  ///
  /// If the returned Future<bool> completes to false or null the [onDismissed]
  /// callback will not run.
  final ConfirmDismissCallback? confirmDismiss;

  /// Called when the widget has been dismissed, after finishing resizing.
  final VoidCallback onDismissed;

  /// Whether closing the [DxSlidable] if the app cancels the dismiss.
  final bool closeOnCancel;

  /// The widget which animates while the [DxSlidable] is currently dismissing.
  final Widget motion;

  @override
  State<DxDismissiblePane> createState() => _DxDismissiblePaneState();
}

class _DxDismissiblePaneState extends State<DxDismissiblePane> {
  SlidableController? controller;

  @override
  void initState() {
    super.initState();
    assert(() {
      final slidable = context.findAncestorWidgetOfExactType<DxSlidable>()!;
      if (slidable.key == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('DxDismissiblePane created on a DxSlidable without a Key.'),
          ErrorDescription(
            'The closest DxSlidable of DxDismissiblePane has been created without '
            'a Key.\n'
            'The key argument must not be null because Slides are '
            'commonly used in lists and removed from the list when '
            'dismissed. Without keys, the default behavior is to sync '
            'widgets based on their index in the list, which means the item '
            'after the dismissed item would be synced with the state of the '
            'dismissed item. Using keys causes the widgets to sync according '
            'to their keys and avoids this pitfall.',
          ),
          ErrorHint(
            'To avoid this problem, set the key of the enclosing DxSlidable '
            'widget.',
          ),
        ]);
      }
      return true;
    }());
    controller = DxSlidable.of(context);
    controller!.dismissGesture.addListener(handleDismissGestureChanged);
  }

  @override
  void dispose() {
    controller!.dismissGesture.removeListener(handleDismissGestureChanged);
    super.dispose();
  }

  Future<void> handleDismissGestureChanged() async {
    final endGesture = controller!.dismissGesture.value!.endGesture;
    final position = controller!.animation.value;

    if (endGesture is OpeningGesture || endGesture is StillGesture && position >= widget.dismissThreshold) {
      bool canDismiss = true;
      if (widget.confirmDismiss != null) {
        canDismiss = await widget.confirmDismiss!();
      }
      if (canDismiss) {
        controller!.dismiss(
          ResizeRequest(widget.resizeDuration, widget.onDismissed),
          duration: widget.dismissalDuration,
        );
      } else if (widget.closeOnCancel) {
        controller!.close();
      }
      return;
    }

    controller!.openCurrentActionPane();
  }

  @override
  Widget build(BuildContext context) => widget.motion;
}
