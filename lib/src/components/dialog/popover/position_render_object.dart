import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/rendering.dart';

import 'popover_utils.dart';

class DxPopoverPositionRenderObject extends RenderShiftedBox {
  DxPopoverDirection? _direction;
  Rect? _attachRect;
  BoxConstraints? _additionalConstraints;
  double? arrowHeight;

  DxPopoverPositionRenderObject({
    required this.arrowHeight,
    RenderBox? child,
    Rect? attachRect,
    BoxConstraints? constraints,
    DxPopoverDirection? direction,
  }) : super(child) {
    _attachRect = attachRect;
    _additionalConstraints = constraints;
    _direction = direction;
  }

  BoxConstraints? get additionalConstraints => _additionalConstraints;
  set additionalConstraints(BoxConstraints? value) {
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  Rect? get attachRect => _attachRect;
  set attachRect(Rect? value) {
    if (_attachRect == value) return;
    _attachRect = value;
    markNeedsLayout();
  }

  DxPopoverDirection? get direction => _direction;
  set direction(DxPopoverDirection? value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  Offset calculateOffset(Size size) {
    final $direction = DxPopoverUtils.popoverDirection(
      attachRect,
      size,
      direction,
      arrowHeight,
    );

    if ($direction == DxPopoverDirection.top || $direction == DxPopoverDirection.bottom) {
      return _dxOffset($direction, _horizontalOffset(size), size);
    } else {
      return _dyOffset($direction, _verticalOffset(size), size);
    }
  }

  @override
  void performLayout() {
    child!.layout(
      _additionalConstraints!.enforce(constraints),
      parentUsesSize: true,
    );
    size = Size(constraints.maxWidth, constraints.maxHeight);
    final childParentData = child!.parentData as BoxParentData;
    childParentData.offset = calculateOffset(child!.size);
  }

  Offset _dxOffset(
    DxPopoverDirection direction,
    double horizontalOffset,
    Size size,
  ) {
    if (direction == DxPopoverDirection.bottom) {
      return Offset(horizontalOffset, attachRect!.bottom);
    } else {
      return Offset(horizontalOffset, attachRect!.top - size.height);
    }
  }

  Offset _dyOffset(
    DxPopoverDirection direction,
    double verticalOffset,
    Size size,
  ) {
    if (direction == DxPopoverDirection.right) {
      return Offset(attachRect!.right, verticalOffset);
    } else {
      return Offset(attachRect!.left - size.width, verticalOffset);
    }
  }

  double _horizontalOffset(Size size) {
    var offset = 0.0;

    if (attachRect!.left > size.width / 2 && 1.sw - attachRect!.right > size.width / 2) {
      offset = attachRect!.left + attachRect!.width / 2 - size.width / 2;
    } else if (attachRect!.left < size.width / 2) {
      offset = arrowHeight!;
    } else {
      offset = 1.sw - arrowHeight! - size.width;
    }
    return offset;
  }

  double _verticalOffset(Size size) {
    var offset = 0.0;

    if (attachRect!.top > size.height / 2 && 1.sh - attachRect!.bottom > size.height / 2) {
      offset = attachRect!.top + attachRect!.height / 2 - size.height / 2;
    } else if (attachRect!.top < size.height / 2) {
      offset = arrowHeight!;
    } else {
      offset = 1.sh - arrowHeight! - size.height;
    }
    return offset;
  }
}
