import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

enum DxPasswordBorderType { outLine, underLine }

/// 带网格的输入框组件，可以用于输入密码、短信验证码等场景，通常与数字键盘组件配合使用
class DxPasswordFormItem extends StatefulWidget {
  // 样式,边框和下划线
  final DxPasswordBorderType borderType;

  // 密码值
  final String value;

  // 密码最大长度
  final int length;

  // 是否隐藏密码内容
  final bool obscureText;

  // 当密码值位数等于最大程度，是否自动隐藏键盘
  final bool hideWhenSubmitted;

  // 输入框下方文字提示
  final String? info;

  // 输入框点击时触发
  final Function()? onClick;

  // 密码值改变时触发
  final Function(String val)? onChange;

  // 密码值位数等于最大程度时触发
  final Function(String val)? onSubmitted;

  const DxPasswordFormItem({
    Key? key,
    this.borderType = DxPasswordBorderType.outLine,
    this.value = '',
    this.length = 6,
    this.obscureText = true,
    this.hideWhenSubmitted = false,
    this.info,
    this.onClick,
    this.onChange,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<DxPasswordFormItem> createState() => _DxPasswordFormItemState();
}

class _DxPasswordFormItemState extends State<DxPasswordFormItem> {
  String? _value;
  late List<String> _codeList;

  @override
  void initState() {
    _value = widget.value;
    _codeList = List.filled(widget.length, '');
    List<String> origin = widget.value.split('');
    _codeList.setAll(0, origin);
    super.initState();
  }

  Widget _buildInputWidget(int p) {
    return Expanded(
      child: Container(
        height: DxStyle.passwordInputHeight,
        alignment: Alignment.center,
        margin: widget.borderType == DxPasswordBorderType.outLine
            ? EdgeInsets.only(
                left: widget.length < 6 && p > 0 ? DxStyle.passwordInputGutter : 0,
                right: widget.length < 6 && p < widget.length - 1 ? DxStyle.passwordInputGutter : 0,
              )
            : const EdgeInsets.only(right: 10),
        decoration: widget.borderType == DxPasswordBorderType.outLine
            ? BoxDecoration(
                borderRadius: widget.length < 6
                    ? BorderRadius.circular(DxStyle.passwordInputBorderRadius)
                    : p == 0
                        ? const BorderRadius.horizontal(left: Radius.circular(DxStyle.passwordInputBorderRadius))
                        : p == widget.length - 1
                            ? const BorderRadius.horizontal(right: Radius.circular(DxStyle.passwordInputBorderRadius))
                            : null,
                border: (p == 0 || p == widget.length - 1)
                    ? Border.all(color: DxStyle.borderColor)
                    : Border(
                        top: const BorderSide(color: DxStyle.borderColor, width: DxStyle.borderWidthBase),
                        left: BorderSide(
                            color: DxStyle.borderColor, width: widget.length < 6 ? DxStyle.borderWidthBase : 0),
                        right: BorderSide(
                            color: DxStyle.borderColor,
                            width: p < widget.length - 2 || widget.length < 6 ? DxStyle.borderWidthBase : 0),
                        bottom: const BorderSide(color: DxStyle.borderColor, width: DxStyle.borderWidthBase),
                      ),
                color: DxStyle.passwordInputBackgroundColor,
              )
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: DxStyle.$C5C5C5, width: DxStyle.borderWidthBase)),
              ),
        child: Text(
          _codeList.elementAt(p) == ''
              ? ''
              : widget.obscureText
                  ? '●'
                  : _codeList[p],
          style: const TextStyle(
            fontSize: DxStyle.passwordInputFontSize,
            color: DxStyle.passwordInputColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(bottom: widget.info != null ? DxStyle.paddingSm : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DxStyle.passwordInputBorderRadius),
            ),
            child: Row(children: List.generate(widget.length, (i) => _buildInputWidget(i))),
          ),
          onTap: () {
            DxNumberKeyboard(
                value: _value,
                maxLength: widget.length,
                onChange: (val) {
                  List<String> newVal = val.split('');
                  setState(() {
                    _codeList = List.filled(widget.length, '');
                    _codeList.setAll(0, newVal);
                    _value = val;
                  });
                  widget.onChange?.call(val);
                  if (widget.onSubmitted != null && newVal.length == widget.length) {
                    if (widget.hideWhenSubmitted) Navigator.pop(context);
                    widget.onSubmitted?.call(val);
                  }
                }).show(context);
            widget.onClick?.call();
          },
        ),
        widget.info != null
            ? Text(
                widget.info!,
                style: const TextStyle(
                  fontSize: DxStyle.passwordInputInfoFontSize,
                  color: DxStyle.passwordInputInfoColor,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
