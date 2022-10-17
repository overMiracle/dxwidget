import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 基本IOS风格搜索框, 提供输入回调，一般用于appbar头部的搜索
/// 搜索框内容变化回调
typedef DxSearchBarOnTextChange = void Function(String content);

/// 提交搜索框内容时的回调
typedef DxSearchBarOnCommit = void Function(String content);

/// 基本IOS风格搜索框, 提供输入回调
class DxSearchBar extends StatefulWidget {
  /// 外边距
  final EdgeInsets margin;

  /// 提示语
  final String? hintText;

  /// 提示语样式
  final TextStyle? hintStyle;

  /// 输入框样式
  final TextStyle? textStyle;

  /// 用于设置搜索框前端的 Icon
  final Widget? prefixIcon;

  /// 搜索框内部的颜色
  final Color innerColor;

  /// 最大展示行数
  final int maxLines;

  /// 最大输入长度
  final int? maxLength;

  /// 输入框最大高度，默认 32
  final double maxHeight;

  ///普通状态的 border
  final BoxBorder? normalBorder;

  /// 激活状态的 Border， 默认和 border 一致
  final BoxBorder? activeBorder;

  /// 输入框圆角
  final double borderRadius;

  /// 右侧操作文本
  final String? actionText;

  /// 操作文本样式
  final TextStyle? actionTextStyle;

  /// 右侧操作 widget，优先级高于文本
  final Widget? actionWidget;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 用于控制键盘动作
  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final List<TextInputFormatter>? inputFormatters;

  final FocusNode? focusNode;

  /// 文本变化的回调
  final DxSearchBarOnTextChange? onTextChange;

  /// 提交文本时的回调
  final DxSearchBarOnCommit? onTextCommit;

  /// 右侧 action 区域点击的回调
  final VoidCallback? onActionTap;

  /// 清除按钮的回调
  final VoidCallback? onTextClear;

  final TextEditingController controller;

  const DxSearchBar({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.focusNode,
    this.autoFocus = false,
    this.maxHeight = 32,
    this.innerColor = Colors.white,
    this.normalBorder,
    this.activeBorder,
    this.borderRadius = 8,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.onTextChange,
    this.onTextCommit,
    this.onTextClear,
    this.actionText,
    this.actionTextStyle,
    this.actionWidget,
    this.onActionTap,
    this.textInputAction,
    this.inputFormatters,
    this.textInputType,
    required this.controller,
  }) : super(key: key);

  @override
  State<DxSearchBar> createState() => _DxSearchBarState();
}

class _DxSearchBarState extends State<DxSearchBar> {
  FocusNode? focusNode;
  BoxBorder? border;

  @override
  void initState() {
    super.initState();

    focusNode = widget.focusNode ?? FocusNode();
    border = widget.normalBorder ?? Border.all(width: 1.0, color: widget.innerColor);
    focusNode!.addListener(_handleFocusNodeChangeListenerTick);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode!.removeListener(_handleFocusNodeChangeListenerTick);
  }

  /// 焦点状态回到，用于刷新当前 UI
  void _handleFocusNodeChangeListenerTick() {
    if (focusNode!.hasFocus) {
      border = widget.activeBorder ?? border;
    } else {
      border = widget.normalBorder ?? border;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// 左侧搜索框
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.innerColor,
                border: border,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  widget.prefixIcon ??
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Center(child: Image.asset(DxAsset.search, width: 14, height: 14, package: 'dxwidget')),
                      ),
                  Expanded(
                    child: TextField(
                        maxLength: widget.maxLength,
                        autofocus: widget.autoFocus,
                        textInputAction: widget.textInputAction,
                        focusNode: focusNode,
                        controller: widget.controller,
                        keyboardType: widget.textInputType,
                        inputFormatters: widget.inputFormatters,
                        cursorColor: DxStyle.$0984F9,
                        cursorWidth: 2.0,
                        cursorHeight: 18,
                        style: widget.textStyle ?? DxStyle.$404040$14,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 8, right: 6),
                          hintStyle: widget.hintStyle ??
                              const TextStyle(
                                fontSize: 13,
                                height: 1,
                                textBaseline: TextBaseline.alphabetic,
                                color: Color(0xFF999999),
                              ),
                          hintText: widget.hintText ?? '请输入搜索内容',
                          counterText: '',
                        ),
                        // 在改变属性，当正在编辑的文本发生更改时调用。
                        onChanged: (content) => widget.onTextChange?.call(content),
                        onSubmitted: (content) => widget.onTextCommit?.call(content)),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.controller.clear();
                      widget.onTextClear?.call();
                      setState(() {});
                    },
                    child: Visibility(
                      visible: widget.controller.text.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Image.asset(DxAsset.delete, width: 15, height: 15, package: 'dxwidget'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 右侧事件
          (widget.actionText != null || widget.actionWidget != null)
              ? (widget.actionWidget ??
                  GestureDetector(
                    onTap: () => widget.onActionTap?.call(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        widget.actionText!,
                        style: widget.actionTextStyle ?? const TextStyle(color: DxStyle.white, fontSize: 14, height: 1),
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
