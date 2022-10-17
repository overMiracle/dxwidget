import 'dart:math' as math;
import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 格式化百分比
double _formatRate(double rate) => math.min(math.max(rate, 0), 100);

/// 环形进度条
/// 圆环形的进度条组件，支持进度渐变动画。
class DxCircleProgressBar extends StatefulWidget {
  /// 当前进度
  final double currentRate;

  /// 目标进度
  final double rate;

  /// 圆环直径
  final double? size;

  /// 进度条颜色
  final Color? color;

  /// 进度条颜色，传入对象格式可以定义渐变色
  final Gradient? gradient;

  /// final Color layerColor;
  final Color? layerColor;

  ///填充颜色
  final Color? fill;

  /// 动画速度（单位为 rate/s）
  final double speed;

  /// 文字
  final String? text;

  /// 进度条宽度
  final double? strokeWidth;

  /// 进度条端点的形状，可选值为 `square` `butt` `round`
  final StrokeCap strokeLineCap;

  /// 是否顺时针增加
  final bool clockwise;

  final Widget? child;

  /// 改变事件
  final ValueChanged<double>? onChange;

  const DxCircleProgressBar({
    Key? key,
    this.currentRate = 0.0,
    this.rate = 100.0,
    this.size,
    this.color,
    this.gradient,
    this.layerColor,
    this.fill,
    this.speed = 0.0,
    this.text,
    this.strokeWidth,
    this.strokeLineCap = StrokeCap.round,
    this.clockwise = true,
    this.onChange,
    this.child,
  })  : assert(currentRate >= 0.0 && currentRate <= 100.0),
        assert(rate >= 0.0 && rate <= 100.0),
        assert(speed >= 0.0),
        super(key: key);

  @override
  State<DxCircleProgressBar> createState() => _DxCircleProgressBarState();
}

class _DxCircleProgressBarState extends State<DxCircleProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DxCircleProgressBar oldWidget) {
    if (widget.rate != oldWidget.rate) {
      _watchRate(widget.rate, oldWidget.rate);
    }
    super.didUpdateWidget(oldWidget);
  }

  /// 监听进度条的进度变化
  void _watchRate(double rate, double oldRate) {
    final double startRate = widget.currentRate;
    final double endRate = _formatRate(rate);
    final double duration = (((startRate - endRate) * 1000) / widget.speed).abs();

    void animate() {
      final double rate = lerpDouble(0, endRate - startRate, _animationController.value)! + startRate;

      widget.onChange?.call(_formatRate(rate).roundToDouble());

      if (endRate > startRate ? rate >= endRate : rate <= endRate) {
        _animationController.removeListener(animate);
      }
    }

    if (widget.speed > 0.0) {
      _animationController
        ..stop()
        ..reset();

      _animationController
        ..duration = Duration(milliseconds: duration.round())
        ..addListener(animate)
        ..forward();
    } else {
      widget.onChange?.call(endRate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DxCircleThemeData themeData = DxCircleTheme.of(context);
    final double $strokeWidth = widget.strokeWidth ?? 4.0;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: CustomPaint(
            key: const ValueKey<String>('layer'),
            painter: _DxDividerCirclePainter(
              rate: 100.0,
              color: widget.layerColor ?? themeData.layerColor,
              strokeWidth: $strokeWidth,
              strokeLineCap: widget.strokeLineCap,
              fill: widget.fill,
            ),
          ),
        ),
        CustomPaint(
          key: const ValueKey<String>('hover'),
          painter: _DxDividerCirclePainter(
            rate: widget.currentRate,
            color: widget.color ?? themeData.color,
            gradient: widget.gradient,
            strokeWidth: $strokeWidth,
            strokeLineCap: widget.strokeLineCap,
            clockwise: widget.clockwise,
          ),
          child: Container(
            width: widget.size ?? themeData.size,
            height: widget.size ?? themeData.size,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: DxStyle.paddingBase),
            child: DefaultTextStyle(
              style: TextStyle(
                fontWeight: themeData.textFontWeight,
                fontSize: themeData.textFontSize,
                height: themeData.textLineHeight,
                color: themeData.textColor,
              ),
              child: widget.child ?? Text(widget.text ?? '${widget.currentRate}%'),
            ),
          ),
        ),
      ],
    );
  }
}

/// 环形进度条绘制工具类
class _DxDividerCirclePainter extends CustomPainter {
  _DxDividerCirclePainter({
    required this.rate,
    this.color = Colors.blue,
    this.gradient,
    this.fill,
    required this.strokeWidth,
    this.clockwise = true,
    this.strokeLineCap = StrokeCap.round,
  })  : assert(rate >= 0.0 && rate <= 100.0),
        assert(strokeWidth > 0.0),
        // ignore: unnecessary_type_check
        assert(strokeLineCap is StrokeCap),
        _paint = Paint()
          ..strokeWidth = strokeWidth
          ..strokeCap = strokeLineCap
          ..style = PaintingStyle.stroke,
        super();

  /// 进度条的进度
  final double rate;

  /// 进度条的颜色
  final Color color;

  /// 进度条的颜色(渐变色)
  final Gradient? gradient;

  /// 进度条的粗细
  final double strokeWidth;

  /// 进度条的背景色
  final Color? fill;

  /// 是否是顺时针
  final bool clockwise;

  /// 进度条的边界样式
  final StrokeCap strokeLineCap;

  /// 进度条的画笔
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      radius: size.width * .5,
      center: Offset(size.width * .5, size.height * .5),
    );
    // draw fill
    if (fill != null) {
      canvas.drawArc(
        rect,
        0,
        2 * math.pi,
        false,
        _paint
          ..style = PaintingStyle.fill
          ..color = fill!,
      );
    }
    // draw line
    if (gradient != null) {
      _paint.shader = gradient!.createShader(rect);
    }

    _paint.color = color;

    canvas.drawArc(
      rect,
      math.pi * -0.5,
      math.pi * 2 * rate / 100 * (clockwise ? 1 : -1),
      false,
      _paint..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_DxDividerCirclePainter oldDelegate) =>
      rate != oldDelegate.rate ||
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      fill != oldDelegate.fill ||
      clockwise != oldDelegate.clockwise ||
      strokeLineCap != oldDelegate.strokeLineCap;
}
