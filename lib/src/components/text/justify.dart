import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 两端对其文本
class DxJustifyText extends StatelessWidget {
  /// 边距
  final EdgeInsets padding;

  /// 条目高度
  final double height;

  /// 左侧样式
  final TextStyle? leftStyle;

  /// 右侧样式
  final TextStyle? rightStyle;

  /// 条目是否有底部边框
  final bool hasBorder;

  /// 条目列表
  final List<DxJustifyItem> children;

  const DxJustifyText({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.height = 35.0,
    this.leftStyle = DxStyle.$404040$12,
    this.rightStyle = DxStyle.$F25643$12,
    this.hasBorder = false,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (_, int index) {
        DxJustifyItem item = children.elementAt(index);
        return Container(
          height: height,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              item.leftWidget ?? Text(item.left, style: item.leftStyle ?? leftStyle),
              item.rightWidget ?? Text(item.right ?? '', style: item.rightStyle ?? rightStyle),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => hasBorder ? const DxDivider() : const SizedBox.shrink(),
    );
  }
}

/// 条目
class DxJustifyItem {
  /// key左侧文本
  final String left;

  /// key文本样式
  final TextStyle? leftStyle;

  /// value右侧文本
  final String? right;

  /// value文本样式
  final TextStyle? rightStyle;

  /// key组件
  final Widget? leftWidget;

  /// value组件
  final Widget? rightWidget;

  const DxJustifyItem({
    this.left = '',
    this.right = '',
    this.leftStyle,
    this.rightStyle,
    this.leftWidget,
    this.rightWidget,
  });
}
