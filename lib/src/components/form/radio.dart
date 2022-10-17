import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

///
/// 横向单选录入项
/// 包括"标题"、"副标题"、"必填项提示"、"消息提示"、
/// "单选项"等元素
///
// ignore: must_be_immutable
class DxRadioFormItem extends StatefulWidget {
  /// 录入项 是否可编辑
  final bool isEdit;

  /// 边框
  final BoxBorder? border;

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

  /// 录入项 值
  int? value;

  /// 选项
  final List<RadioItem> options;

  /// 标题显示的最大行数，默认值 1
  final int? titleMaxLines;

  /// 选项选中状态变化回调
  final Function(int val)? onChanged;

  DxRadioFormItem({
    Key? key,
    this.isEdit = true,
    this.border,
    this.isRequire = false,
    this.leading,
    this.title = '',
    this.helperIcon,
    this.helperWidget,
    this.helperString = '',
    this.onHelper,
    this.value,
    required this.options,
    this.titleMaxLines,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DxRadioFormItem> createState() => _DxRadioFormItemState();
}

class _DxRadioFormItemState extends State<DxRadioFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Row(
        children: <Widget>[
          DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),
          DxFormUtil.buildHelperWidget(widget.helperIcon, widget.helperWidget, widget.helperString, widget.onHelper),
          Expanded(
            child: DxRadioGroup(
              key: UniqueKey(),
              options: widget.options,
              value: widget.value,
              onChanged: (int val) => widget.onChanged?.call(val),
            ),
          ),
        ],
      ),
    );
  }
}
