import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// TreeSelect 分类选择
/// 用于从一组相关联的数据集合中进行选择。

class DxTreeSelection extends StatefulWidget {
  /// 左侧宽度
  final double? leftWidth;

  /// 左侧选中项的索引
  final int leftActiveIndex;

  /// 点击左侧导航时触发
  final void Function(int index)? onLeftClick;

  /// 分类显示所需的数据
  final List<DxTreeSelectionItem> treeList;

  /// 自定义右侧区域内容
  final Widget? rightWidget;

  const DxTreeSelection({
    Key? key,
    this.leftWidth,
    this.leftActiveIndex = 0,
    this.onLeftClick,
    this.treeList = const <DxTreeSelectionItem>[],
    this.rightWidget,
  }) : super(key: key);

  @override
  State<DxTreeSelection> createState() => _DxTreeSelectionState();
}

class _DxTreeSelectionState extends State<DxTreeSelection> {
  int $leftActiveIndex = 0;
  @override
  void initState() {
    super.initState();
    $leftActiveIndex = widget.leftActiveIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.leftWidth != null) {
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        SizedBox(width: widget.leftWidth!, child: _buildSidebar()),
        Expanded(
          child: ColoredBox(color: Colors.white, child: widget.rightWidget),
        ),
      ]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        widget.leftWidth != null
            ? SizedBox(width: widget.leftWidth!, child: _buildSidebar())
            : Expanded(flex: 1, child: _buildSidebar()),
        Expanded(
          flex: 2,
          child: ColoredBox(color: Colors.white, child: widget.rightWidget),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    final List<DxSidebarItem> items = widget.treeList.map((DxTreeSelectionItem item) {
      return DxSidebarItem(
        dot: item.dot,
        title: item.text,
        badge: item.badge,
        disabled: item.disabled,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
      );
    }).toList();
    return DxSidebar(
      value: $leftActiveIndex,
      backgroundColor: DxStyle.$F5F5F5,
      onChange: (int index) {
        widget.onLeftClick?.call(index);
        setState(() => $leftActiveIndex = index);
      },
      children: items,
    );
  }
}

class DxTreeSelectionItem {
  int? id;
  bool dot;
  String text;
  String? value;
  String badge;
  bool disabled;

  DxTreeSelectionItem({
    this.id,
    this.dot = false,
    required this.text,
    this.value,
    this.badge = '',
    this.disabled = false,
  });
}
