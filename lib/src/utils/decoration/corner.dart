import 'dart:math' as math;

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 圆角装饰,可以使用nearDistance绘制梯形
/// github地址：https://github.com/kalaganov/corner_decoration
class DxCornerDecoration extends Decoration {
  final DxBadgeGeometry _geometry;
  final Color _color;
  final Gradient? _gradient;
  final TextSpan? _textSpan;
  final String _text;
  final double _textSize;
  final Color _textColor;
  final DxLabelInsets _insets;
  final DxBadgeShadow? _shadow;

  const DxCornerDecoration({
    DxBadgeGeometry geometry = const DxBadgeGeometry(size: 40, alignment: DxBadgeAlignment.topRight),
    Color color = DxStyle.$E02020,
    Gradient? gradient,
    TextSpan? textSpan,
    String text = '',
    double textSize = 10,
    Color textColor = Colors.white,
    DxLabelInsets labelInsets = const DxLabelInsets(),
    DxBadgeShadow? badgeShadow,
  })  : _geometry = geometry,
        _color = color,
        _gradient = gradient,
        _textSpan = textSpan,
        _text = text,
        _textSize = textSize,
        _textColor = textColor,
        _insets = labelInsets,
        _shadow = badgeShadow;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    final TextSpan $textSpan =
        _textSpan ?? TextSpan(text: _text, style: TextStyle(fontSize: _textSize, color: _textColor));
    return _BadgePainter(_geometry, _color, _gradient, $textSpan, _insets, _shadow);
  }
}

class _BadgePainter extends BoxPainter {
  final DxBadgeGeometry _geometry;
  final Color? _color;
  final Gradient? _gradient;
  final TextSpan? _textSpan;
  final DxLabelInsets _insets;
  final DxBadgeShadow? _shadow;

  const _BadgePainter(this._geometry, this._color, this._gradient, this._textSpan, this._insets, this._shadow);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final size = cfg.size ?? const Size(0, 0);
    canvas.save();
    canvas.clipRRect(_geometry._createRRect(offset, size.width, size.height));
    final Offset pathOffset = _geometry._calcPathOffset(offset, size.width, size.height);
    canvas.translate(pathOffset.dx, pathOffset.dy);
    final Path path = _geometry._createPath();
    if (_shadow != null) {
      canvas.drawShadow(path, _shadow!.color, _shadow!.elevation, false);
    }
    canvas.drawPath(path, _badgePaint);

    // shift and rotate canvas, draw text
    if (_textSpan != null) {
      final textPainter = _createTextPainter();
      final textTranslate = _geometry._calcTextTranslate(textPainter, _insets);
      canvas.translate(textTranslate.dx, textTranslate.dy);
      canvas.rotate(_geometry._calcAngle());
      textPainter.paint(canvas, _insets._createTextOffset());
    }
    canvas.restore();
  }

  Paint get _badgePaint {
    final Paint paint = Paint();
    if (_color != null) {
      paint.color = _color!;
    } else {
      paint.shader = _gradient!.createShader(Rect.fromLTWH(0, 0, _geometry.size, _geometry.size));
    }
    return paint..isAntiAlias = true;
  }

  TextPainter _createTextPainter() {
    final hypo = _calcHypo(_geometry.size, _geometry.size);
    return TextPainter(
      text: _textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: hypo, maxWidth: hypo);
  }
}

class DxBadgeShadow {
  final Color color;
  final double elevation;

  const DxBadgeShadow({required this.color, required this.elevation}) : assert(elevation > 0);
}

class DxBadgeGeometry {
  final double size;
  final double borderRadius;
  final bool isTrapezoid;
  final DxBadgeAlignment alignment;

  const DxBadgeGeometry({
    this.size = 40,
    this.borderRadius = 4,
    this.isTrapezoid = true,
    this.alignment = DxBadgeAlignment.topRight,
  })  : assert(size > 0),
        assert(borderRadius >= 0);

  RRect _createRRect(Offset offset, double w, double h) {
    final radius = Radius.circular(borderRadius);
    return RRect.fromLTRBR(offset.dx, offset.dy, offset.dx + w, offset.dy + h, radius);
  }

  Offset _calcPathOffset(Offset offset, double w, double h) {
    switch (alignment) {
      case DxBadgeAlignment.bottomLeft:
        return Offset(offset.dx, offset.dy + h - size);
      case DxBadgeAlignment.bottomRight:
        return Offset(offset.dx + w - size, offset.dy + h);
      case DxBadgeAlignment.topLeft:
        return Offset(offset.dx, offset.dy + size);
      default:
        return Offset(offset.dx + w - size, offset.dy);
    }
  }

  Offset _calcTextTranslate(TextPainter painter, DxLabelInsets insets) {
    switch (alignment) {
      case DxBadgeAlignment.bottomLeft:
        final v = math.sqrt((insets.baselineShift * insets.baselineShift) / 2);
        final textShift = -1 * _calcHypo(v, v);
        return Offset(textShift, -textShift);
      case DxBadgeAlignment.bottomRight:
        final v = math.sqrt((insets.baselineShift * insets.baselineShift) / 2);
        final textShift = _calcHypo(v, v);
        return Offset(textShift, textShift);
      case DxBadgeAlignment.topLeft:
        final v = painter.height / 2 + math.sqrt((insets.baselineShift * insets.baselineShift) / 2);
        final textShift = _calcHypo(v, v);
        return Offset(-textShift, -textShift);
      default:
        final v = painter.height / 2 + math.sqrt((insets.baselineShift * insets.baselineShift) / 2);
        final textShift = _calcHypo(v, v);
        return Offset(textShift, -textShift);
    }
  }

  Path _createPath() {
    switch (alignment) {
      case DxBadgeAlignment.bottomLeft:
        if (isTrapezoid) {
          return Path()
            ..lineTo(0, size - size / 2)
            ..lineTo(size - size / 2, size)
            ..lineTo(size, size)
            ..close();
        } else {
          return Path()
            ..lineTo(0, size)
            ..lineTo(size, size)
            ..close();
        }
      case DxBadgeAlignment.bottomRight:
        if (isTrapezoid) {
          return Path()
            ..lineTo(size - size / 2, 0)
            ..lineTo(size, -size + size / 2)
            ..lineTo(size, -size)
            ..close();
        } else {
          return Path()
            ..lineTo(size, 0)
            ..lineTo(size, -size)
            ..close();
        }
      case DxBadgeAlignment.topLeft:
        if (isTrapezoid) {
          return Path()
            ..lineTo(0, -size + size / 2)
            ..lineTo(size - size / 2, -size)
            ..lineTo(size, -size)
            ..close();
        } else {
          return Path()
            ..lineTo(0, -size)
            ..lineTo(size, -size)
            ..close();
        }
      default:
        if (isTrapezoid) {
          return Path()
            ..lineTo(size - size / 2, 0)
            ..lineTo(size, size - size / 2)
            ..lineTo(size, size)
            ..close();
        } else {
          return Path()
            ..lineTo(size, 0)
            ..lineTo(size, size)
            ..close();
        }
    }
  }

  double _calcAngle() {
    switch (alignment) {
      case DxBadgeAlignment.bottomLeft:
        return math.atan2(size, size);
      case DxBadgeAlignment.bottomRight:
        return -math.atan2(size, size);
      case DxBadgeAlignment.topLeft:
        return -math.atan2(size, size);
      default:
        return math.atan2(size, size);
    }
  }
}

class DxLabelInsets {
  final double baselineShift;
  final double? start;
  final double? end;

  const DxLabelInsets({
    this.baselineShift = 1,
    this.start,
    this.end,
  })  : assert(baselineShift >= 0),
        assert((start == null && end == null) ||
            (start != null && start > 0 && end == null) ||
            (end != null && end > 0 && start == null));

  Offset _createTextOffset() => Offset(start == null && end == null ? 0 : (start != null ? start! : -end!), 0);
}

double _calcHypo(double w, double h) => math.sqrt(w * w + h * h);

enum DxBadgeAlignment { topLeft, topRight, bottomLeft, bottomRight }
