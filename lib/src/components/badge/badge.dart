import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 徽标，在右上角展示徽标数字或小红点
//ignore:must_be_immutable
class DxBadge extends StatelessWidget {
  /// 徽标内容
  final String content;

  /// 徽标背景颜色
  final Color? color;

  /// 徽标背景颜色
  final bool dot;

  /// 最大值，超过最大值会显示 `{max}+`，仅当 content 为数字时有效
  final int? max;

  /// 设置徽标的偏移量，数组的两项分别对应水平和垂直方向的偏移量
  final List<double> offset;

  /// 当 content 为数字 0 时，是否展示徽标
  final bool showZero;

  /// 徽标包裹的子元素
  final Widget? child;

  /// 自定义徽标内容
  final Widget? contentSlot;

  /// 主题
  DxBadgeThemeData? themeData;

  DxBadge({
    Key? key,
    this.content = '',
    this.dot = false,
    this.max,
    this.color,
    this.offset = const <double>[0.0, 0.0],
    this.showZero = true,
    this.child,
    this.contentSlot,
    this.themeData,
  }) : super(key: key) {
    themeData = DxBadgeThemeData().merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          child ?? const SizedBox.shrink(),
          Positioned(
            top: offset[0],
            right: -offset[1],
            child: FractionalTranslation(translation: const Offset(0.5, -0.5), child: _buildBadge()),
          ),
        ],
      );
    }

    return Transform.translate(offset: Offset(offset[0], offset[1]), child: _buildBadge());
  }

  /// 是否有内容
  bool get _hasContent {
    if (contentSlot != null) {
      return true;
    }
    return content.isNotEmpty && (showZero || content.trim() != '0');
  }

  /// 构建内容
  Widget? _buildContent() {
    if (!dot && _hasContent) {
      if (contentSlot != null) {
        return IconTheme(
          data: IconThemeData(
            color: themeData!.color,
            size: themeData!.fontSize,
          ),
          child: contentSlot!,
        );
      }

      String text = content;
      final double? contentNumber = double.tryParse(text);
      if (max != null && contentNumber != null && contentNumber > max!) {
        text = '$max+';
      }

      return Text(
        text,
        textAlign: TextAlign.center,
      );
    }
    return null;
  }

  /// 构建点样式徽标
  Widget _buildDotBadge() {
    return Container(
      width: themeData!.dotSize,
      height: themeData!.dotSize,
      constraints: const BoxConstraints(minWidth: 0),
      padding: themeData!.padding,
      decoration: BoxDecoration(
        color: color ?? themeData!.dotColor,
        border: Border.all(
          color: DxStyle.white,
          width: themeData!.borderWidth,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(themeData!.dotSize),
        ),
      ),
      child: _buildContent(),
    );
  }

  /// 构建内容
  Widget _buildContentBadge() {
    return Container(
      constraints: BoxConstraints(minWidth: themeData!.size),
      alignment: Alignment.center,
      padding: themeData!.padding,
      decoration: BoxDecoration(
        color: color ?? themeData!.backgroundColor,
        border: Border.all(color: DxStyle.white, width: themeData!.borderWidth),
        borderRadius: const BorderRadius.all(Radius.circular(DxStyle.borderRadiusMax)),
      ),
      child: _buildContent(),
    );
  }

  /// 构建徽标
  Widget? _buildBadge() {
    if (_hasContent || dot) {
      return DefaultTextStyle(
        style: TextStyle(
          height: 1.2,
          fontSize: themeData!.fontSize,
          fontWeight: themeData!.fontWeight,
          fontFamily: themeData!.fontFamily,
          color: themeData!.color,
        ),
        child: UnconstrainedBox(
          child: dot ? _buildDotBadge() : _buildContentBadge(),
        ),
      );
    }
    return null;
  }
}
