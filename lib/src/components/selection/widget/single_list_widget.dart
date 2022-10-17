import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DxSelectionSingleListWidget extends StatefulWidget {
  late List<DxSelectionItem> _selectedItems;
  late int currentListIndex;

  List<DxSelectionItem> items;
  int flex;
  int focusedIndex;
  double maxHeight;

  Color? backgroundColor;
  Color? selectedBackgroundColor;
  DxSingleListItemSelect? singleListItemSelect;

  DxSelectionThemeData themeData;

  DxSelectionSingleListWidget({
    Key? key,
    required this.items,
    required this.flex,
    this.focusedIndex = -1,
    this.maxHeight = 0,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.singleListItemSelect,
    required this.themeData,
  }) : super(key: key) {
    items = items
        .where((_) =>
            _.type != DxSelectionType.range &&
            _.type != DxSelectionType.date &&
            _.type != DxSelectionType.dateRange &&
            _.type != DxSelectionType.dateRangeCalendar)
        .toList();

    /// 当前 Items 所在的层级
    currentListIndex = DxSelectionUtil.getCurrentListIndex(items.isNotEmpty ? items[0] : null);
    _selectedItems = items.where((f) => f.isSelected).toList();
  }

  @override
  State<DxSelectionSingleListWidget> createState() => _DxSelectionSingleListWidgetState();
}

class _DxSelectionSingleListWidgetState extends State<DxSelectionSingleListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Container(
        constraints:
            (widget.maxHeight == 0) ? const BoxConstraints.expand() : BoxConstraints(maxHeight: widget.maxHeight),
        color: widget.backgroundColor,
        child: ScrollConfiguration(
          behavior: DxNoScrollBehavior(),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: widget.items.length,
            separatorBuilder: (BuildContext context, int index) => Container(),
            itemBuilder: (BuildContext context, int index) {
              DxSelectionItem item = widget.items[index];

              /// 点击筛选，展开弹窗时，默认展示上次选中的筛选项。
              bool isCurrentFocused = isItemFocused(index, item);

              return DxSelectionCommonItemWidget(
                item: item,
                themeData: widget.themeData,
                backgroundColor: widget.backgroundColor,
                selectedBackgroundColor: widget.selectedBackgroundColor,
                isCurrentFocused: isCurrentFocused,
                isMoreSelectionListType: false,
                isFirstLevel: (1 == widget.currentListIndex) ? true : false,
                itemSelectFunction: (DxSelectionItem entity) {
                  _processFilterData(entity);
                  widget.singleListItemSelect?.call(widget.currentListIndex, index, entity);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  bool isItemFocused(int itemIndex, DxSelectionItem item) {
    bool isFocused = widget.focusedIndex == itemIndex;
    if (!isFocused && item.isSelected && item.isInLastLevel()) {
      isFocused = true;
    }
    return isFocused;
  }

  /// Item 点击之后的数据处理
  void _processFilterData(DxSelectionItem selectedEntity) {
    int totalLevel = DxSelectionUtil.getTotalLevel(selectedEntity);
    if (selectedEntity.isUnLimit()) {
      selectedEntity.parent?.clearChildSelection();
    }

    /// 设置选中数据。
    /// 当选中的数据不是最后一列时，相当于不选中数据
    /// 当选中为不限类型时，不再设置选中状态。
    if (totalLevel == 1) {
      configOneLevelList(selectedEntity);
    } else {
      configMultiLevelList(selectedEntity, widget.currentListIndex);
    }

    /// Warning !!!
    /// （两列、三列时）第一列节点是否被选中取决于它的子节点是否被选中，
    /// 只有当它子节点被选中时才会认为第一列的节点相应被选中。
    if (widget.items.isNotEmpty) {
      widget.items[0].parent?.isSelected =
          (widget.items[0].parent?.children.where((DxSelectionItem f) => f.isSelected).length ?? 0) > 0;
    }

    for (DxSelectionItem item in widget.items) {
      if (item.isSelected) {
        if (!widget._selectedItems.contains(item)) {
          widget._selectedItems.add(item);
        }
      } else {
        if (widget._selectedItems.contains(item)) {
          widget._selectedItems.remove(item);
        }
      }
    }
  }

  void configOneLevelList(DxSelectionItem selectedEntity) {
    if (DxSelectionType.radio == selectedEntity.type) {
      /// 单选，清除同一级别选中的状态，则其他的设置为未选中。
      selectedEntity.parent?.clearChildSelection();
      selectedEntity.isSelected = true;
    } else if (DxSelectionType.checkbox == selectedEntity.type) {
      /// 选中【不限】清除同一级别其他的状态
      if (selectedEntity.isUnLimit()) {
        selectedEntity.parent?.clearChildSelection();
        selectedEntity.isSelected = true;
      } else {
        ///清除【不限】类型。
        List<DxSelectionItem> brotherItems;
        if (selectedEntity.parent == null) {
          brotherItems = widget.items;
        } else {
          brotherItems = selectedEntity.parent?.children ?? [];
        }
        for (DxSelectionItem entity in brotherItems) {
          if (entity.isUnLimit()) {
            entity.isSelected = false;
          }
        }
        selectedEntity.isSelected = !selectedEntity.isSelected;
      }
    }
  }

  void configMultiLevelList(DxSelectionItem selectedEntity, int currentListIndex) {
    /// 选中【不限】清除同一级别其他的状态
    if (selectedEntity.isUnLimit()) {
      selectedEntity.parent?.children.where((f) => f != selectedEntity).forEach((f) {
        f.clearChildSelection();
        f.isSelected = false;
      });
      selectedEntity.isSelected = true;
    } else if (DxSelectionType.radio == selectedEntity.type) {
      /// 单选，清除同一级别选中的状态，则其他的设置为未选中。
      selectedEntity.parent?.children.where((f) => f != selectedEntity).forEach((f) {
        f.clearChildSelection();
        f.isSelected = false;
      });
      selectedEntity.isSelected = true;
    } else if (DxSelectionType.checkbox == selectedEntity.type) {
      ///清除【不限】类型。
      List<DxSelectionItem> brotherItems;
      if (selectedEntity.parent == null) {
        brotherItems = widget.items;
      } else {
        brotherItems = selectedEntity.parent?.children ?? [];
      }
      for (DxSelectionItem entity in brotherItems) {
        if (entity.isUnLimit()) {
          entity.clearChildSelection();
          entity.isSelected = false;
        }
      }
      selectedEntity.isSelected = !selectedEntity.isSelected;
    }
  }
}
