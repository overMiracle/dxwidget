import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// CellGroup 单元格组
class DxCellGroup extends StatelessWidget {
  /// 外边距
  final EdgeInsets margin;

  /// 背景颜色
  final Color color;

  /// 是否显示外边框
  final bool border;

  /// 圆角
  final double borderRadius;

  /// 是否显示内边框，就是如果里面是cell，一个cell一个底部边框分割,也就是分割线
  final bool divider;

  /// 分组标题
  final String? title;

  /// 自定义分组标题
  final Widget? titleWidget;

  /// 标题边距
  final EdgeInsets titlePadding;

  /// 右侧
  final Widget? trailing;

  /// 默认插槽
  final List<Widget> children;

  /// cell标题样式
  final TextStyle? cellTitleStyle;

  /// cell子标题样式
  final TextStyle? cellSubTitleStyle;

  /// cell trailing标题样式
  final TextStyle? cellTrailingStyle;

  const DxCellGroup({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.color = Colors.white,
    this.border = false,
    this.borderRadius = 0,
    this.divider = false,
    this.title,
    this.titlePadding = const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 8),
    this.titleWidget,
    this.trailing,
    this.children = const <Widget>[],
    this.cellTitleStyle,
    this.cellSubTitleStyle,
    this.cellTrailingStyle,
  }) : super(key: key);

  buildItems(List list) {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      widgets.add(list[i]);
      if (i < list.length - 1) {
        widgets.add(const Divider(color: DxStyle.$F5F5F5, height: 0.5));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final DxCellGroupThemeData themeData = DxCellGroupTheme.of(context);
    Widget cellBody = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          border: border
              ? const Border(
                  top: BorderSide(width: 0.5, color: DxStyle.cellBorderColor),
                  bottom: BorderSide(width: 0.5, color: DxStyle.cellBorderColor),
                )
              : null,
        ),
        child: Column(children: divider ? buildItems(children) : children),
      ),
    );
    if (titleWidget == null && title == null) return cellBody;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildTitle(themeData), cellBody],
    );
  }

  /// 构建标题
  Widget _buildTitle(DxCellGroupThemeData themeData) {
    return Padding(
      padding: titlePadding.copyWith(bottom: DxStyle.paddingXs2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          titleWidget ??
              Text(
                title!,
                style: TextStyle(
                  color: themeData.titleColor,
                  fontSize: themeData.titleFontSize,
                  height: themeData.titleLineHeight,
                ),
              ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
