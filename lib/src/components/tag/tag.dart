import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 标签
class DxTag extends StatefulWidget {
  /// 外边距
  final EdgeInsets? margin;

  /// 内边距
  final EdgeInsets padding;

  /// 高度，默认18.0
  final double height;

  /// 是否是正方形，如果是宽度强制为高度
  final bool isSquare;

  /// 是否有边框
  final bool hasBorder;

  /// 边框颜色
  final Color? borderColor;

  /// 边框大小
  final double borderWidth;

  /// 圆角大小
  final double? borderRadius;

  /// 标签背景颜色
  final Color? color;

  /// 标签显示内容
  final String? text;

  /// 文本颜色
  final Color? textColor;

  /// 文本高度， 默认1.3更居中 但随着字体变大 这个值应该趋于1.0 允许手动调节
  final double lineHeight;

  /// 文本大小
  final double fontSize;

  /// 是否为空心样式
  final bool plain;

  /// 是否为标记样式
  final bool mark;

  /// 内容组件，优先级高于text
  final Widget? child;

  /// 是否显示
  final bool isShow;

  /// 是否为可关闭标签，如果为true显示关闭图标
  final bool canClose;

  /// 标签关闭的回调事件
  final VoidCallback? onClose;

  /// 点击事件
  final VoidCallback? onClick;

  const DxTag({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = DxStyle.tagPadding,
    this.isSquare = false,
    this.height = 18.0,
    this.hasBorder = true,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.color,
    this.text,
    this.textColor,
    this.lineHeight = 1.3,
    this.fontSize = DxStyle.tagFontSize,
    this.plain = false,
    this.mark = false,
    this.isShow = true,
    this.canClose = false,
    this.child,
    this.onClose,
    this.onClick,
  }) : super(key: key);

  /// 主题
  static Widget primary({
    margin = EdgeInsets.zero,
    padding = DxStyle.tagPadding,
    height = 18.0,
    isSquare = false,
    hasBorder = true,
    borderColor = DxStyle.tagPrimaryColor,
    borderWidth = 1.0,
    borderRadius,
    text,
    lineHeight = 1.3,
    fontSize = DxStyle.tagFontSize,
    plain = false,
    mark = false,
    isShow = true,
    canClose = false,
    child,
    onClose,
    onClick,
  }) {
    Color color = plain ? DxStyle.white : DxStyle.tagPrimaryColor;
    Color textColor = plain ? DxStyle.tagPrimaryColor : DxStyle.white;
    return DxTag(
      margin: margin,
      padding: padding,
      height: height,
      isSquare: isSquare,
      hasBorder: hasBorder,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      color: color,
      text: text,
      lineHeight: lineHeight,
      textColor: textColor,
      fontSize: fontSize,
      plain: plain,
      mark: mark,
      isShow: isShow,
      canClose: canClose,
      child: child,
      onClose: onClose,
      onClick: onClick,
    );
  }

  /// 成功
  static Widget success({
    margin = EdgeInsets.zero,
    padding = DxStyle.tagPadding,
    height = 18.0,
    isSquare = false,
    hasBorder = true,
    borderColor = DxStyle.tagSuccessColor,
    borderWidth = 1.0,
    borderRadius,
    text,
    lineHeight = 1.3,
    fontSize = DxStyle.tagFontSize,
    plain = false,
    mark = false,
    isShow = true,
    canClose = false,
    child,
    onClose,
    onClick,
  }) {
    Color color = plain ? DxStyle.white : DxStyle.tagSuccessColor;
    Color textColor = plain ? DxStyle.tagSuccessColor : DxStyle.white;
    return DxTag(
      margin: margin,
      padding: padding,
      height: height,
      isSquare: isSquare,
      hasBorder: hasBorder,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      color: color,
      text: text,
      lineHeight: lineHeight,
      textColor: textColor,
      fontSize: fontSize,
      plain: plain,
      mark: mark,
      isShow: isShow,
      canClose: canClose,
      child: child,
      onClose: onClose,
      onClick: onClick,
    );
  }

  /// 危险
  static Widget danger({
    margin = EdgeInsets.zero,
    padding = DxStyle.tagPadding,
    height = 18.0,
    isSquare = false,
    hasBorder = true,
    borderColor = DxStyle.tagDangerColor,
    borderWidth = 1.0,
    borderRadius,
    text,
    lineHeight = 1.3,
    fontSize = DxStyle.tagFontSize,
    plain = false,
    mark = false,
    isShow = true,
    canClose = false,
    child,
    onClose,
    onClick,
  }) {
    Color color = plain ? DxStyle.white : DxStyle.tagDangerColor;
    Color textColor = plain ? DxStyle.tagDangerColor : DxStyle.white;
    return DxTag(
      margin: margin,
      padding: padding,
      height: height,
      isSquare: isSquare,
      hasBorder: hasBorder,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      color: color,
      text: text,
      lineHeight: lineHeight,
      textColor: textColor,
      fontSize: fontSize,
      plain: plain,
      mark: mark,
      isShow: isShow,
      canClose: canClose,
      child: child,
      onClose: onClose,
      onClick: onClick,
    );
  }

  /// 警告
  static Widget warning({
    margin = EdgeInsets.zero,
    padding = DxStyle.tagPadding,
    height = 18.0,
    isSquare = false,
    hasBorder = true,
    borderColor = DxStyle.tagWarningColor,
    borderWidth = 1.0,
    borderRadius,
    text,
    lineHeight = 1.3,
    fontSize = DxStyle.tagFontSize,
    plain = false,
    mark = false,
    isShow = true,
    canClose = false,
    child,
    onClose,
    onClick,
  }) {
    Color color = plain ? DxStyle.white : DxStyle.tagWarningColor;
    Color textColor = plain ? DxStyle.tagWarningColor : DxStyle.white;
    return DxTag(
      margin: margin,
      padding: padding,
      height: height,
      isSquare: isSquare,
      hasBorder: hasBorder,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      color: color,
      text: text,
      lineHeight: lineHeight,
      textColor: textColor,
      fontSize: fontSize,
      plain: plain,
      mark: mark,
      isShow: isShow,
      canClose: canClose,
      child: child,
      onClose: onClose,
      onClick: onClick,
    );
  }

  @override
  State<DxTag> createState() => _DxTagState();
}

class _DxTagState extends State<DxTag> {
  late bool isShow;
  final DxTagThemeData themeData = DxTagThemeData();

  @override
  void initState() {
    super.initState();
    isShow = widget.isShow;
    if (widget.isSquare == true) {
      assert(widget.text?.length == 1, '正方形徽标里面最多只有一个字符');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isShow ? 1.0 : 0.0,
      duration: DxStyle.animationDurationBase,
      curve: isShow ? DxStyle.animationTimingFunctionLeave : DxStyle.animationTimingFunctionEnter,
      child: GestureDetector(
        onTap: () => widget.onClick?.call(),
        child: Container(
          margin: widget.margin,
          padding: widget.isSquare ? EdgeInsets.zero : widget.padding,
          height: widget.height,
          width: widget.isSquare ? widget.height : null,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: _getBorder(),
            color: widget.plain ? DxStyle.tagPlainBackgroundColor : widget.color,
            borderRadius: _getBorderRadius(),
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: _getTextColor(), fontSize: widget.fontSize, height: widget.lineHeight),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                widget.child ??
                    Text(
                      widget.text ?? '',
                      style: TextStyle(color: _getTextColor(), fontSize: widget.fontSize),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                widget.canClose
                    ? Padding(
                        padding: const EdgeInsets.only(left: 2.0, top: 1.0),
                        child: DxIcon.name(
                          Icons.close,
                          size: widget.fontSize * 1.2,
                          color: _getTextColor(),
                          onClick: () {
                            widget.onClose?.call();
                            setState(() => isShow = false);
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 边框,规则如下：
  /// 1、如果存在边框，优先使用参数borderColor和borderSize
  /// 2、如果borderColor为空，则使用type中配置的颜色
  BoxBorder? _getBorder() {
    if (widget.hasBorder == false) return const Border();
    return Border.all(color: widget.borderColor ?? widget.textColor ?? themeData.textColor, width: widget.borderWidth);
  }

  /// 计算标签圆角大小
  BorderRadius _getBorderRadius() {
    if (widget.mark) {
      return const BorderRadius.only(
        topRight: Radius.circular(DxStyle.borderRadiusMax),
        bottomRight: Radius.circular(DxStyle.borderRadiusMax),
      );
    }
    if (widget.borderRadius != null) return BorderRadius.circular(widget.borderRadius!);
    return widget.mark
        ? const BorderRadius.horizontal(
            left: Radius.circular(DxStyle.tagBorderRadius),
            right: Radius.circular(DxStyle.tagRoundBorderRadius),
          )
        : BorderRadius.circular(themeData.borderRadius);
  }

  /// 计算标签文字颜色
  Color _getTextColor() {
    if (widget.textColor != null) {
      return widget.textColor!;
    }

    /// 当空心的时候，背景是白色的
    if (widget.plain && widget.color != null) {
      return widget.color!;
    }

    return themeData.textColor;
  }
}
