import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

///确认输入事件回调
typedef DxInputPickerInterceptor = bool Function(String v);
typedef DxInputPickerConfirmCallback = void Function(String content);

class DxInputPicker extends StatefulWidget {
  /// 最大输入行数，如果是1就是单行输入框，如果是大于1就是textarea
  final int maxLines;

  /// 弹窗左边自定义文案，默认 '取消'
  final String leftText;

  /// 弹窗自定义标题
  final String title;

  /// 弹窗右边自定义文案，默认 '确认'
  final String rightText;

  /// 输入框默认提示文案，默认'请输入'
  final String hintText;

  /// 输入框最大能输入的字符长度，默认 200
  final int maxLength;

  /// 光标颜色
  final Color? cursorColor;

  /// 默认文本
  final String? defaultText;

  /// 用于对 TextField  更精细的控制，若传入该字段，[defaultText] 参数将失效，可使用 TextEditingController.text 进行赋值。
  final TextEditingController? controller;

  /// 输入事件回调
  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  /// 拦截器
  final DxInputPickerInterceptor? interceptor;

  /// 确认输入内容事件回调
  final DxInputPickerConfirmCallback? onConfirm;

  const DxInputPicker({
    Key? key,
    this.maxLines = 1,
    this.maxLength = 200,
    this.hintText = '请输入',
    this.leftText = '取消',
    this.title = '',
    this.rightText = '确认',
    this.cursorColor,
    this.defaultText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.interceptor,
    this.onConfirm,
  }) : super(key: key);

  @override
  State<DxInputPicker> createState() => _DxInputPickerState();

  static void show(
    BuildContext context, {
    int maxLines = 1,
    int maxLength = 200,
    String hintText = '请输入',
    String leftText = '取消',
    String title = '请输入',
    String rightText = '确认',
    DxInputPickerInterceptor? interceptor,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    DxInputPickerConfirmCallback? onConfirm,
    Color? cursorColor,
    required TextEditingController controller,
  }) {
    final ThemeData theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget pageChild = DxInputPicker(
          maxLines: maxLines,
          maxLength: maxLength,
          hintText: hintText,
          leftText: leftText,
          title: title,
          rightText: rightText,
          cursorColor: cursorColor ?? DxStyle.$0984F9,
          controller: controller,
          interceptor: interceptor,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onConfirm: onConfirm,
        );
        return Theme(data: theme, child: pageChild);
      },
    );
  }
}

class _DxInputPickerState extends State<DxInputPicker> {
  final DxPickerThemeData themeData = DxPickerThemeData();

  @override
  Widget build(BuildContext context) {
    return DxBottomPickerWidget(
      barrierDismissible: true,
      contentWidget: TextField(
        autofocus: true,
        controller: widget.controller,
        maxLines: widget.maxLines,
        maxLength: widget.maxLines == 1 ? null : widget.maxLength,
        cursorColor: widget.cursorColor,
        style: DxStyle.$404040$15,
        cursorHeight: 20,
        decoration: InputDecoration(
          border: widget.maxLines == 1 ? null : InputBorder.none,
          hintStyle: DxStyle.$404040$14,
          counterStyle: DxStyle.$404040$14,
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onChanged: (String v) => widget.onChanged?.call(v),
        onSubmitted: (String v) {
          if (widget.interceptor == null || !widget.interceptor!.call(v)) {
            widget.onSubmitted?.call(v);
          }
        },
      ),
      pickerTitleConfig: DxPickerTitleConfig(titleText: widget.title),
      confirm: widget.rightText,
      cancel: widget.leftText,

      /// 标题栏的确认按钮
      onConfirmPressed: () {
        String content = widget.controller!.text ?? '';
        if (widget.interceptor == null || !widget.interceptor!.call(content)) {
          widget.onConfirm?.call(content);
        }
      },
    );
  }
}
