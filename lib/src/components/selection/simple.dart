import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/components/selection/view.dart';
import 'package:flutter/material.dart';

const String _defaultMenuKey = "defaultMenuKey";

class DxSimpleSelection extends StatefulWidget {
  /// 标题文案
  final String menuName;

  /// 回传给服务端key
  final String menuKey;

  /// 默认选中选项值
  final String? defaultValue;

  /// 选项列表
  final List<DxSelectionItem> items;

  /// 选择回调
  final DxSimpleSelectionOnSelectionChanged onSimpleSelectionChanged;

  /// 菜单点击事件
  final Function? onMenuItemClick;

  /// 是否单选  默认 radio模式 is true ， checkbox模式 is false
  final bool isRadio;

  /// 单选构造函数
  const DxSimpleSelection.radio({
    Key? key,
    required this.menuName,
    this.menuKey = _defaultMenuKey,
    this.defaultValue,
    required this.items,
    required this.onSimpleSelectionChanged,
    this.onMenuItemClick,
  })  : isRadio = true,
        super(key: key);

  /// 多选构造函数
  const DxSimpleSelection.checkbox({
    Key? key,
    required this.menuName,
    this.menuKey = _defaultMenuKey,
    this.defaultValue,
    required this.items,
    required this.onSimpleSelectionChanged,
    this.onMenuItemClick,
  })  : isRadio = false,
        super(key: key);

  @override
  State<DxSimpleSelection> createState() => _DxSimpleSelectionState();
}

class _DxSimpleSelectionState extends State<DxSimpleSelection> {
  late List<DxSelectionItem> selectionItemList;

  @override
  void initState() {
    super.initState();
    selectionItemList = _convertFilterToDxSelection();
  }

  /// 将筛选数据转换成通用筛选数据
  List<DxSelectionItem> _convertFilterToDxSelection() {
    List<DxSelectionItem> list = [];
    if (widget.items.isNotEmpty) {
      List<DxSelectionItem> children = [];
      for (var filter in widget.items) {
        children.add(
          DxSelectionItem.simple(
            key: filter.key,
            value: filter.value,
            title: filter.title,
            type: widget.isRadio ? DxSelectionType.radio : DxSelectionType.checkbox,
          ),
        );
      }

      list.add(
        DxSelectionItem(
          key: widget.menuKey,
          title: widget.menuName,
          type: widget.isRadio ? DxSelectionType.radio : DxSelectionType.checkbox,
          defaultValue: widget.defaultValue,
          children: children,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DxSelectionView(
      originalSelectionData: selectionItemList,
      onSelectionChanged: (menuIndex, selectedParams, customParams, setCustomTitleFunction) {
        List<DxSelectionItem> results = [];
        String valueStr = selectedParams[widget.menuKey] ?? '';
        List<String> values = valueStr.split(',');

        ///遍历获取选中的items
        for (String value in values) {
          for (DxSelectionItem item in widget.items) {
            if (item.value != null && item.value == value) {
              results.add(item);
              break;
            }
          }
        }
        widget.onSimpleSelectionChanged(results);
      },
      onMenuClickInterceptor: (index) {
        widget.onMenuItemClick?.call();
        return false;
      },
    );
  }
}
