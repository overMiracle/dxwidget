import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 直线型进度条
class DxLinearProgressBar extends StatelessWidget {
  /// 进度条颜色
  final Color? color;

  /// 进度条颜色，传入对象格式可以定义渐变色
  final Gradient? gradient;

  /// 是否置灰
  final bool inactive;

  /// 进度文字内容
  final String? pivotText;

  /// 进度文字颜色
  final Color? textColor;

  /// 进度文字背景色
  final Color? pivotColor;

  /// 轨道颜色
  final Color? trackColor;

  /// 进度条粗细
  final double? strokeWidth;

  /// 进度百分比
  final double percentage;

  /// 是否显示进度文字
  final bool showPivot;

  /// 自定义底部内容
  final Widget? child;

  const DxLinearProgressBar({
    Key? key,
    this.color,
    this.gradient,
    this.inactive = false,
    this.pivotText,
    this.textColor,
    this.pivotColor,
    this.trackColor,
    this.strokeWidth,
    this.percentage = 0.0,
    this.showPivot = true,
    this.child,
  })  : assert(percentage >= 0 && percentage <= 100),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxProgressLinearBarThemeData themeData = DxProgressLinearBarTheme.of(context);

    return SizedBox(
      height: strokeWidth ?? themeData.height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double current = constraints.maxWidth * percentage / 100.0;
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: trackColor ?? themeData.backgroundColor,
                  borderRadius: BorderRadius.circular(themeData.height),
                ),
              ),
              Container(
                width: current,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  gradient: gradient,
                  color: background ?? themeData.color,
                  borderRadius: BorderRadius.circular(themeData.height),
                ),
              ),
              Positioned(
                top: constraints.maxHeight / 2,
                left: current,
                child: _buildPivot(themeData),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPivot(DxProgressLinearBarThemeData themeData) {
    num formatNumber(double n) => n.toInt() == n ? n.toInt() : n;

    final String text = pivotText ?? '${formatNumber(percentage)}%';
    final bool show = showPivot && text.isNotEmpty;

    return Offstage(
      offstage: !show,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Container(
          height: themeData.pivotLineHeight * themeData.pivotFontSize,
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minWidth: 3 * themeData.pivotFontSize,
          ),
          padding: themeData.pivotPadding,
          decoration: BoxDecoration(
            color: pivotColor ?? background ?? themeData.pivotBackgroundColor,
            borderRadius: BorderRadius.circular(themeData.pivotFontSize),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: themeData.pivotFontSize,
              color: textColor ?? themeData.pivotTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Color? get background => inactive ? const Color(0xffcacaca) : color;
}
