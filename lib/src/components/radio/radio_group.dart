import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 单选框组
class DxRadioGroup extends StatefulWidget {
  // 选中项的值
  final int? value;

  // 所有选项
  final List<RadioItem> options;

  // 是否禁用所有单选框
  final bool? disabled;

  // 所有单选框的图标大小
  final double? iconSize;

  // 所有单选框的选中状态颜色
  final Color? checkedColor;

  // 布局方式
  final Axis direction;

  // 当绑定值变化时触发的事件
  final Function(int value)? onChanged;

  const DxRadioGroup({
    Key? key,
    this.value,
    required this.options,
    this.disabled,
    this.iconSize,
    this.checkedColor,
    this.direction = Axis.horizontal,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DxRadioGroup> createState() => _DxRadioGroupState();
}

class _DxRadioGroupState extends State<DxRadioGroup> {
  int? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  List<Widget> buildItems() {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.options.length; i++) {
      RadioItem item = widget.options[i];
      Widget radio = DxRadio(
        value: _value == item.value,
        text: item.text,
        disabled: widget.disabled ?? item.disabled,
        iconSize: widget.iconSize ?? item.iconSize,
        checkedColor: widget.checkedColor ?? item.checkedColor,
        onChanged: (val) {
          setState(() => _value = item.value);
          widget.onChanged?.call(_value!);
        },
      );
      widgets.add(radio);

      if (i < widget.options.length - 1) {
        widget.direction == Axis.horizontal
            ? widgets.add(const SizedBox(width: 20))
            : widgets.add(const SizedBox(height: DxStyle.intervalLg));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return widget.direction == Axis.horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[...buildItems()],
          )
        : Column(children: <Widget>[...buildItems()]);
  }
}

class RadioItem {
  final int? value;
  final String? text;
  final bool disabled;
  final String shape;
  final double iconSize;
  final Color checkedColor;

  RadioItem({
    this.value,
    this.text,
    this.disabled = false,
    this.shape = 'round',
    this.iconSize = DxStyle.checkboxSize,
    this.checkedColor = DxStyle.checkboxCheckedIconColor,
  });
}
