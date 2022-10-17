import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// 多行文本框输入
/// 包括"标题"、"副标题"、"必填项提示"、"消息提示"、"文本输入框"等元素
///
// ignore: must_be_immutable
class DxTextareaFormItem extends StatefulWidget {
  /// 边框
  final Border? border;

  /// 是否自动获取焦点
  bool autofocus;

  /// 录入项 是否可编辑
  final bool isEdit;

  /// 录入项是否为必填项（展示*图标） 默认为 false 不必填
  final bool isRequire;

  /// 前缀组件,比方一些图标等
  final Widget? leading;

  /// 录入项标题
  final String title;

  /// 辅助
  final IconData? helperIcon;
  final Widget? helperWidget;
  final String helperString;

  /// 点击辅助图标回调
  final VoidCallback? onHelper;

  /// 输入字符数上限
  final int? maxCharCount;

  /// 录入项 hint 提示
  final String hint;

  /// 输入内容类型
  final TextInputType? inputType;

  /// 指定对输入数据的格式化要求
  final List<TextInputFormatter>? inputFormatters;

  /// 输入回调
  final ValueChanged<String>? onChanged;

  final TextEditingController? controller;

  /// 最小行数，默认值4
  final int? minLines;

  /// 最大行数，默认值20
  final int? maxLines;

  DxTextareaFormItem({
    Key? key,
    this.border,
    this.isEdit = true,
    this.isRequire = false,
    this.leading,
    this.title = '',
    this.helperIcon,
    this.helperWidget,
    this.helperString = '',
    this.onHelper,
    this.onChanged,
    this.hint = "请输入",
    this.maxCharCount,
    this.autofocus = false,
    this.inputType,
    this.inputFormatters,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 20,
  }) : super(key: key);

  @override
  State<DxTextareaFormItem> createState() => _DxTextareaFormItemState();
}

class _DxTextareaFormItemState extends State<DxTextareaFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),
              DxFormUtil.buildHelperWidget(
                widget.helperIcon,
                widget.helperWidget,
                widget.helperString,
                widget.onHelper,
              ),
            ],
          ),

          // 输入框
          TextField(
            autofocus: widget.autofocus,
            keyboardType: widget.inputType,
            controller: widget.controller,
            maxLength: widget.maxCharCount,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            textAlign: TextAlign.right,
            enabled: widget.isEdit,
            style: DxStyle.$404040$15,
            cursorHeight: 20,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              hintStyle: DxStyle.$CCCCCC$14,
              contentPadding: const EdgeInsets.only(top: 18),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (text) => widget.onChanged?.call(text),
          )
        ],
      ),
    );
  }
}
