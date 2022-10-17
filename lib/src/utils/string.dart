import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

RegExp camelRE = RegExp(r'-(\w)');

String camel(String str) {
  return str.replaceAllMapped(camelRE, (Match c) => (c[1] ?? '').toUpperCase());
}

/// 左侧补0
String padZero(dynamic num, {int targetLength = 2}) {
  final String str = num.toString();

  return str.padLeft(targetLength, '0');
}

/// 根据 TextStyle 计算 text 宽度
Size textSize(String text, TextStyle style) {
  if (DxTools.isEmpty(text)) return const Size(0, 0);
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
