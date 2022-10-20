import 'package:flutter/material.dart';

/// Overlay 遮罩层
/// 来自flant,但是貌似有问题，暂时不使用
class DxOverlay extends StatelessWidget {
  /// 背景颜色
  final Color background;

  /// 是否展示遮罩层
  final bool show;

  /// 动画时长，单位秒
  final Duration duration;

  /// 自定义样式
  final BoxDecoration? customStyle;

  /// 是否锁定滚动，锁定时蒙层里的内容也将无法滚动
  final bool lockScroll;

  /// 点击时触发
  final VoidCallback? onClick;

  /// 默认插槽
  final Widget? child;

  const DxOverlay({
    Key? key,
    this.background = Colors.black45,
    this.show = false,
    this.duration = const Duration(milliseconds: 200),
    this.lockScroll = true,
    this.customStyle,
    this.onClick,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0,
      duration: duration,
      child: GestureDetector(
        onTap: onClick,
        child: DecoratedBox(
          decoration: customStyle ?? BoxDecoration(color: background),
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget? _buildChild() {
    if (child != null) {
      return IgnorePointer(ignoring: lockScroll, child: child);
    }
    return null;
  }
}
