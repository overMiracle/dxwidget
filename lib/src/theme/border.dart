import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 边框
class DxBorder {
  DxBorder._();
  static Border $NONE = const Border();
  static Border $F0F0F0$BOTTOM = const Border(bottom: BorderSide(color: DxStyle.$F0F0F0, width: 0.2));
  static Border $F0F0F0$TOP$BOTTOM = const Border.symmetric(horizontal: BorderSide(color: DxStyle.$F0F0F0, width: 0.2));
  static Border $F5F5F5$BOTTOM = const Border(bottom: BorderSide(color: DxStyle.$F5F5F5, width: 0.5));
  static InputBorder $OUTLINE$TRANSPARENT = const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
}
