import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 复选框
/// 在一组备选项中进行多选
class DxCheckboxGroup<T extends dynamic> extends StatelessWidget {
  /// 最大选择数量
  final int max;

  /// 是否禁用
  final bool disabled;

  /// 方向
  final Axis direction;

  /// 图标大小
  final double? iconSize;

  /// 选中颜色
  final Color? checkedColor;

  /// 值
  final List<T> value;

  /// 选中事件
  final ValueChanged<List<T>>? onChange;

  /// 子元素
  final List<Widget> children;

  const DxCheckboxGroup({
    Key? key,
    this.max = 99999,
    this.disabled = false,
    this.direction = Axis.vertical,
    this.iconSize,
    this.checkedColor,
    required this.value,
    this.onChange,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DxCheckBoxScope(
      parent: this,
      child: Flex(
        direction: direction,
        children: children,
      ),
    );
  }

  void toggleAll({
    bool? checked,
    bool skipDisabled = false,
  }) {
    final List<DxCheckbox<T>> checkedChildren =
        children.whereType<DxCheckbox<T>>().toList().where((DxCheckbox<T> item) {
      // ignore: unnecessary_type_check
      if (item is! DxCheckbox<T>) {
        return false;
      }

      if (!item.bindGroup) {
        return false;
      }
      if (item.disabled && skipDisabled) {
        return value.contains(item.name);
      }

      return checked ?? !value.contains(item.name);
    }).toList();
    final List<T> names = checkedChildren.map((DxCheckbox<T> e) => e.name as T).toList();
    updateValue(names);
  }

  void updateValue(List<T> value) => onChange?.call(value);
}

class DxCheckBoxScope extends InheritedWidget {
  const DxCheckBoxScope({
    Key? key,
    required this.parent,
    required Widget child,
  }) : super(key: key, child: child);

  final DxCheckboxGroup parent;

  static DxCheckBoxScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DxCheckBoxScope>();
  }

  @override
  bool updateShouldNotify(DxCheckBoxScope oldWidget) {
    return parent != oldWidget.parent;
  }
}
