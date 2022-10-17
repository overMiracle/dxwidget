import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 基于字体的图标集，可以通过 Icon 组件使用，也可以在其他组件中通过 `icon` 属性引用。
class DxIcon extends StatelessWidget {
  /// 图标名称
  final IconData? iconName;

  /// 是否显示图标右上角小红点
  final bool dot;

  /// 图标右上角徽标的内容
  final String badge;

  /// 图标颜色
  final Color? color;

  /// 图标大小
  final double? size;

  /// 点击图标时触发
  final VoidCallback? onClick;

  const DxIcon({
    Key? key,
    this.iconName,
    this.dot = false,
    this.size,
    this.color,
    this.badge = '',
    this.onClick,
  }) : super(key: key);

  const DxIcon.name(
    this.iconName, {
    Key? key,
    this.dot = false,
    this.size,
    this.color,
    this.badge = '',
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onClick?.call(),
      child: DxBadge(dot: dot, content: badge, child: _buildIcon(context)),
    );
  }

  // 构建图片图标
  Widget _buildIcon(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double? iconSize = size ?? iconTheme.size;

    if (iconName != null) {
      return Icon(iconName, color: color ?? iconTheme.color, size: iconSize);
    }
    return const SizedBox.shrink();
  }
}
