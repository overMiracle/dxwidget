import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 宫格可以在水平方向上把页面分隔成等宽度的区块，用于展示内容或进行页面导航。
class DxGrid extends StatelessWidget {
  const DxGrid({
    Key? key,
    this.columnNum = 4,
    this.iconSize,
    this.gutter = 0.0,
    this.border = true,
    this.center = true,
    this.square = false,
    this.direction = Axis.vertical,
    this.children = const <DxGridItem>[],
  }) : super(key: key);

  /// 列数
  final int columnNum;

  /// 图标大小
  final double? iconSize;

  /// 格子之间的间距
  final double gutter;

  /// 是否显示边框
  final bool border;

  /// 是否将格子内容居中显示
  final bool center;

  /// 是否将格子固定为正方形
  final bool square;

  /// 格子内容排列的方向，可选值为 `horizontal` `vertical`
  final Axis direction;

  /// 内容
  final List<DxGridItem> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: border && gutter == 0.0 ? const DxHairLine() : BorderSide.none,
        ),
      ),
      padding: EdgeInsets.only(left: gutter),
      child: DxGridScope(
        parent: this,
        child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: children),
      ),
    );
  }
}

class DxGridScope extends InheritedWidget {
  final DxGrid parent;

  const DxGridScope({
    Key? key,
    required this.parent,
    required Widget child,
  }) : super(key: key, child: child);

  static DxGridScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DxGridScope>();
  }

  @override
  bool updateShouldNotify(DxGridScope oldWidget) => parent != oldWidget.parent;
}

/// 宫格单元格
class DxGridItem extends StatelessWidget {
  /// 文本
  final String? text;

  /// 图标名称
  final IconData? iconName;

  /// 红点
  final bool dot;

  /// 数字
  final String badge;

  /// 自定义宫格的所有内容
  final Widget? child;

  /// 自定义图标
  final Widget? iconSlot;

  /// 自定义文字
  final Widget? textSlot;

  /// 是否禁用
  final bool disable;

  /// 点击格子时触发
  final VoidCallback? onClick;

  const DxGridItem({
    Key? key,
    this.text,
    this.iconName,
    this.dot = false,
    this.badge = '',
    this.onClick,
    this.child,
    this.iconSlot,
    this.textSlot,
    this.disable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxGrid? parent = DxGridScope.of(context)?.parent;
    if (parent == null) {
      throw 'GridItem must be a child widget of Grid';
    }

    final int index = parent.children.indexOf(this);

    final bool surround = parent.border && parent.gutter > 0.0;
    final Border? border = parent.border
        ? Border(
            right: const DxHairLine(),
            bottom: const DxHairLine(),
            left: surround ? const DxHairLine() : BorderSide.none,
            top: surround ? const DxHairLine() : BorderSide.none,
          )
        : null;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double size = 1 / parent.columnNum * constraints.maxWidth;
        return Container(
          width: size,
          height: parent.square ? size : null,
          padding: EdgeInsets.only(right: parent.gutter),
          margin: EdgeInsets.only(
            top: index >= parent.columnNum ? parent.gutter : 0,
          ),
          child: Material(
            type: disable == false ? MaterialType.button : MaterialType.canvas,
            color: DxStyle.gridItemContentBackgroundColor,
            child: GestureDetector(
              onTap: disable == false ? () => onClick?.call() : null,
              child: Container(
                padding: DxStyle.gridItemContentPadding,
                decoration: BoxDecoration(border: border),
                child: Flex(
                  mainAxisAlignment: parent.center ? MainAxisAlignment.center : MainAxisAlignment.start,
                  crossAxisAlignment: parent.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  direction: parent.direction,
                  children: _buildContext(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context) {
    final DxGrid? parent = DxGridScope.of(context)?.parent;

    if (iconSlot != null) {
      return DxBadge(dot: dot, content: badge, child: iconSlot);
    }

    if (iconName != null) {
      return DxIcon(
        dot: dot,
        iconName: iconName,
        size: parent!.iconSize ?? DxStyle.gridItemIconSize,
        badge: badge,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildText(BuildContext context) {
    if (textSlot != null) return textSlot!;
    if (text != null) return Text(text!);
    return const SizedBox.shrink();
  }

  List<Widget> _buildContext(BuildContext context) {
    if (child != null) return <Widget>[child!];

    return <Widget>[
      _buildIcon(context),
      const SizedBox(width: DxStyle.paddingXs, height: DxStyle.paddingXs),
      DefaultTextStyle(
        style: const TextStyle(
          color: DxStyle.gridItemTextColor,
          fontSize: DxStyle.gridItemTextFontSize,
          height: 1.5,
        ),
        child: _buildText(context),
      ),
    ];
  }
}
