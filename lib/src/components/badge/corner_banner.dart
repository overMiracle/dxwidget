import 'dart:math' as math;

import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

enum DxRibbonLocation { topLeft, topRight, bottomLeft, bottomRight }

/// 绸带边角角标，可以做成三角形（nearLength设置为0）或者梯形
/// 默认三角形
/// 注意：使用这个组件不需要stack，但是如果子元素有margin可能是失效
class DxRibbonCornerBanner extends StatelessWidget {
  /// 离着顶角最近距离，要小于farLength
  final double nearLength;

  /// 离着顶角最远距离，要大于nearLength
  final double farLength;

  /// 背景颜色
  final Color? bgColor;

  /// 圆角，只有在nearLength==0才有效
  final double borderRadius;

  /// 如果text为null，则不显示
  final String? text;
  final Color textColor;
  final double textSize;
  final TextStyle? textStyle;
  final DxRibbonLocation location;
  final Widget? child;

  const DxRibbonCornerBanner({
    Key? key,
    this.nearLength = 0,
    this.farLength = 40,
    this.bgColor = DxStyle.red,
    this.borderRadius = 0,
    this.text,
    this.textSize = 9,
    this.textColor = Colors.white,
    this.textStyle,
    this.location = DxRibbonLocation.topRight,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == null || text == '') return child ?? const SizedBox.shrink();
    Widget widget = CustomPaint(
      foregroundPainter: _DxRibbonCornerBannerPainter(
        nearLength: nearLength,
        farLength: farLength,
        title: text!,
        titleStyle: textStyle ?? TextStyle(fontSize: textSize, color: textColor),
        bgColor: bgColor!,
        location: location,
      ),
      child: child,
    );
    if (nearLength == 0 && borderRadius != 0) {
      return ClipRRect(borderRadius: _calcBorderRadius(), child: widget);
    }
    return widget;
  }

  BorderRadiusGeometry _calcBorderRadius() {
    switch (location) {
      case DxRibbonLocation.topLeft:
        return BorderRadius.only(topLeft: Radius.circular(borderRadius));
      case DxRibbonLocation.bottomLeft:
        return BorderRadius.only(bottomLeft: Radius.circular(borderRadius));
      case DxRibbonLocation.bottomRight:
        return BorderRadius.only(bottomRight: Radius.circular(borderRadius));
      default:
        return BorderRadius.only(topRight: Radius.circular(borderRadius));
    }
  }
}

class _DxRibbonCornerBannerPainter extends CustomPainter {
  double nearLength;
  double farLength;
  final String title;
  final Color bgColor;
  final TextStyle titleStyle;
  final DxRibbonLocation location;
  bool initialized = false;
  late TextPainter textPainter;
  late Paint paintRibbon;
  late Path pathRibbon;
  late double rotateRibbon;
  late Offset offsetRibbon;
  late Offset offsetTitle;
  late Paint paintShadow;

  static const BoxShadow _shadow = BoxShadow(color: Color(0x7F000000), blurRadius: 6.0);
  _DxRibbonCornerBannerPainter({
    required this.nearLength,
    required this.farLength,
    required this.title,
    required this.titleStyle,
    required this.bgColor,
    required this.location,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (!initialized) _init(size);

    ///     print('cx = ${offsetRibbon.dx},cy = ${offsetRibbon.dy}');
    canvas
      ..drawShadow(pathRibbon, const Color(0x7F000000), 2.0, true)
      ..drawPath(pathRibbon, paintRibbon)
      ..translate(offsetRibbon.dx, offsetRibbon.dy)
      ..rotate(rotateRibbon);
    textPainter.paint(canvas, offsetTitle);
  }

  @override
  bool shouldRepaint(_DxRibbonCornerBannerPainter oldDelegate) {
    return title != oldDelegate.title ||
        nearLength != oldDelegate.nearLength ||
        farLength != oldDelegate.farLength ||
        bgColor != oldDelegate.bgColor ||
        location != oldDelegate.location;
  }

  void _init(Size size) {
    initialized = true;
    if (nearLength > farLength) {
      double temp = farLength;
      farLength = nearLength;
      nearLength = temp;
    }
    if (farLength > size.width) farLength = size.width;
    TextSpan span = TextSpan(style: titleStyle, text: title);
    textPainter = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    textPainter.layout();
    paintRibbon = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    offsetTitle = Offset(-textPainter.width / 2, -textPainter.height / 2);
    rotateRibbon = _rotation;
    pathRibbon = _ribbonPath(size);
    paintShadow = _shadow.toPaint();
  }

  Path _ribbonPath(Size size) {
    Path path = Path();
    List<Offset> vec = [];
    if (size.width <= size.height) {
      switch (location) {
        case DxRibbonLocation.topRight:
          path.moveTo(size.width - nearLength, 0);
          vec.add(Offset(size.width - nearLength, 0));
          path.lineTo(size.width - farLength, 0);
          vec.add(Offset(size.width - farLength, 0));
          path.lineTo(size.width, farLength);
          vec.add(Offset(size.width, farLength));
          path.lineTo(size.width, nearLength);
          vec.add(Offset(size.width, nearLength));
          break;
        case DxRibbonLocation.bottomLeft:
          path.moveTo(0, size.height - nearLength);
          vec.add(Offset(0, size.height - nearLength));
          path.lineTo(0, size.height - farLength);
          vec.add(Offset(0, size.height - farLength));
          path.lineTo(farLength, size.height);
          vec.add(Offset(farLength, size.height));
          path.lineTo(nearLength, size.height);
          vec.add(Offset(nearLength, size.height));
          break;
        case DxRibbonLocation.bottomRight:
          path.moveTo(size.width - nearLength, size.height);
          vec.add(Offset(size.width - nearLength, size.height));
          path.lineTo(size.width - farLength, size.height);
          vec.add(Offset(size.width - farLength, size.height));
          path.lineTo(size.width, size.height - farLength);
          vec.add(Offset(size.width, size.height - farLength));
          path.lineTo(size.width, size.height - nearLength);
          vec.add(Offset(size.width, size.height - nearLength));
          break;
        default:
          path.moveTo(nearLength, 0);
          vec.add(Offset(nearLength, 0));
          path.lineTo(farLength, 0);
          vec.add(Offset(farLength, 0));
          path.lineTo(0, farLength);
          vec.add(Offset(0, farLength));
          path.lineTo(0, nearLength);
          vec.add(Offset(0, nearLength));
      }
    } else {
      switch (location) {
        case DxRibbonLocation.topRight:
          path.moveTo(size.width - nearLength, 0);
          vec.add(Offset(size.width - nearLength, 0));
          path.lineTo(size.width - farLength, 0);
          vec.add(Offset(size.width - farLength, 0));
          if (farLength <= size.height) {
            path.lineTo(size.width, farLength);
            vec.add(Offset(size.width, farLength));
            path.lineTo(size.width, nearLength);
            vec.add(Offset(size.width, nearLength));
          } else {
            path.lineTo(size.width - (farLength - size.height), size.height);
            vec.add(Offset(size.width - (farLength - size.height), size.height));
            if (nearLength <= size.height) {
              path.lineTo(size.width, size.height);
              vec.add(Offset(size.width, size.height));
              path.lineTo(size.width, nearLength);
              vec.add(Offset(size.width, nearLength));
            } else {
              path.lineTo(size.width - (nearLength - size.height), size.height);
              vec.add(Offset(size.width - (nearLength - size.height), size.height));
            }
          }
          break;
        case DxRibbonLocation.bottomLeft:
          path.moveTo(nearLength, size.height);
          vec.add(Offset(nearLength, size.height));
          path.lineTo(farLength, size.height);
          vec.add(Offset(farLength, size.height));
          if (farLength <= size.height) {
            path.lineTo(0, size.height - farLength);
            vec.add(Offset(0, size.height - farLength));
            path.lineTo(0, size.height - nearLength);
            vec.add(Offset(0, size.height - nearLength));
          } else {
            path.lineTo(farLength - size.height, 0);
            vec.add(Offset(farLength - size.height, 0));
            if (nearLength <= size.height) {
              path.lineTo(0, 0);
              vec.add(const Offset(0, 0));
              path.lineTo(0, size.height - nearLength);
              vec.add(Offset(0, size.height - nearLength));
            } else {
              path.lineTo(nearLength - size.height, 0);
              vec.add(Offset(nearLength - size.height, 0));
            }
          }
          break;
        case DxRibbonLocation.bottomRight:
          path.moveTo(size.width - nearLength, size.height);
          vec.add(Offset(size.width - nearLength, size.height));
          path.lineTo(size.width - farLength, size.height);
          vec.add(Offset(size.width - farLength, size.height));
          if (farLength <= size.height) {
            path.lineTo(size.width, size.height - farLength);
            vec.add(Offset(size.width, size.height - farLength));
            path.lineTo(size.width, size.height - nearLength);
            vec.add(Offset(size.width, size.height - nearLength));
          } else {
            path.lineTo(size.width - (farLength - size.height), 0);
            vec.add(Offset(size.width - (farLength - size.height), 0));
            if (nearLength <= size.height) {
              path.lineTo(size.width, 0);
              vec.add(Offset(size.width, 0));
              path.lineTo(size.width, size.height - nearLength);
              vec.add(Offset(size.width, size.height - nearLength));
            } else {
              path.lineTo(size.width - (nearLength - size.height), 0);
              vec.add(Offset(size.width - (nearLength - size.height), 0));
            }
          }
          break;
        default:
          path.moveTo(nearLength, 0);
          vec.add(Offset(nearLength, 0));
          path.lineTo(farLength, 0);
          vec.add(Offset(farLength, 0));
          if (farLength <= size.height) {
            path.lineTo(0, farLength);
            vec.add(Offset(0, farLength));
            path.lineTo(0, nearLength);
            vec.add(Offset(0, nearLength));
          } else {
            path.lineTo(farLength - size.height, size.height);
            vec.add(Offset(farLength - size.height, size.height));
            if (nearLength <= size.height) {
              path.lineTo(0, size.height);
              vec.add(Offset(0, size.height));
              path.lineTo(0, nearLength);
              vec.add(Offset(0, nearLength));
            } else {
              path.lineTo(nearLength - size.height, size.height);
              vec.add(Offset(nearLength - size.height, size.height));
            }
          }
      }
    }
    path.close();
    List<Offset> vec2 = vec.toSet().toList();
    offsetRibbon = _center(vec2);
    return path;
  }

  double get _rotation {
    switch (location) {
      case DxRibbonLocation.topLeft:
        return -math.pi / 4;
      case DxRibbonLocation.topRight:
        return math.pi / 4;
      case DxRibbonLocation.bottomLeft:
        return math.pi / 4;
      case DxRibbonLocation.bottomRight:
        return -math.pi / 4;
      default:
        return 0;
    }
  }

  Offset _center(List<Offset> offsets) {
    double sumX = 0, sumY = 0, sumS = 0;
    double x1 = offsets[0].dx;
    double y1 = offsets[0].dy;
    double x2 = offsets[1].dx;
    double y2 = offsets[1].dy;
    double x3, y3;
    for (int i = 2; i < offsets.length; i++) {
      x3 = offsets[i].dx;
      y3 = offsets[i].dy;
      double s = ((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)) / 2.0;
      sumX += (x1 + x2 + x3) * s;
      sumY += (y1 + y2 + y3) * s;
      sumS += s;
      x2 = x3;
      y2 = y3;
    }
    double cx = sumX / sumS / 3.0;
    double cy = sumY / sumS / 3.0;
    return Offset(cx, cy);
  }
}
