import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 动画曲线构造器
typedef DxCurveBuilder = Curve Function(bool show);

/// 默认动画曲线构造器
Curve kDxCurveBuilder(bool show) => show ? DxStyle.animationTimingFunctionEnter : DxStyle.animationTimingFunctionLeave;

/// 过渡动画构造器
typedef DxTransitionBuilder = Widget Function(BuildContext context, Animation<double> animation, Widget child);

/// 过渡动画`Fade` 构造器
Widget kDxFadeTransitionBuilder(BuildContext context, Animation<double> animation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

/// 过渡动画`Slide Up` 构造器
Widget kDxSlideUpTransitionBuilder(BuildContext context, Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// 过渡动画`Slide Down` 构造器
Widget kDxSlideDownTransitionBuilder(BuildContext context, Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// 过渡动画`Slide Left` 构造器
Widget kDxSlideLeftTransitionBuilder(BuildContext context, Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// 过渡动画`Slide Right` 构造器
Widget kDxSlideRightTransitionBuilder(BuildContext context, Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// ### 过渡动画
///
/// - `curveBuilder` 动画曲线构造器,通过`show` 判断是进场动画还是离场动画
/// - `transitionBuilder` 过渡动画构造器
/// - 通过类型`Visibility`的子组件`child`的`visible` 控制展示和隐藏
class DxTransitionVisible extends StatefulWidget {
  const DxTransitionVisible({
    Key? key,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
    this.onCompleted,
    this.onDismissed,
    required this.transitionBuilder,
    this.replacement = const SizedBox.shrink(),
    this.animation,
    this.appear = false,
    this.visible = true,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    required this.child,
  }) : super(key: key);

  /// 过渡动画`Fade`
  const DxTransitionVisible.fade({
    Key? key,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kDxFadeTransitionBuilder,
    this.replacement = const SizedBox.shrink(),
    this.animation,
    this.appear = false,
    this.visible = true,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    required this.child,
  }) : super(key: key);

  /// 过渡动画`Slide Down`
  const DxTransitionVisible.slideDown({
    Key? key,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kDxSlideDownTransitionBuilder,
    this.replacement = const SizedBox.shrink(),
    this.animation,
    this.appear = false,
    this.visible = true,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    required this.child,
  }) : super(key: key);

  /// 过渡动画`Slide Up`
  const DxTransitionVisible.slideUp({
    Key? key,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kDxSlideUpTransitionBuilder,
    this.replacement = const SizedBox.shrink(),
    this.animation,
    this.appear = false,
    this.visible = true,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    required this.child,
  }) : super(key: key);

  /// 过渡动画`Slide Left`
  const DxTransitionVisible.slideLeft({
    Key? key,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kDxSlideLeftTransitionBuilder,
    this.appear = false,
    this.replacement = const SizedBox.shrink(),
    this.animation,
    this.visible = true,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    required this.child,
  }) : super(key: key);

  /// 过渡动画`Slide Right`
  const DxTransitionVisible.slideRight({
    Key? key,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kDxSlideRightTransitionBuilder,
    this.replacement = const SizedBox.shrink(),
    this.animation,
    this.appear = false,
    this.visible = true,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    required this.child,
  }) : super(key: key);

  /// 动画时间 in
  final Duration? duration;

  /// 动画时间 out
  final Duration? reverseDuration;

  /// 动画曲线 in
  final Curve? curve;

  /// 动画曲线 out
  final Curve? reverseCurve;

  final VoidCallback? onCompleted;

  final VoidCallback? onDismissed;

  /// 过渡动画构造器
  final DxTransitionBuilder transitionBuilder;

  final bool appear;
  final Animation<double>? animation;
  final Widget replacement;
  final bool visible;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;

  /// 子组件
  final Widget child;

  @override
  State<DxTransitionVisible> createState() => _DxTransitionVisibleState();
}

class _DxTransitionVisibleState extends State<DxTransitionVisible> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  late Animation<double> animation;

  late bool _visible;

  @override
  void initState() {
    _visible = widget.visible;
    if (widget.animation != null) {
      animation = widget.animation!;
    } else {
      List<double> initValue = _visible ? <double>[1.0, 0.0] : <double>[0.0, 1.0];
      if (widget.appear) {
        initValue = initValue.reversed.toList();
      }
      animationController = AnimationController(
        vsync: this,
        value: initValue[0],
        duration: widget.duration ?? DxStyle.animationDuration200,
        reverseDuration: widget.reverseDuration ?? widget.duration,
      )..addStatusListener(_transitionStatusChange);

      animation = CurvedAnimation(
        parent: animationController!,
        curve: widget.curve ?? DxStyle.animationTimingFunctionEnter,
        reverseCurve: widget.reverseCurve ?? DxStyle.animationTimingFunctionLeave,
      );
    }

    if (widget.appear) {
      if (_visible) {
        animationController?.forward();
      } else {
        animationController?.reverse();
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    animationController
      ?..removeStatusListener(_transitionStatusChange)
      ..dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DxTransitionVisible oldWidget) {
    if (widget.duration != oldWidget.duration) {
      animationController?.duration = widget.duration;
    }
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        setState(() {
          _visible = true;
          animationController?.forward();
        });
      } else {
        animationController?.reverse();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return widget.transitionBuilder(context, animation, child!);
      },
      child: Visibility(
        replacement: widget.replacement,
        visible: _visible,
        maintainState: widget.maintainState,
        maintainAnimation: widget.maintainAnimation,
        maintainSize: widget.maintainSize,
        maintainSemantics: widget.maintainSemantics,
        maintainInteractivity: widget.maintainInteractivity,
        child: widget.child,
      ),
    );
  }

  void _transitionStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      widget.onDismissed?.call();

      setState(() {
        _visible = false;
      });
    } else if (status == AnimationStatus.completed) {
      widget.onCompleted?.call();
    }
  }
}
