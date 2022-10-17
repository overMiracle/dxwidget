import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/utils/index.dart';

const double designSelectionHeight = 268;
const double designBottomHeight = 82;
const double designScreenHeight = 812;

class DxSelectionUtil {
  /// 处理兄弟结点为未选中状态，将自己置为选中状态
  static void processBrotherItemSelectStatus(DxSelectionItem selectionItem) {
    if (DxSelectionType.checkbox == selectionItem.type) {
      selectionItem.isSelected = !selectionItem.isSelected;
      List<DxSelectionItem>? allBrothers = selectionItem.parent?.children;
      if (!DxTools.isEmpty(allBrothers)) {
        for (DxSelectionItem entity in allBrothers!) {
          if (entity != selectionItem) {
            if (entity.type == DxSelectionType.radio) {
              entity.isSelected = false;
            }

            if (entity.type == DxSelectionType.date) {
              entity.isSelected = false;
              entity.value = null;
            }
          }
        }
      }
    }
    if (DxSelectionType.radio == selectionItem.type) {
      selectionItem.parent?.clearChildSelection();
      selectionItem.isSelected = true;
    }

    if (DxSelectionType.date == selectionItem.type) {
      selectionItem.parent?.clearChildSelection();

      /// 日期类型时在外部 Picker 点击确定时设置 选中状态
      selectionItem.isSelected = true;
    }
  }

  /// 筛选项最多不超过三层,故直接写代码判断,本质为深度优先搜索。
  static int getTotalLevel(DxSelectionItem entity) {
    int level = 0;
    DxSelectionItem rootEntity = entity;
    while (rootEntity.parent != null) {
      rootEntity = rootEntity.parent!;
    }

    if (rootEntity.children.isNotEmpty) {
      level = level > 1 ? level : 1;
      for (DxSelectionItem firstLevelEntity in rootEntity.children) {
        if (firstLevelEntity.children.isNotEmpty) {
          level = level > 2 ? level : 2;
          for (DxSelectionItem secondLevelEntity in firstLevelEntity.children) {
            if (secondLevelEntity.children.isNotEmpty) {
              level = 3;
              break;
            }
          }
        }
      }
    }
    return level;
  }

  /// 返回状态为选中的子节点
  static List<DxSelectionItem> currentSelectListForEntity(DxSelectionItem entity) {
    List<DxSelectionItem> list = [];
    for (DxSelectionItem entity in entity.children) {
      if (entity.isSelected) {
        list.add(entity);
      }
    }
    return list;
  }

  /// 判断列表中是否有range类型
  static bool hasRangeItem(List<DxSelectionItem> list) {
    for (DxSelectionItem entity in list) {
      if (DxSelectionType.range == entity.type ||
          DxSelectionType.dateRange == entity.type ||
          DxSelectionType.dateRangeCalendar == entity.type ||
          DxSelectionWindowType.range == entity.filterShowType) {
        return true;
      }
    }
    return false;
  }

  /// 判断列表中是否有range类型
  static DxSelectionItem? getFilledCustomInputItem(List<DxSelectionItem> list) {
    DxSelectionItem? filledCustomInputItem;
    for (DxSelectionItem entity in list) {
      if (entity.isSelected &&
          (DxSelectionType.range == entity.type ||
              DxSelectionType.dateRange == entity.type ||
              DxSelectionType.dateRangeCalendar == entity.type) &&
          entity.customMap != null) {
        filledCustomInputItem = entity;
        break;
      }
      if (entity.children.isNotEmpty) {
        filledCustomInputItem = getFilledCustomInputItem(entity.children);
      }
      if (filledCustomInputItem != null) {
        break;
      }
    }
    return filledCustomInputItem;
  }

  /// 确定当前 Item 在第几层级
  static int getCurrentListIndex(DxSelectionItem? currentItem) {
    int listIndex = -1;
    if (currentItem != null) {
      listIndex = 0;
      var parent = currentItem.parent;
      while (parent != null) {
        listIndex++;
        parent = parent.parent;
      }
    }
    return listIndex;
  }

  ///
  /// [entity] 传入当前点击的 Item
  /// !!! 在设置 isSelected = true之前进行 check。
  /// 返回 true 符合条件，false 不符合条件
  static bool checkMaxSelectionCount(DxSelectionItem entity) {
    return entity.getLimitedRootSelectedChildCount() < entity.getLimitedRootMaxSelectedCount();
  }

//设置数据为未选中状态
  static void resetSelectionData(DxSelectionItem entity) {
    entity.isSelected = false;
    entity.customMap = {};
    for (DxSelectionItem subEntity in entity.children) {
      resetSelectionData(subEntity);
    }
  }
}
