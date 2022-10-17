import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// DxIconButton图文组合组件，为了解决icon和文字组合的问题
/// 图文的方向 bottom、文字在下 icon在上 top、文字在上 icon在下
/// Left、文字在左 icon在右 right、文字在右 icon在左

enum DxIconButtonDirection {
  /// 文字在左边
  left,

  /// 文字在右边
  right,

  /// 文字在上边
  top,

  /// 文字在下边
  bottom,
}

class DxIconButton extends StatefulWidget {
  /// 是否禁用
  final bool disabled;

  /// 装饰
  final Decoration? decoration;

  /// 背景颜色
  final Color? bgColor;

  /// 圆角大小
  final double borderRadius;

  /// 文字相对于图片的位置
  final DxIconButtonDirection direction;

  /// 图文组合的宽度，默认 80
  final double width;

  /// 图文组合的高度，默认 80
  final double height;

  /// icon的文案
  final String name;

  ///  文字样式
  final TextStyle? style;

  /// 需要传的icon
  final Widget? iconWidget;

  /// 文字和图片的间距，默认 4
  final double space;

  /// 点击的回调
  final VoidCallback? onTap;

  const DxIconButton({
    Key? key,
    this.disabled = false,
    this.decoration,
    this.bgColor,
    this.borderRadius = 0,
    this.direction = DxIconButtonDirection.top,
    this.width = 80,
    this.height = 80,
    required this.name,
    this.style,
    this.iconWidget,
    this.space = 4,
    this.onTap,
  }) : super(key: key);

  @override
  State<DxIconButton> createState() => _DxIconButtonState();
}

class _DxIconButtonState extends State<DxIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.disabled ? null : widget.onTap?.call(),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: widget.decoration ??
            BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            ),
        foregroundDecoration: widget.disabled
            ? const BoxDecoration(color: DxStyle.$F0F0F0, backgroundBlendMode: BlendMode.lighten)
            : null,
        child: _buildButton(),
      ),
    );
  }

  /// 文字样式
  Widget _buildText() => Text(
        widget.name,
        style: widget.style ?? DxStyle.$999999$12,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  /// Icon
  Widget _buildIcon() => Align(alignment: Alignment.center, child: widget.iconWidget);

  Widget _buildButton() {
    switch (widget.direction) {
      case DxIconButtonDirection.left:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildIcon(),
            Padding(
              padding: EdgeInsets.only(left: widget.space),
              child: _buildText(),
            ),
          ],
        );
      case DxIconButtonDirection.right:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: widget.space),
              child: _buildText(),
            ),
            _buildIcon(),
          ],
        );
      case DxIconButtonDirection.bottom:
        // icon在下，文字在上
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: widget.space),
              child: _buildText(),
            ),
            _buildIcon(),
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildIcon(),
            Padding(
              padding: EdgeInsets.only(top: widget.space),
              child: _buildText(),
            )
          ],
        );
    }
  }
}
