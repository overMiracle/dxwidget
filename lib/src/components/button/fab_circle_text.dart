import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 圆形图文悬浮按钮
class DxCircleTextFab extends StatelessWidget {
  /// 是否显示
  final bool isShow;

  /// 是否禁用
  final bool disabled;

  final String? heroTag;

  /// 大小
  final double size;

  /// 边距
  final EdgeInsets margin;

  /// 文本
  final String title;

  /// 优先显示图片
  final String? image;

  /// 如果没有图片就显示图标，没传图标就显示默认的
  final IconData? iconName;

  /// 渐变色
  final Gradient? gradient;

  /// 点击事件
  final VoidCallback? onClick;

  const DxCircleTextFab({
    Key? key,
    this.isShow = true,
    this.disabled = false,
    this.heroTag = 'edit',
    this.size = 60,
    this.margin = const EdgeInsets.only(bottom: 30.0),
    this.title = '添加',
    this.image,
    this.iconName = Icons.add,
    this.gradient = DxStyle.$GRADIENT$4A92E3$4078F4,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isShow) return const SizedBox.shrink();
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Container(
        width: isShow ? size : 0,
        height: isShow ? size : 0,
        margin: margin,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
          border: Border.all(width: 3, color: Colors.white),
        ),
        child: FloatingActionButton(
          isExtended: true,
          heroTag: heroTag,
          elevation: 0,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          focusElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            if (disabled == false) onClick?.call();
            return;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              image != null ? Image.asset(image!, width: 26, height: 26, fit: BoxFit.fill) : Icon(iconName, size: 26),
              Text(title, style: DxStyle.$WHITE$10)
            ],
          ),
        ),
      ),
    );
  }
}
