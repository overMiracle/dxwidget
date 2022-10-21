import 'dart:math';

import 'package:flutter/material.dart';

/// 让一个组件点击时执行旋转，再点击旋转回去。
/// github地址：https://github.com/toly1994328/toggle_rotate
///
/// ToggleRotate(
///   beginAngle: 0, // 起始角度
///   endAngle: 45, // 终止角度
///   clockwise: false, //是否是顺时针
///   child: Icon(Icons.arrow_upward,size: 60,color: Colors.orangeAccent),
///   onEnd: (bool isExpanded) { // 动画结束时间
///       print("---expanded---:$isExpanded-------");
///     },
///   onTap: () {}, //点击事件
/// ),
class DxToggleRotate extends StatefulWidget {
  final Widget child;
  final ValueChanged<bool>? onEnd;
  final VoidCallback? onTap;
  final double beginAngle;
  final double endAngle;
  final int durationMs;
  final bool clockwise;
  final Curve curve;
  final Widget? prefixWidget;
  final Widget? suffixWidget;

  const DxToggleRotate({
    Key? key,
    required this.child,
    this.onTap,
    this.onEnd,
    this.beginAngle = 0,
    this.endAngle = 90,
    this.clockwise = true,
    this.durationMs = 200,
    this.curve = Curves.fastOutSlowIn,
    this.prefixWidget,
    this.suffixWidget,
  }) : super(key: key);

  @override
  State<DxToggleRotate> createState() => _DxToggleRotateState();
}

class _DxToggleRotateState extends State<DxToggleRotate> with SingleTickerProviderStateMixin {
  bool _rotated = false;
  late AnimationController _controller;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: widget.durationMs), vsync: this);
    _initTweenAnim();
  }

  void _initTweenAnim() {
    _rotateAnim = Tween<double>(begin: widget.beginAngle / 180 * pi, end: widget.endAngle / 180 * pi)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);
  }

  @override
  void didUpdateWidget(DxToggleRotate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.durationMs != oldWidget.durationMs) {
      _controller.dispose();
      _controller = AnimationController(duration: Duration(milliseconds: widget.durationMs), vsync: this);
      _initTweenAnim();
    }
    if (widget.beginAngle != oldWidget.beginAngle ||
        widget.endAngle != oldWidget.endAngle ||
        widget.curve != oldWidget.curve) {
      _initTweenAnim();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get rad => widget.clockwise ? _rotateAnim.value : -_rotateAnim.value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        widget.onTap?.call();
        if (_rotated) {
          await _controller.reverse();
        } else {
          await _controller.forward();
        }
        _rotated = !_rotated;
        widget.onEnd?.call(_rotated);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.prefixWidget ?? const SizedBox.shrink(),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Transform(
              transform: Matrix4.rotationZ(rad),
              alignment: Alignment.center,
              child: widget.child,
            ),
          ),
          widget.suffixWidget == null
              ? const SizedBox.shrink()
              : Padding(padding: const EdgeInsets.only(left: 5), child: widget.suffixWidget),
        ],
      ),
    );
  }
}
