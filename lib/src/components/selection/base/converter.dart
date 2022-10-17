import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/utils/index.dart';

abstract class DxSelectionConverterDelegate {
  /// 统一的数据结构 转换为 用户需要的数据结构，并通过 [DxSelectionOnSelectionChanged] 回传给用户使用。
  Map<String, String> convertSelectedData(List<DxSelectionItem> selectedResults);
}

class DefaultSelectionConverter implements DxSelectionConverterDelegate {
  const DefaultSelectionConverter();

  @override
  Map<String, String> convertSelectedData(List<DxSelectionItem> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

class DefaultMoreSelectionConverter implements DxSelectionConverterDelegate {
  const DefaultMoreSelectionConverter();

  @override
  Map<String, String> convertSelectedData(List<DxSelectionItem> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

class DefaultSelectionQuickFilterConverter implements DxSelectionConverterDelegate {
  const DefaultSelectionQuickFilterConverter();

  @override
  Map<String, String> convertSelectedData(List<DxSelectionItem> selectedResults) {
    return getSelectionParams(selectedResults);
  }
}

/// 注意，此方法仅在初始化筛选项之前调用。如果再筛选之后使用会影响筛选View 的展示以及筛选结果。
Map<String, String> getSelectionParamsWithConfigChild(List<DxSelectionItem>? selectedResults) {
  Map<String, String> params = {};
  if (selectedResults == null) return params;
  for (var f in selectedResults) {
    f.configRelationshipAndDefaultValue();
  }
  return getSelectionParams(selectedResults);
}

Map<String, String> getSelectionParams(List<DxSelectionItem>? selectedResults) {
  Map<String, String> params = {};
  if (selectedResults == null) return params;
  for (DxSelectionItem menuItemEntity in selectedResults) {
    if (menuItemEntity.type == DxSelectionType.more) {
      params.addAll(getSelectionParams(menuItemEntity.children));
    } else {
      /// 1、首先找出 自定义范围的筛选项参数。
      DxSelectionItem? selectedCustomInputItem = DxSelectionUtil.getFilledCustomInputItem(menuItemEntity.children);
      if (selectedCustomInputItem != null && !DxTools.isEmpty(selectedCustomInputItem.customMap)) {
        String? key = selectedCustomInputItem.parent?.key;
        if (!DxTools.isEmpty(key)) {
          params[key!] =
              '${selectedCustomInputItem.customMap!['min'] ?? ''}:${selectedCustomInputItem.customMap!['max'] ?? ''}';
        }
      }

      /// 2、一次找出层级为 1、2、3 的选中项的参数，递归不好阅读，直接写成 for 嵌套遍历。
      int levelCount = DxSelectionUtil.getTotalLevel(menuItemEntity);
      if (levelCount == 1) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
      } else if (levelCount == 2) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
        for (var firstLevelItem in menuItemEntity.children) {
          params.addAll(getCurrentSelectionEntityParams(firstLevelItem));
        }
      } else if (levelCount == 3) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity));
        for (var firstLevelItem in menuItemEntity.children) {
          params.addAll(getCurrentSelectionEntityParams(firstLevelItem));
          for (var secondLevelItem in firstLevelItem.children) {
            params.addAll(getCurrentSelectionEntityParams(secondLevelItem));
          }
        }
      }
    }
  }
  return params;
}

Map<String, String> getCurrentSelectionEntityParams(DxSelectionItem selectionEntity) {
  Map<String, String> params = {};
  String? parentKey = selectionEntity.key;
  List<String?> selectedEntity = selectionEntity.children
      .where((DxSelectionItem f) => f.isSelected)
      .where((DxSelectionItem f) => !DxTools.isEmpty(f.value))
      .map((DxSelectionItem f) => f.value)
      .toList();
  String selectedParams = selectedEntity.isEmpty ? '' : selectedEntity.join(',');
  if (!DxTools.isEmpty(selectedParams) && !DxTools.isEmpty(parentKey)) {
    params[parentKey!] = selectedParams;
  }
  return params;
}
