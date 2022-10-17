import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 按钮类型
enum DxButtonType { normal, primary, success, warning, danger }

/// 图标展示位置
enum DxButtonIconPosition { left, right }

/// 边框类型
enum DxButtonBorderType { solid, dotted }

/// Button 按钮，用于触发一个操作，如提交表单
class DxButton extends StatelessWidget {
  /// 动画tag
  final Object? heroTag;

  /// 外边距
  final EdgeInsets? margin;

  /// 内边距
  final EdgeInsets? padding;

  /// 类型，可选值为 `primary` `info` `warning` `danger`
  final DxButtonType type;

  /// 按钮颜色
  final Color? color;

  /// 高度
  final double? height;

  /// 按钮文字
  final String title;

  /// 文字大小
  final double? titleSize;

  /// 文字颜色
  final Color? titleColor;

  /// 按钮颜色(支持传入 linear-gradient 渐变色)
  final Gradient? gradient;

  /// 图标名称
  final IconData? iconName;

  /// 图标颜色
  final Color? iconColor;

  /// 图标组件
  final Widget? iconWidget;

  /// 图标展示位置，可选值为 `right`
  final DxButtonIconPosition iconPosition;

  /// 是否为块级元素
  final bool block;

  /// 是否为朴素按钮
  final bool plain;

  /// 是否为圆形按钮
  final bool round;

  /// 是否为方形按钮
  final bool square;

  /// 是否使用 0.5px 边框
  final bool hairline;

  /// 是否禁用按钮
  final bool disabled;

  /// 是否显示为加载状态
  final bool loading;

  /// 是否有边框
  final bool hasBorder;

  /// 边框样式
  final BoxBorder? border;

  /// 圆角大小
  final BorderRadius? borderRadius;

  /// 加载状态提示文字
  final String loadingText;

  /// 加载图标类型，可选值为 `spinner`
  final DxLoadingType loadingType;

  /// 加载图标大小
  final double? loadingSize;

  /// 点击按钮，且按钮状态不为加载或禁用时触发
  final VoidCallback? onClick;

  /// 按钮内容
  final Widget? child;

  /// 自定义加载图标
  final Widget? loadingSlot;

  const DxButton({
    Key? key,
    this.heroTag,
    this.margin,
    this.padding,
    this.type = DxButtonType.primary,
    this.height,
    this.title = '确定',
    this.titleSize = 14,
    this.titleColor,
    this.color,
    this.gradient,
    this.iconName,
    this.iconColor,
    this.iconWidget,
    this.iconPosition = DxButtonIconPosition.left,
    this.block = false,
    this.plain = false,
    this.round = false,
    this.square = false,
    this.hairline = true,
    this.disabled = false,
    this.loading = false,
    this.hasBorder = true,
    this.border,
    this.borderRadius,
    this.loadingText = '',
    this.loadingType = DxLoadingType.spinner,
    this.loadingSize,
    this.loadingSlot,
    this.onClick,
    this.child,
  }) : super(key: key);

  /// 小的蓝色圆角按钮
  const DxButton.smallPrimaryRound({
    super.key,
    this.heroTag,
    this.margin,
    this.padding,
    this.type = DxButtonType.primary,
    this.color,
    this.height = 24,
    this.title = '确定',
    this.titleSize = 12,
    this.titleColor,
    this.gradient,
    this.iconName,
    this.iconColor,
    this.iconWidget,
    this.iconPosition = DxButtonIconPosition.left,
    this.block = false,
    this.plain = true,
    this.round = true,
    this.square = false,
    this.hairline = true,
    this.disabled = false,
    this.loading = false,
    this.hasBorder = true,
    this.border,
    this.borderRadius,
    this.loadingText = '',
    this.loadingType = DxLoadingType.spinner,
    this.loadingSize,
    this.onClick,
    this.child,
    this.loadingSlot,
  });

  /// 小的背景白色灰色字体圆角按钮
  const DxButton.smallDefaultRound({
    super.key,
    this.heroTag,
    this.margin,
    this.padding,
    this.type = DxButtonType.normal,
    this.color,
    this.height = 24,
    this.title = '确定',
    this.titleSize = 12,
    this.titleColor = DxStyle.$CCCCCC,
    this.gradient,
    this.iconName,
    this.iconColor,
    this.iconWidget,
    this.iconPosition = DxButtonIconPosition.left,
    this.block = false,
    this.plain = true,
    this.round = true,
    this.square = false,
    this.hairline = true,
    this.disabled = false,
    this.loading = false,
    this.hasBorder = true,
    this.border,
    this.borderRadius,
    this.loadingText = '',
    this.loadingType = DxLoadingType.spinner,
    this.loadingSize,
    this.onClick,
    this.child,
    this.loadingSlot,
  });

  const DxButton.smallDangerRound({
    super.key,
    this.heroTag,
    this.margin,
    this.padding,
    this.type = DxButtonType.danger,
    this.color,
    this.height = 24,
    this.title = '确定',
    this.titleSize = 12,
    this.titleColor = DxStyle.red,
    this.gradient,
    this.iconName,
    this.iconColor,
    this.iconWidget,
    this.iconPosition = DxButtonIconPosition.left,
    this.block = false,
    this.plain = true,
    this.round = true,
    this.square = false,
    this.hairline = true,
    this.disabled = false,
    this.loading = false,
    this.hasBorder = true,
    this.border,
    this.borderRadius,
    this.loadingText = '',
    this.loadingType = DxLoadingType.spinner,
    this.loadingSize,
    this.onClick,
    this.child,
    this.loadingSlot,
  });

  @override
  Widget build(BuildContext context) {
    final DxButtonThemeData themeData = DxButtonTheme.of(context);

    final _DxButtonTheme themeType = _getThemeType(themeData);

    final $height = height ?? themeData.defaultHeight;

    final BorderRadius radius = borderRadius ??
        (square ? BorderRadius.zero : BorderRadius.circular(round ? $height / 2.0 : themeData.borderRadius));

    final TextStyle textStyle = TextStyle(
      fontSize: titleSize ?? themeData.defaultFontSize,
      height: themeData.defaultLineHeight,
      color: titleColor ?? themeType.color,
    );

    final Color bgColor = (plain ? null : color) ?? themeType.backgroundColor;
    final Widget? sideIcon = _buildIcon(themeData, themeType);

    Widget result = DefaultTextStyle(
      style: textStyle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => disabled || loading ? null : onClick?.call(),
        child: Container(
          margin: margin ?? EdgeInsets.zero,
          padding: padding ?? themeData.defaultPadding,
          height: plain ? $height - (hairline ? 1 : 2) : $height,
          decoration: BoxDecoration(
            border: border ?? themeType.border,
            borderRadius: radius,
            color: bgColor,
            gradient: color != null ? null : gradient,
          ),
          child: _buildContent(sideIcon),
        ),
      ),
    );

    if (disabled) {
      result = Opacity(opacity: 0.5, child: result);
    }

    if (heroTag != null) {
      result = Hero(tag: heroTag!, child: result);
    }
    return result;
  }

  /// 构建图标
  Widget? _buildIcon(
    DxButtonThemeData themeData,
    _DxButtonTheme themeType,
  ) {
    if (loading) {
      return loadingSlot ??
          DxLoading(
            size: loadingSize ?? themeData.loadingIconSize,
            type: loadingType,
            color: titleColor ?? themeType.color,
          );
    }
    if (iconWidget != null) return iconWidget;
    if (iconName != null) {
      return Icon(iconName, color: iconColor ?? themeType.color, size: themeData.iconSize);
    }
    return null;
  }

  /// 构建内容
  Widget _buildContent(Widget? sideIcon) {
    final List<Widget> children = <Widget>[
      if (loading) Text(loadingText) else child ?? Text(title),
    ];

    if (sideIcon != null) {
      switch (iconPosition) {
        case DxButtonIconPosition.left:
          if (_isHasText) {
            children.insert(0, const SizedBox(width: 4.0));
          }
          children.insert(0, sideIcon);
          break;
        case DxButtonIconPosition.right:
          if (_isHasText) {
            children.add(const SizedBox(width: 4.0));
          }
          children.add(sideIcon);
          break;
      }
    }

    if (block) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  /// 计算按钮样式
  _DxButtonTheme _computedThemeType(
    DxButtonThemeData themeData, {
    required Color backgroundColor,
    required Color color,
    required Color borderColor,
  }) {
    if (this.color != null) {
      borderColor = this.color!;
      color = Colors.white;
    }

    if (gradient != null) {
      borderColor = Colors.transparent;
      color = Colors.white;
    }

    BorderSide borderSide = BorderSide.none;
    if (hasBorder) {
      borderSide = BorderSide(
        width: hairline ? 0.5 : themeData.borderWidth,
        color: borderColor,
      );
    }

    return _DxButtonTheme(
      backgroundColor: plain ? themeData.plainBackgroundColor : backgroundColor,
      color: plain ? borderColor : color,
      border: Border.fromBorderSide(borderSide),
    );
  }

  /// 按钮是否有内容
  bool get _isHasText => title.isNotEmpty || child != null;

  /// 按钮样式集合
  _DxButtonTheme _getThemeType(DxButtonThemeData themeData) {
    switch (type) {
      case DxButtonType.primary:
        return _computedThemeType(
          themeData,
          backgroundColor: themeData.primaryBackgroundColor,
          color: themeData.primaryColor,
          borderColor: themeData.primaryBorderColor,
        );
      case DxButtonType.success:
        return _computedThemeType(
          themeData,
          backgroundColor: themeData.successBackgroundColor,
          color: themeData.successColor,
          borderColor: themeData.successBorderColor,
        );
      case DxButtonType.danger:
        return _computedThemeType(
          themeData,
          backgroundColor: themeData.dangerBackgroundColor,
          color: themeData.dangerColor,
          borderColor: themeData.dangerBorderColor,
        );
      case DxButtonType.warning:
        return _computedThemeType(
          themeData,
          backgroundColor: themeData.warningBackgroundColor,
          color: themeData.warningColor,
          borderColor: themeData.warningBorderColor,
        );
      case DxButtonType.normal:
        return _computedThemeType(
          themeData,
          backgroundColor: themeData.defaultBackgroundColor,
          color: themeData.defaultColor,
          borderColor: themeData.defaultBorderColor,
        );
    }
  }
}

/// 按钮主题样式类
class _DxButtonTheme {
  _DxButtonTheme({
    required this.color,
    required this.backgroundColor,
    this.border,
  });

  final Color backgroundColor;
  final Color color;
  final Border? border;
}
