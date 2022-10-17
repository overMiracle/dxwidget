import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

typedef DxTabBarItemSlotBuilder = Widget Function(BuildContext context, bool active);

/// TabBar 标签栏
/// 底部导航栏，用于在不同页面之间进行切换。
class DxTabBar extends StatelessWidget {
  /// 选中标签的颜色
  final Color? activeColor;

  /// 切换标签前的回调函数，返回 `false` 可阻止切换
  final bool Function(String name)? beforeChange;

  /// 未选中标签的颜色
  final Color? inactiveColor;

  /// 当前选中标签的名称或索引值
  final String value;

  /// 是否显示外边框
  final bool border;

  /// 是否开启底部安全区适配
  final bool safeAreaInsetBottom;

  final ValueChanged<String>? onChange;

  /// 内容
  final List<DxTabBarItem> children;

  const DxTabBar({
    Key? key,
    this.value = '0',
    this.activeColor,
    this.beforeChange,
    this.inactiveColor,
    this.border = true,
    this.safeAreaInsetBottom = false,
    this.onChange,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxTabBarThemeData themeData = DxTabBarTheme.of(context);

    return SafeArea(
      bottom: safeAreaInsetBottom,
      child: Container(
        width: double.infinity,
        height: themeData.height,
        decoration: BoxDecoration(
          color: themeData.backgroundColor,
        ),
        child: DxTabBarScope(
          parent: this,
          child: Row(children: children),
        ),
      ),
    );
  }

  void setActive(String value) {
    if (value != this.value) {
      bool canChange = true;
      if (beforeChange != null) {
        canChange = beforeChange!(value);
      }

      if (canChange) {
        onChange?.call(value);
      }
    }
  }
}

class DxTabBarScope extends InheritedWidget {
  const DxTabBarScope({
    Key? key,
    required this.parent,
    required Widget child,
  }) : super(key: key, child: child);

  final DxTabBar parent;

  static DxTabBarScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DxTabBarScope>();
  }

  @override
  bool updateShouldNotify(DxTabBarScope oldWidget) => parent != oldWidget.parent;
}

class DxTabBarItem extends StatelessWidget {
  /// 标签名称，作为匹配的标识符
  final String? name;

  /// 图标名称
  final IconData? iconName;

  /// 图片链接
  final String? iconUrl;

  /// 是否显示图标右上角小红点
  final bool dot;

  /// 图标右上角徽标的内容
  final String badge;

  final VoidCallback? onClick;

  /// 默认内容
  final DxTabBarItemSlotBuilder? textBuilder;

  /// 自定义图标
  final DxTabBarItemSlotBuilder? iconBuilder;

  const DxTabBarItem({
    Key? key,
    this.name,
    this.iconName,
    this.iconUrl,
    this.dot = false,
    this.badge = '',
    this.textBuilder,
    this.iconBuilder,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxTabBarThemeData themeData = DxTabBarTheme.of(context);
    final DxTabBar? parent = DxTabBarScope.of(context)?.parent;

    if (parent == null) {
      throw 'TabbarItem must be a child component of Tabbar.';
    }
    final int index = parent.children.indexWhere((Widget element) => element == this);

    final bool active = (name ?? index.toString()) == parent.value;

    final Color color =
        active ? (parent.activeColor ?? themeData.itemActiveColor) : (parent.inactiveColor ?? themeData.itemTextColor);

    Widget? customIcon;
    if (iconBuilder != null) {
      customIcon = iconBuilder!(context, active);
    }
    if (iconName != null || iconUrl != null) {
      customIcon = DxIcon(iconName: iconName);
    }

    final IconTheme iconWidget = IconTheme(
      data: IconThemeData(
        color: color,
        size: themeData.itemIconSize,
      ),
      child: Container(
        height: 20.0,
        constraints: const BoxConstraints.tightFor(width: 20.0),
        child: customIcon,
      ),
    );

    return Expanded(
      child: GestureDetector(
        onTap: () {
          parent.setActive(name ?? index.toString());
          onClick?.call();
        },
        child: DefaultTextStyle(
          style: TextStyle(
            color: color,
            fontSize: themeData.itemFontSize,
            height: themeData.itemLineHeight,
          ),
          child: Container(
            height: themeData.height,
            decoration: const BoxDecoration(
              border: Border(top: DxHairLine()),
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: DxStyle.paddingBase),
                DxBadge(
                  dot: dot,
                  content: badge,
                  child: iconWidget,
                ),
                SizedBox(height: themeData.itemMarginBottom),
                if (textBuilder != null) textBuilder!(context, active),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
