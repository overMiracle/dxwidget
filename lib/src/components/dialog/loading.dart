import 'dart:math' as math;

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 类型
enum DxLoadingType { circular, spinner }

/// 加载图标，用于表示加载中的过渡状态。
/// 这里认为loading也是一个弹窗组件
//ignore: must_be_immutable
class DxLoading extends StatelessWidget {
  /// 颜色
  final Color? color;

  /// 类型，可选值为 `spinner`
  final DxLoadingType type;

  /// 加载图标粗细
  final double? strokeWidth;

  /// 加载图标大小
  final double? size;

  /// 是否垂直排列图标和文字内容
  final bool vertical;

  /// 文字与图标之间的距离
  final double margin;

  /// 加载文案
  final Widget? child;

  /// 主题
  DxLoadingThemeData? themeData;

  DxLoading({
    Key? key,
    this.type = DxLoadingType.spinner,
    this.vertical = false,
    this.color,
    this.strokeWidth,
    this.size,
    this.margin = 10,
    this.child,
    this.themeData,
  }) : super(key: key) {
    themeData = DxLoadingThemeData().merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    final Widget icon = RepaintBoundary(
      child: SizedBox(
        width: size ?? themeData?.spinnerSize,
        height: size ?? themeData?.spinnerSize,
        child: type == DxLoadingType.spinner
            ? _DxLoadingSpinner(
                color: color ?? themeData!.spinnerColor,
                strokeWidth: strokeWidth,
                duration: themeData!.spinnerAnimationDuration,
              )
            : _DxLoadingCircle(color: color ?? themeData?.spinnerColor, strokeWidth: strokeWidth),
      ),
    );

    if (vertical) {
      return Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[icon, buildText(themeData!)],
      );
    }

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[icon, buildText(themeData!)],
    );
  }

  Widget buildText(DxLoadingThemeData themeData) {
    if (child != null) {
      return Padding(
        padding: EdgeInsets.only(left: vertical ? 0.0 : margin, top: vertical ? margin : 0.0),
        child: child!,
      );
    }

    return const SizedBox.shrink();
  }
}

class _DxLoadingCircle extends StatefulWidget {
  const _DxLoadingCircle({
    Key? key,
    this.color,
    this.strokeWidth,
  }) : super(key: key);

  final double? strokeWidth;
  final Color? color;

  @override
  State<_DxLoadingCircle> createState() => _DxLoadingCircleState();
}

class _DxLoadingCircleState extends State<_DxLoadingCircle> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> lengthAnimation;
  late Animation<double> offsetAnimation;

  @override
  void initState() {
    controller = AnimationController(
      value: 0.0,
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    final CurvedAnimation curveAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    lengthAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 90.0),
        weight: .5,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 90.0, end: 90.0),
        weight: .5,
      ),
    ]).animate(curveAnimation);

    offsetAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: -40.0),
        weight: .5,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -40.0, end: -120.0),
        weight: .5,
      ),
    ]).animate(curveAnimation);

    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DxLoadingThemeData themeData = DxLoadingTheme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: _DxLoadingCirclePainter(
            length: lengthAnimation.value,
            offset: offsetAnimation.value,
            color: widget.color ?? themeData.spinnerColor,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}

class _DxLoadingCirclePainter extends CustomPainter {
  _DxLoadingCirclePainter({
    this.strokeWidth,
    required this.color,
    required this.length,
    required this.offset,
  })  : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth ?? 2.0
          ..strokeCap = StrokeCap.round,
        super();

  final double? strokeWidth;
  final double length;
  final double offset;
  final Color color;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    const double r = 20.0;
    final double num1 = length / r;
    final double num3 = offset / r;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 - 2.0,
      ),
      -num3,
      (-num3 + num1 > 2 * math.pi) ? 2 * math.pi + num3 : num1,
      false,
      _paint,
    );
  }

  @override
  bool shouldRepaint(_DxLoadingCirclePainter oldDelegate) =>
      length != oldDelegate.length || offset != oldDelegate.offset;

  @override
  bool shouldRebuildSemantics(_DxLoadingCirclePainter oldDelegate) => false;
}

class _DxLoadingSpinner extends StatefulWidget {
  const _DxLoadingSpinner({
    Key? key,
    this.strokeWidth,
    required this.color,
    required this.duration,
  }) : super(key: key);

  final double? strokeWidth;
  final Color color;
  final Duration duration;

  @override
  State<_DxLoadingSpinner> createState() => __DxLoadingSpinnerState();
}

class __DxLoadingSpinnerState extends State<_DxLoadingSpinner> with TickerProviderStateMixin {
  late Animation<int> animation;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      value: 0.0,
      duration: widget.duration,
      vsync: this,
    );

    animation = IntTween(begin: 0, end: 11).animate(controller);

    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final Matrix4 transform = Matrix4.rotationZ(animation.value * math.pi / 6);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: CustomPaint(
        size: const Size.square(30.0),
        painter: _DxLoadingSpinnerPainter(color: widget.color, strokeWidth: widget.strokeWidth),
      ),
    );
  }
}

class _DxLoadingSpinnerPainter extends CustomPainter {
  _DxLoadingSpinnerPainter({
    required this.color,
    this.strokeWidth,
  })  : _paint = Paint()
          ..strokeWidth = strokeWidth ?? 2.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        super();

  final double? strokeWidth;
  final Color color;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final double canvasWidth = size.width;
    final double canvasHeight = size.height;
    canvas.translate(canvasWidth / 2, canvasHeight / 2);
    for (int i = 0; i < 12; i++) {
      _paint.color = color.withOpacity(1 - 0.75 / 12 * i);
      canvas
        ..rotate(math.pi / 6)
        ..drawLine(
          Offset(0, canvasHeight * .28),
          Offset(0, canvasHeight * .5),
          _paint,
        );
    }
  }

  @override
  bool shouldRepaint(_DxLoadingSpinnerPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_DxLoadingSpinnerPainter oldDelegate) => false;
}
