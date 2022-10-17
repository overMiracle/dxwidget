import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 1px 边框
class DxHairLine extends BorderSide {
  const DxHairLine({
    Color color = DxStyle.borderColor,
  }) : super(color: color, width: 0.5);
}
