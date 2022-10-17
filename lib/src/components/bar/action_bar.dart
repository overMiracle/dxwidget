import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// ActionBar 动作栏,一般用于底部
/// 其中children由ActionBarIcon和ActionBarButton组成
//ignore: must_be_immutable
class DxActionBar extends StatelessWidget {
  /// 是否开启底部安全区适配
  final bool safeAreaInsetBottom;

  /// 外边距
  final EdgeInsets margin;

  /// 内边距
  final EdgeInsets padding;

  /// 内容
  final List<Widget> children;

  /// 主题
  DxActionBarThemeData? themeData;

  DxActionBar({
    Key? key,
    this.margin = const EdgeInsets.fromLTRB(20, 10, 10, 20),
    this.padding = EdgeInsets.zero,
    this.safeAreaInsetBottom = false,
    this.children = const <Widget>[],
    this.themeData,
  }) : super(key: key) {
    themeData = DxActionBarThemeData().merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: themeData!.height,
      margin: margin,
      padding: padding,
      alignment: Alignment.center,
      color: themeData!.backgroundColor,
      child: SafeArea(
        bottom: safeAreaInsetBottom,
        top: false,
        left: false,
        right: false,
        child: DxActionBarScope(
          parent: this,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}

class DxActionBarScope extends InheritedWidget {
  const DxActionBarScope({
    Key? key,
    required this.parent,
    required Widget child,
  }) : super(key: key, child: child);

  final DxActionBar parent;

  static DxActionBarScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DxActionBarScope>();
  }

  @override
  bool updateShouldNotify(DxActionBarScope oldWidget) => parent != oldWidget.parent;
}

/// ### ActionBarIcon 动作栏图标按钮
//ignore: must_be_immutable
class DxActionBarIcon extends StatelessWidget {
  /// 按钮文字
  final String title;

  /// 图标名称
  final IconData? iconName;

  /// 图标插槽
  final Widget? iconWidget;

  /// 图标颜色
  final Color? color;

  /// 是否显示图标右上角小红点
  final bool dot;

  /// 图标右上角徽标的内容
  final String badge;

  final VoidCallback? onClick;

  DxActionBarThemeData? themeData;

  /// 子元素
  final Widget? child;

  DxActionBarIcon({
    Key? key,
    this.title = '',
    this.iconName,
    this.color,
    this.dot = false,
    this.badge = '',
    this.onClick,
    this.child,
    this.iconWidget,
    this.themeData,
  }) : super(key: key) {
    themeData = DxActionBarThemeData().merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: DxActiveResponse(
              builder: (_, bool active, Widget? child) {
                return Container(
                  height: themeData!.iconHeight,
                  color: active ? themeData!.iconActiveColor : Colors.transparent,
                );
              },
              onClick: () => onClick?.call(),
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            constraints: BoxConstraints(minWidth: themeData!.iconWidth - 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildIcon(),
                const SizedBox(height: 5.0),
                DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeData!.iconTextColor, fontSize: themeData!.iconFontSize, height: 1.0),
                  child: child ?? Text(title),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    if (iconWidget != null) {
      return DxBadge(
        dot: dot,
        content: badge,
        child: iconWidget,
      );
    }

    return DxIcon(
      dot: dot,
      badge: badge,
      iconName: iconName,
      color: themeData!.iconColor,
      size: themeData!.iconHeight,
    );
  }
}

/// ActionBarButton 动作栏按钮
//ignore: must_be_immutable
class DxActionBarButton extends StatelessWidget {
  /// 按钮文字
  final String title;

  /// 按钮颜色
  final Color? color;

  /// 渐变色
  final Gradient? gradient;

  /// 图标名称
  final DxButtonType type;

  /// 图标名称
  final IconData? iconName;

  /// 是否禁用按钮
  final bool disabled;

  /// 是否显示为加载状态
  final bool loading;

  /// 高度
  final double? height;

  /// 点击事件
  final VoidCallback? onClick;

  DxActionBarThemeData? themeData;

  /// 子元素
  final Widget? child;

  DxActionBarButton({
    Key? key,
    this.title = '确定',
    this.color,
    this.gradient,
    this.type = DxButtonType.normal,
    this.iconName,
    this.disabled = false,
    this.loading = false,
    this.height,
    this.onClick,
    this.child,
    this.themeData,
  }) : super(key: key) {
    themeData = DxActionBarThemeData().merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    final DxActionBar? parent = DxActionBarScope.of(context)?.parent;
    if (parent == null) {
      throw 'ActionButton must be a child component of DxActionBar';
    }
    final int index = parent.children.indexOf(this);
    final bool isFirst = !(index > 0 && parent.children.elementAt(index - 1) is DxActionBarButton);
    final bool isLast =
        !(index < parent.children.length - 1 && parent.children.elementAt(index + 1) is DxActionBarButton);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: isFirst ? 5.0 : 0.0, right: isLast ? 5.0 : 0.0),
        child: SizedBox(
          height: height ?? themeData!.buttonHeight,
          child: DxButton(
            type: type,
            height: themeData!.buttonHeight,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(DxStyle.borderRadiusMax) : Radius.zero,
              right: isLast ? const Radius.circular(DxStyle.borderRadiusMax) : Radius.zero,
            ),
            iconName: iconName,
            color: color,
            gradient: gradient ??
                <DxButtonType, Gradient>{
                  DxButtonType.danger: themeData!.buttonDangerColor,
                  DxButtonType.warning: themeData!.buttonWarningColor,
                }[type],
            loading: loading,
            disabled: disabled,
            onClick: () {
              if (disabled == true) return;
              onClick?.call();
            },
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontSize: DxStyle.fontSizeMd, fontWeight: DxStyle.fontWeightBold),
              child: child ?? Text(title),
            ),
          ),
        ),
      ),
    );
  }
}
