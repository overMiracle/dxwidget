import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

/// 带开关按钮表单
// ignore: must_be_immutable
class DxSwitchFormItem extends StatefulWidget {
  /// 录入项 是否可编辑
  final bool isEdit;

  /// 边框
  final Border? border;

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

  /// 特有字段
  final bool value;

  /// 开关变化回调
  final ValueChanged<bool>? onChanged;

  const DxSwitchFormItem({
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
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DxSwitchFormItem> createState() => _DxSwitchFormItemState();
}

class _DxSwitchFormItemState extends State<DxSwitchFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),
          DxFormUtil.buildHelperWidget(widget.helperIcon, widget.helperWidget, widget.helperString, widget.onHelper),
          DxSwitch(value: widget.value, onChanged: (bool value) => widget.onChanged?.call(value)),
        ],
      ),
    );
  }
}
