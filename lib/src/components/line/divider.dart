import 'dart:ui';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 分割线内容位置
enum DxDividerContentPosition { left, center, right }

/// 分割线
class DxDivider extends StatelessWidget {
  /// 是否使用虚线
  final bool dashed;

  /// 是否使用 0.5px 线
  final bool hairline;

  /// 内容位置，可选值为 `left` `right`
  final DxDividerContentPosition contentPosition;

  /// 分割线样式
  final DxDividerStyle? style;

  /// 内容
  final Widget? child;

  const DxDivider({
    Key? key,
    this.dashed = false,
    this.hairline = true,
    this.contentPosition = DxDividerContentPosition.center,
    this.child,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxDividerThemeData themeData = DxDividerTheme.of(context);

    return Container(
      margin: themeData.margin,
      padding: style?.padding ?? EdgeInsets.zero,
      child: DefaultTextStyle(
        style: TextStyle(
          color: style?.color ?? themeData.textColor,
          fontSize: themeData.fontSize,
          height: themeData.lineHeight,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildLine(themeData, constraints, position: DxDividerContentPosition.left),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: child != null ? themeData.contentPadding : 0.0),
                  child: child ?? const SizedBox.shrink(),
                ),
                _buildLine(
                  themeData,
                  constraints,
                  position: DxDividerContentPosition.right,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 构建线条
  Widget _buildLine(
    DxDividerThemeData themeData,
    BoxConstraints constraints, {
    required DxDividerContentPosition position,
  }) {
    final CustomPaint line = CustomPaint(
      painter: _DividerPainter(
        dashed: dashed,
        color: style?.borderColor ?? themeData.borderColor,
        strokeWidth: DxStyle.borderWidthBase * (hairline ? 0.5 : 1.0),
      ),
    );

    if (contentPosition != position) return Expanded(child: line);

    return SizedBox(
      width: constraints.maxWidth *
          (position == DxDividerContentPosition.left
              ? themeData.contentLeftWidthPercent
              : themeData.contentRightWidthPercent),
      child: line,
    );
  }
}

/// 分割线绘制工具类
class _DividerPainter extends CustomPainter {
  _DividerPainter({
    this.dashed = false,
    required this.color,
    this.strokeWidth = 1.0,
  })  : _paint = Paint()
          ..color = color
          ..strokeWidth = strokeWidth,
        super();

  /// 虚线样式
  final bool dashed;

  /// 线条颜色
  final Color color;

  /// 线条宽度
  final double strokeWidth;

  /// 分割线的画笔
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final double y = size.height * 0.5;
    if (!dashed) {
      canvas.drawLine(Offset(0.0, y), Offset(size.width, y), _paint);
      return;
    }

    const double dashWith = 3.0;
    final List<Offset> list = List<Offset>.filled((size.width / dashWith).floor(), Offset.zero)
        .asMap()
        .keys
        .map((int i) => Offset(i * dashWith, y))
        .toList();
    canvas.drawPoints(PointMode.lines, list, _paint);
  }

  @override
  bool shouldRepaint(_DividerPainter oldDelegate) =>
      dashed != oldDelegate.dashed || color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}

/// 分割线样式
class DxDividerStyle {
  final Color? color;
  final Color? borderColor;
  final EdgeInsets? padding;

  const DxDividerStyle({
    this.color,
    this.borderColor,
    this.padding,
  }) : super();
}
