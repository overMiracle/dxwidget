import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

abstract class DxPopoverUtils {
  static DxPopoverDirection popoverDirection(
    Rect? attachRect,
    Size size,
    DxPopoverDirection? direction,
    double? arrowHeight,
  ) {
    switch (direction) {
      case DxPopoverDirection.top:
        return (attachRect!.top < size.height + arrowHeight!) ? DxPopoverDirection.bottom : DxPopoverDirection.top;
      case DxPopoverDirection.bottom:
        return 1.sh > attachRect!.bottom + size.height + arrowHeight!
            ? DxPopoverDirection.bottom
            : DxPopoverDirection.top;
      case DxPopoverDirection.left:
        return (attachRect!.left < size.width + arrowHeight!) ? DxPopoverDirection.right : DxPopoverDirection.left;
      case DxPopoverDirection.right:
        return 1.sw > attachRect!.right + size.width + arrowHeight!
            ? DxPopoverDirection.right
            : DxPopoverDirection.left;
      default:
        return DxPopoverDirection.bottom;
    }
  }
}
