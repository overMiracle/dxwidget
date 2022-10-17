import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 描述: 左边标签，右边按钮的通知
/// 参考网址：https://bruno.ke.com/page/v2.2.0/widgets/brn-notice-bar-with-button
/// 1. 支持十种默认样式
/// 2. 支持设置或者隐藏左右图标
/// 3. 支持跑马灯

class DxNoticeBarWithButton extends StatelessWidget {
  /// 最小高度。leftWidget、rightWidget 都为空时，限制的最小高度。
  /// 可以通过该属性控制组件高度，内容会自动垂直居中。默认值 54。
  final double minHeight;

  final EdgeInsets margin;

  /// 内容的内边距
  final EdgeInsets? padding;

  /// 通知的背景色
  final Color? backgroundColor;

  /// 圆角
  final double borderRadius;

  /// 是否跑马灯
  /// 默认值false
  final bool marquee;

  /// 左边标签的文字
  final String? leftTagText;

  /// 左边标签的文字颜色
  final Color? leftTagTextColor;

  /// 左边标签的背景颜色
  final Color? leftTagBackgroundColor;

  /// 通知的内容
  final String content;

  /// 通知的文字颜色
  final Color? contentTextColor;

  ///右边按钮的文字
  final String? rightButtonText;

  ///右边按钮的文字颜色
  final Color? rightButtonTextColor;

  ///右边按钮的边框颜色
  final Color? rightButtonBorderColor;

  /// 自定义左边的控件
  final Widget? leftWidget;

  /// 自定义中间控件
  final Widget? contentWidget;

  /// 自定义右边的控件
  final Widget? rightWidget;

  /// 右边按钮点击回调
  final VoidCallback? onRightButtonTap;

  const DxNoticeBarWithButton({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.minHeight = 54,
    this.backgroundColor,
    this.borderRadius = 0,
    this.marquee = false,
    this.leftTagText,
    this.leftTagBackgroundColor,
    this.leftTagTextColor,
    this.content = '',
    this.contentTextColor,
    this.rightButtonBorderColor,
    this.rightButtonText,
    this.rightButtonTextColor,
    this.onRightButtonTap,
    this.leftWidget,
    this.contentWidget,
    this.rightWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 如果没有自定义视图，设置最小高度
    return Container(
      margin: margin,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0x14FA5741),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLeftTag(),
          Expanded(child: _buildContent()),
          _buildRightBtn(),
        ],
      ),
    );
  }

  /// 左边的标签
  Widget _buildLeftTag() {
    if (leftWidget != null) {
      return leftWidget!;
    }

    if (leftTagText?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 2),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: leftTagBackgroundColor ?? DxStyle.$FA5741,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          leftTagText!,
          style:
              TextStyle(color: leftTagTextColor ?? Colors.white, fontSize: 11, fontWeight: FontWeight.w600, height: 1),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (contentWidget != null) return contentWidget!;

    if (marquee) {
      return DxMarqueeText(
        height: 20,
        text: content,
        textStyle: TextStyle(color: contentTextColor ?? DxStyle.$333333, fontSize: 14),
      );
    } else {
      return Text(
        content,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: contentTextColor ?? DxStyle.$333333, fontSize: 14),
      );
    }
  }

  /// 右边的按钮
  Widget _buildRightBtn() {
    if (rightWidget != null) {
      return rightWidget!;
    }

    if (rightButtonText?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () => onRightButtonTap?.call(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 56),
          decoration: BoxDecoration(
            border: Border.all(
              color: rightButtonBorderColor ?? DxStyle.$FA5741,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            rightButtonText!,
            style: TextStyle(
              color: rightButtonTextColor ?? DxStyle.$FA5741,
              fontSize: 12,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
