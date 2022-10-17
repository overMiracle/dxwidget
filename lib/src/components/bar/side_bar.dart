import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// Sidebar 侧边导航
/// 垂直展示的导航栏，用于在不同的内容区域之间进行切换。
class DxSidebar extends StatelessWidget {
  const DxSidebar({
    Key? key,
    this.value = 0,
    this.backgroundColor,
    this.textSize = 14,
    this.textColor = DxStyle.$999999,
    this.activeTextColor = DxStyle.$3660C8,
    this.isSelectedBorder = false,
    this.onValueChange,
    this.onChange,
    this.children = const <Widget>[],
  }) : super(key: key);

  /// 当前导航项的索引
  final int value;

  /// 背景色
  final Color? backgroundColor;

  /// 文字大小
  final double textSize;

  /// 文字默认颜色
  final Color textColor;

  /// 文字选中颜色
  final Color activeTextColor;

  final bool isSelectedBorder;

  /// 导航值变化监听
  final ValueChanged<int>? onValueChange;

  /// 导航值变化监听
  final ValueChanged<int>? onChange;

  /// 内容
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final DxSidebarThemeData themeData = DxSidebarTheme.of(context);
    return Container(
      width: themeData.width,
      color: backgroundColor,
      child: DxSidebarScope(
        parent: this,
        child: ScrollConfiguration(
          behavior: DxNoScrollBehavior(),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: children,
          ),
        ),
      ),
    );
  }

  int getActive() => value;

  void setActive(int value) {
    if (getActive() != value) {
      onValueChange?.call(value);
      onChange?.call(value);
    }
  }
}

class DxSidebarScope extends InheritedWidget {
  const DxSidebarScope({
    Key? key,
    required this.parent,
    required Widget child,
  }) : super(key: key, child: child);

  final DxSidebar parent;

  static DxSidebarScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DxSidebarScope>();
  }

  @override
  bool updateShouldNotify(DxSidebarScope oldWidget) => parent != oldWidget.parent;
}

class DxSidebarItem extends StatelessWidget {
  const DxSidebarItem({
    Key? key,
    this.disabled = false,
    this.title = '',
    this.titleSlot,
    this.dot = false,
    this.badge = '',
    this.padding,
    this.onClick,
  }) : super(key: key);

  /// 是否禁用该项
  final bool disabled;

  /// 内容
  final String title;

  /// 自定义标题
  final Widget? titleSlot;

  /// 是否显示右上角小红点
  final bool dot;

  /// 图标右上角徽标的内容
  final String badge;

  /// 内边距
  final EdgeInsets? padding;

  /// 点击时触发
  final ValueChanged<int>? onClick;

  @override
  Widget build(BuildContext context) {
    final DxSidebar? parent = DxSidebarScope.of(context)?.parent;
    if (parent == null) {
      throw 'FlanSidebarItem must be a child Widget of FlanSidebar';
    }

    final int index = parent.children.indexOf(this);
    final bool selected = index == parent.getActive();

    final DxSidebarThemeData themeData = DxSidebarTheme.of(context);

    Color bgColor = selected ? themeData.selectedBackgroundColor : themeData.backgroundColor;

    Color textColor = disabled
        ? themeData.disabledTextColor
        : selected
            ? parent.activeTextColor
            : parent.textColor;

    return GestureDetector(
      onTap: () {
        if (disabled) return;
        onClick?.call(index);
        parent.setActive(index);
      },
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: themeData.fontSize,
          height: themeData.lineHeight,
          color: textColor,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: padding ?? themeData.padding,
              color: bgColor,
              child: DxBadge(
                dot: dot,
                content: badge,
                child: titleSlot ?? Text(title, textHeightBehavior: DxStyle.textHeightBehavior),
              ),
            ),
            (parent.isSelectedBorder && selected)
                ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: themeData.selectedBorderWidth,
                        height: themeData.selectedBorderHeight,
                        color: themeData.selectedBorderColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
