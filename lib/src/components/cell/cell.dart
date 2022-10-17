import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 边框
enum DxCellBorderPosition { none, top, bottom, topAndBottom }

/// 箭头方向
enum DxCellArrowDirection { up, down, left, right }

/// Cell 单元格,最好使用在DxCellGroup中（可以从父级中统一设置字体样式）
/// 与DxListTile差不多，这里理解为简化版的DxListTile
/// 使用场景：单元格用于非循环列表
class DxCell extends StatelessWidget {
  /// 外边距
  final EdgeInsets margin;

  /// 内边距
  final EdgeInsets padding;

  /// 高度
  final double height;

  /// 是否禁用
  final bool disabled;

  /// 边框位置
  final DxCellBorderPosition borderPosition;

  final double borderRadius;

  /// 背景颜色
  final Color color;

  /// 左侧标题
  final String? title;

  /// 标题下方的描述信息
  final String? subTitle;

  /// 左侧标题额外样式
  final TextStyle? titleStyle;

  /// 描述信息额外类名
  final TextStyle? subTitleStyle;

  /// 自定义左侧 title 的内容
  final Widget? titleWidget;

  /// 自定义标题下方 subtitle 的内容
  final Widget? subTitleWidget;

  /// 自定义左侧组件
  final Widget? leading;

  /// 是否展示右侧箭头并开启点击反馈
  final bool trailingLink;

  /// 箭头方向，可选值为 `left` `up` `down`
  final DxCellArrowDirection arrowDirection;

  /// 右侧文本
  final String? trailing;

  /// 右侧文本样式
  final TextStyle? trailingStyle;

  /// 自定义右侧组件
  final Widget? trailingWidget;

  final double slidablePadding;

  /// 滑动长度比例，Must be between 0 (excluded) and 1.
  final double slidableExtentRatio;

  /// 滑动事件
  final List<DxSlidableAction>? slidableActionList;

  /// 点击单元格时触发
  final VoidCallback? onClick;

  final Widget _sizedBoxShrink = const SizedBox.shrink();

  const DxCell({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0),
    this.height = 54,
    this.disabled = false,
    this.borderPosition = DxCellBorderPosition.bottom,
    this.borderRadius = 0,
    this.color = Colors.white,
    this.trailingLink = false,
    this.arrowDirection = DxCellArrowDirection.right,
    this.leading,
    this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.titleWidget,
    this.subTitleWidget,
    this.trailing,
    this.trailingStyle,
    this.trailingWidget,
    this.slidablePadding = 0,
    this.slidableActionList,
    this.slidableExtentRatio = 0.5,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxCellGroup? parent = context.findAncestorWidgetOfExactType<DxCellGroup>();

    /// 改变字体样式
    TextStyle $titleStyle = titleStyle ?? parent?.cellTitleStyle ?? DxStyle.$333333$14;
    TextStyle $subTitleStyle = subTitleStyle ?? parent?.cellSubTitleStyle ?? DxStyle.$GRAY6$12;
    TextStyle $trailingStyle = trailingStyle ?? parent?.cellTrailingStyle ?? DxStyle.$404040$14;

    /// DxCellGroup的背景颜色优先
    Color? $color = parent?.color ?? color;

    bool hasSubTile = subTitleWidget != null || title != '';

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        margin: margin,
        padding: padding,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: $color,
          border: Border(
            top: (borderPosition == DxCellBorderPosition.top || borderPosition == DxCellBorderPosition.topAndBottom)
                ? const BorderSide(color: DxStyle.$F5F5F5, width: 0.5)
                : BorderSide.none,
            bottom:
                (borderPosition == DxCellBorderPosition.bottom || borderPosition == DxCellBorderPosition.topAndBottom)
                    ? const BorderSide(color: DxStyle.$F5F5F5, width: 0.5)
                    : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            leading != null ? Padding(padding: const EdgeInsets.only(right: 10), child: leading) : _sizedBoxShrink,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleWidget ?? (title != null ? Text(title!, style: $titleStyle) : _sizedBoxShrink),
                  hasSubTile ? const SizedBox(height: 4) : _sizedBoxShrink,
                  subTitleWidget ?? (subTitle != null ? Text(subTitle!, style: $subTitleStyle) : _sizedBoxShrink),
                ],
              ),
            ),
            trailingWidget ?? (trailing != null ? Text(trailing!, style: $trailingStyle) : _sizedBoxShrink),
            trailingLink
                ? Padding(
                    padding: const EdgeInsets.only(left: 5, top: 2),
                    child: Icon(_arrowIcon, size: 20, color: DxStyle.gray6),
                  )
                : _sizedBoxShrink,
          ],
        ),
      ),
    );

    if (slidableActionList != null) {
      content = DxSlidable(
        groupTag: '0',
        padding: slidablePadding,
        endActionPane: DxActionPane(
          extentRatio: slidableExtentRatio,
          motion: const DxScrollMotion(),
          children: slidableActionList!,
        ),
        child: content,
      );
    }

    return GestureDetector(onTap: () => onClick?.call(), child: content);
  }

  /// 箭头icon
  IconData get _arrowIcon {
    switch (arrowDirection) {
      case DxCellArrowDirection.up:
        return Icons.keyboard_arrow_up;
      case DxCellArrowDirection.down:
        return Icons.keyboard_arrow_down;
      case DxCellArrowDirection.left:
        return Icons.keyboard_arrow_left;
      case DxCellArrowDirection.right:
        return Icons.keyboard_arrow_right;
    }
  }
}
