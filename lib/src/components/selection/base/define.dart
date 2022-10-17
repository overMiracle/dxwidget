import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/utils/index.dart';

//用于处理 重置事件
class ClearEvent {}

typedef DxOnMenuItemClick = bool Function(int index);

typedef DxOnRangeSelectionConfirm = void Function(
    DxSelectionItem results, int firstIndex, int secondIndex, int thirdIndex);

typedef DxSingleListItemSelect = void Function(int listIndex, int index, DxSelectionItem item);

typedef RangeChangedCallback = void Function(String minInput, String maxInput);

/// 配置 类型为 Range 展示时，每行 tag 的数量
/// [index] 第几个 menu
/// [entity] index 对应的 筛选对象
typedef DxConfigTagCountPerRow = Function(int index, DxSelectionItem entity);

/// [menuTitle] 设置自定义 menu 的Title文案
/// [isMenuTitleHighLight] 设置自定义 menu 的 title 是否高亮
typedef DxSetCustomSelectionMenuTitle = void Function({String menuTitle, bool isMenuTitleHighLight});

typedef DxOnSelectionChanged = void Function(
  int menuIndex,
  Map<String, String> selectedParams,
  Map<String, String> customParams,
  DxSetCustomSelectionMenuTitle setCustomMenuTitle,
);

/// menu 点击拦截回调
/// [index] menu 的索引位置
/// 返回 true 拦截点击方法，false 不拦截
typedef DxOnMenuItemInterceptor = bool Function(int index);

/// 筛选弹窗打开前的回调方法。
typedef DxOnSelectionPreShow = DxSelectionWindowType Function(int index, DxSelectionItem entity);

/// 点击【更多】筛选项时的回调，
/// [index] 为点击的位置，
/// [openMorePage] 为让用户触发的回调用于展开更多筛选页面
typedef DxOnMoreSelectionMenuClick = void Function(int index, DxOpenMorePage openMorePage);

/// 打开更多筛选页面，
/// [updateData] 是否要更新更多筛选的数据，
/// [moreSelections] 最新的更多筛选数据，是否更新取决于 [updateData]
typedef DxOpenMorePage = void Function({bool updateData, List<DxSelectionItem> moreSelections});

/// 自定义类型的 Menu 被点击时 让外部设置选中的 value 进来统一更新 UI，并将 function 传给外部设置筛选值。
typedef DxSetCustomSelectionParams = void Function(Map<String, String> customParams);

/// 自定义类型的 menu 被点击的回调，
/// [index] 点击位置，
/// [customMenuItem] 自定义筛选 menu 原始数据，
/// [customSelectionParams] 开放给外部回调给函数，用于更新自定义筛选参数，触发[DxOnSelectionChanged]。
typedef DxOnCustomSelectionMenuClick = Function(
    int index, DxSelectionItem customMenuItem, DxSetCustomSelectionParams customSelectionParams);

/// 当更多筛选页面中，类型为 CustomLayer 被回调时，该函数用于回传参数进 DxSelectionView 中，
/// [customParams] 用户自定义参数。
typedef DxSetCustomFloatingLayerSelectionParams = void Function(List<DxSelectionItem> customParams);

/// 类型为 CustomLayer 被点击的回调
/// [index] 被点击的位置
/// [customFloatingLayerEntity] 被点击 index 位置的筛选数据
/// [setCustomFloatingLayerSelectionParams] 外部自定义参数回传函数
typedef DxOnCustomFloatingLayerClick = Function(int index, DxSelectionItem customFloatingLayerEntity,
    DxSetCustomFloatingLayerSelectionParams setCustomFloatingLayerSelectionParams);

typedef OnDefaultParamsPrepared = void Function(Map<String, String> selectedParams);
typedef DxSimpleSelectionOnSelectionChanged = void Function(List<DxSelectionItem> selectedParams);

enum DxSelectionType {
  /// 未设置
  none,

  /// 不限类型
  unLimited,

  /// 单选列表、单选项 type 为 radio
  radio,

  /// 多选列表、多选项 type 为 checkbox
  checkbox,

  /// 一般的值范围自定义区间 type 为 range
  range,

  /// 日期选择,普通筛选时使用 CalendarView 展示选择时间，更多情况下使用 DatePicker 选择时间
  date,

  /// 自定义选择日期区间， type 为 dateRange
  dateRange,

  /// 自定义通过 Calendar 选择日期区间，type 为 dateRangeCalendar
  dateRangeCalendar,

  /// 标签筛选 type 为 customerTag
  customHandle,

  /// 更多列表、多选项 无 type
  more,

  /// 去二级页面
  layer,

  /// 去自定义二级页面
  customLayer,
}

/// 筛选弹窗展示风格
enum DxSelectionWindowType {
  /// 列表类型,使用列表 Item 展示
  list,

  /// 值范围类型,使用 Tag + Range 的 Item 展示
  range,
}

class DxFilterItem {
  String? key;
  String name;
  String? value;

  DxFilterItem({this.key, this.name = '', this.value});

  DxFilterItem.fromJson(Map<String, dynamic> map) : name = '' {
    key = map['key'] ?? '';
    name = map['title'] ?? '';
    value = map['value'] ?? '';
  }
}

class DxSelectionItem {
  /// 类型 是单选、复选还是有自定义输入
  DxSelectionType type;

  /// 显示的文案
  String title;

  /// 显示的副文案
  String? subTitle;

  /// 回传给服务器的 key
  String? key;

  /// 回传给服务器的 value
  String? value;

  /// 默认值
  String? defaultValue;

  /// 扩展字段，目前只有min和max
  Map extMap;

  /// 子筛选项
  List<DxSelectionItem> children;

  /// 是否选中
  bool isSelected;

  /// 自定义输入
  Map<String, String>? customMap;

  /// 用于临时存储原有自定义字段数据，在筛选数据变化后未点击【确定】按钮时还原。
  late Map originalCustomMap;

  /// 最大可选数量
  int maxSelectedCount;

  /// 父级筛选项
  DxSelectionItem? parent;

  /// 筛选弹窗展示风格对应的首字母小写的字符串，例如 `range`、`list`，参见 [DxSelectionWindowType]
  String? showType;

  /// 筛选弹窗展示风格，具体参见 [DxSelectionWindowType]
  DxSelectionWindowType? filterShowType;

  /// 自定义标题
  String? customTitle;

  ///自定义筛选的 title 是否高亮
  bool isCustomTitleHighLight;

  /// 临时字段用于判断是否要将筛选项 [name] 字段拼接展示
  bool canJoinTitle = false;

  DxSelectionItem({
    this.key,
    this.value,
    this.defaultValue,
    this.title = '',
    this.subTitle,
    this.children = const [],
    this.isSelected = false,
    this.extMap = const {},
    this.customMap,
    this.type = DxSelectionType.none,
    this.showType,
    this.isCustomTitleHighLight = false,
    this.maxSelectedCount = 65536,
  }) {
    filterShowType = parserShowType(showType);
    originalCustomMap = {};
  }

  /// 构造简单筛选数据
  DxSelectionItem.simple({
    this.key,
    this.value,
    this.title = '',
    this.type = DxSelectionType.none,
  })  : maxSelectedCount = 65535,
        isCustomTitleHighLight = false,
        isSelected = false,
        children = [],
        extMap = {} {
    filterShowType = parserShowType(showType);
    originalCustomMap = {};
    isSelected = false;
  }

  /// 建议使用 [DxSelectionItem.fromJson]
  static DxSelectionItem fromMap(Map<String, dynamic> map) {
    DxSelectionItem entity = DxSelectionItem();
    entity.title = map['title'] ?? '';
    entity.subTitle = map['subTitle'] ?? '';
    entity.key = map['key'] ?? '';
    entity.type = map['type'] ?? DxSelectionType.none;
    entity.defaultValue = map['defaultValue'] ?? "";
    entity.value = map['value'] ?? "";
    if (map['maxSelectedCount'] != null && int.tryParse(map['maxSelectedCount']) != null) {
      entity.maxSelectedCount = int.tryParse(map['maxSelectedCount']) ?? 65535;
    } else {
      entity.maxSelectedCount = 65535;
    }
    entity.extMap = map['ext'] ?? {};
    if (map['children'] != null && map['children'] is List) {
      entity.children = [...(map['children'] as List).map((o) => DxSelectionItem.fromMap(o))];
    }
    return entity;
  }

  DxSelectionItem.fromJson(Map<dynamic, dynamic>? map)
      : title = '',
        type = DxSelectionType.none,
        maxSelectedCount = 65535,
        isCustomTitleHighLight = false,
        isSelected = false,
        children = [],
        extMap = {} {
    if (map == null) return;
    title = map['title'] ?? '';
    subTitle = map['subTitle'] ?? '';
    key = map['key'] ?? '';
    type = map['type'] ?? DxSelectionType.none;
    defaultValue = map['defaultValue'] ?? '';
    value = map['value'] ?? '';
    if (map['maxSelectedCount'] != null && int.tryParse(map['maxSelectedCount']) != null) {
      maxSelectedCount = int.tryParse(map['maxSelectedCount']) ?? 65535;
    }
    extMap = map['ext'] ?? {};
    children = [...(map['children'] ?? []).map((o) => DxSelectionItem.fromJson(o))];
    isSelected = false;
  }

  void configRelationshipAndDefaultValue() {
    configRelationship();
    configDefaultValue();
  }

  void configRelationship() {
    if (children.isNotEmpty) {
      for (DxSelectionItem entity in children) {
        entity.parent = this;
      }
      for (DxSelectionItem entity in children) {
        entity.configRelationship();
      }
    }
  }

  void configDefaultValue() {
    if (children.isNotEmpty) {
      for (DxSelectionItem entity in children) {
        if (!DxTools.isEmpty(defaultValue)) {
          List<String> values = defaultValue!.split(',');
          entity.isSelected = values.contains(entity.value);
        }
      }

      /// 当 default 不在普通 Item 类型中时，尝试填充 同级别 Range Item.
      if (children.where((_) => _.isSelected).toList().isEmpty) {
        List<DxSelectionItem> rangeItems = children.where((_) {
          return (_.type == DxSelectionType.range ||
              _.type == DxSelectionType.dateRange ||
              _.type == DxSelectionType.dateRangeCalendar);
        }).toList();
        DxSelectionItem? rangeEntity;
        if (rangeItems.isNotEmpty) {
          rangeEntity = rangeItems[0];
        }
        if (rangeEntity != null && !DxTools.isEmpty(defaultValue)) {
          List<String> values = defaultValue!.split(':');
          if (values.length == 2 && int.tryParse(values[0]) != null && int.tryParse(values[1]) != null) {
            rangeEntity.customMap = {};
            rangeEntity.customMap = {"min": values[0], "max": values[1]};
            rangeEntity.isSelected = true;
          }
        }
      }

      for (DxSelectionItem entity in children) {
        entity.configDefaultValue();
      }
      if (hasCheckBoxBrother()) {
        isSelected = children.where((_) => _.isSelected).isNotEmpty;
      } else {
        isSelected = isSelected || children.where((_) => _.isSelected).isNotEmpty;
      }
    }
  }

  DxSelectionWindowType parserShowType(String? showType) {
    if (showType == 'list') {
      return DxSelectionWindowType.list;
    } else if (showType == 'range') {
      return DxSelectionWindowType.range;
    }
    return DxSelectionWindowType.list;
  }

  void clearChildSelection() {
    if (children.isNotEmpty) {
      for (DxSelectionItem entity in children) {
        entity.isSelected = false;
        if (entity.type == DxSelectionType.date) {
          entity.value = null;
        }
        if (entity.type == DxSelectionType.range ||
            entity.type == DxSelectionType.dateRange ||
            entity.type == DxSelectionType.dateRangeCalendar) {
          entity.customMap = {};
        }
        entity.clearChildSelection();
      }
    }
  }

  List<DxSelectionItem> selectedLastColumnList() {
    List<DxSelectionItem> list = [];
    if (children.isNotEmpty) {
      List<DxSelectionItem> firstList = [];
      for (DxSelectionItem firstEntity in children) {
        if (firstEntity.children.isNotEmpty) {
          List<DxSelectionItem> secondList = [];
          for (DxSelectionItem secondEntity in firstEntity.children) {
            if (secondEntity.children.isNotEmpty) {
              List<DxSelectionItem> thirds = DxSelectionUtil.currentSelectListForEntity(secondEntity);
              if (thirds.isNotEmpty) {
                list.addAll(thirds);
              } else if (secondEntity.isSelected) {
                secondList.add(secondEntity);
              }
            } else if (secondEntity.isSelected) {
              secondList.add(secondEntity);
            }
          }
          list.addAll(secondList);
        } else if (firstEntity.isSelected) {
          firstList.add(firstEntity);
        }
      }
      list.addAll(firstList);
    }
    return list;
  }

  List<DxSelectionItem> selectedListWithoutUnlimited() {
    List<DxSelectionItem> selected = selectedList();
    return selected
        .where((_) => !_.isUnLimit())
        .where((_) =>
            (_.type != DxSelectionType.range) || (_.type == DxSelectionType.range && !DxTools.isEmpty(_.customMap)))
        .where((_) =>
            (_.type != DxSelectionType.dateRange) ||
            (_.type == DxSelectionType.dateRange && !DxTools.isEmpty(_.customMap)))
        .where((_) =>
            (_.type != DxSelectionType.dateRangeCalendar) ||
            (_.type == DxSelectionType.dateRangeCalendar && !DxTools.isEmpty(_.customMap)))
        .toList();
  }

  List<DxSelectionItem> selectedList() {
    if (DxSelectionType.more == type) {
      return selectedLastColumnList();
    } else {
      List<DxSelectionItem> results = [];
      List<DxSelectionItem> firstColumn = DxSelectionUtil.currentSelectListForEntity(this);
      results.addAll(firstColumn);
      if (firstColumn.isNotEmpty) {
        for (DxSelectionItem firstEntity in firstColumn) {
          List<DxSelectionItem> secondColumn = DxSelectionUtil.currentSelectListForEntity(firstEntity);
          results.addAll(secondColumn);
          if (secondColumn.isNotEmpty) {
            for (DxSelectionItem secondEntity in secondColumn) {
              List<DxSelectionItem> thirdColumn = DxSelectionUtil.currentSelectListForEntity(secondEntity);
              results.addAll(thirdColumn);
            }
          }
        }
      }
      return results;
    }
  }

  List<DxSelectionItem> allSelectedList() {
    List<DxSelectionItem> results = [];
    List<DxSelectionItem> firstColumn = DxSelectionUtil.currentSelectListForEntity(this);
    results.addAll(firstColumn);
    if (firstColumn.isNotEmpty) {
      for (DxSelectionItem firstEntity in firstColumn) {
        List<DxSelectionItem> secondColumn = DxSelectionUtil.currentSelectListForEntity(firstEntity);
        results.addAll(secondColumn);
        if (secondColumn.isNotEmpty) {
          for (DxSelectionItem secondEntity in secondColumn) {
            List<DxSelectionItem> thirdColumn = DxSelectionUtil.currentSelectListForEntity(secondEntity);
            results.addAll(thirdColumn);
          }
        }
      }
    }
    return results;
  }

  int getLimitedRootSelectedChildCount() {
    return getSelectedChildCount(getRootEntity(this));
  }

  int getLimitedRootMaxSelectedCount() {
    return getRootEntity(this).maxSelectedCount;
  }

  DxSelectionItem getRootEntity(DxSelectionItem rootEntity) {
    if (rootEntity.parent == null || rootEntity.parent!.maxSelectedCount == 65535) {
      return rootEntity;
    } else {
      return getRootEntity(rootEntity.parent!);
    }
  }

  /// 返回最后一层级【选中状态】 Item 的 个数
  int getSelectedChildCount(DxSelectionItem entity) {
    if (DxTools.isEmpty(entity.children)) {
      return entity.isSelected ? 1 : 0;
    }

    int count = 0;
    for (DxSelectionItem child in entity.children) {
      count += getSelectedChildCount(child);
    }
    return count;
  }

  /// 判断当前的筛选 Item 是否为当前层次中第一个被选中的 Item。
  /// 用于展开筛选弹窗时显示选中效果。
  int getIndexInCurrentLevel() {
    if (parent == null || parent!.children.isEmpty) return -1;

    for (DxSelectionItem entity in parent!.children) {
      if (entity == this) {
        return parent!.children.indexOf(entity);
      }
    }
    return -1;
  }

  /// 是否在筛选数据的最后一层。 如果最大层次为 3；某个筛选数据层次为 2，但其无子节点。此时认为不在最后一层。
  bool isInLastLevel() {
    if (parent == null || parent!.children.isEmpty) return true;

    for (DxSelectionItem entity in parent!.children) {
      if (entity.children.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  /// 检查自己的兄弟结点是否存在 checkbox 类型。
  bool hasCheckBoxBrother() {
    int? count = parent?.children.where((f) => f.type == DxSelectionType.checkbox).length;
    return count == null ? false : count > 0;
  }

  /// 在这里简单认为 value 为空【null 或 ''】时为 unLimited.
  bool isUnLimit() => type == DxSelectionType.unLimited;

  void clearSelectedEntity() {
    List<DxSelectionItem> tmp = [];
    DxSelectionItem node = this;
    tmp.add(node);
    while (tmp.isNotEmpty) {
      node = tmp.removeLast();
      node.isSelected = false;
      for (var data in node.children) {
        tmp.add(data);
      }
    }
  }

  List<DxSelectionItem> currentTagListForEntity() {
    List<DxSelectionItem> list = [];
    for (var data in children) {
      if (data.type != DxSelectionType.range &&
          data.type != DxSelectionType.dateRange &&
          data.type != DxSelectionType.dateRangeCalendar) {
        list.add(data);
      }
    }
    return list;
  }

  List<DxSelectionItem> currentShowTagByExpanded(bool isExpanded) {
    List<DxSelectionItem> all = currentTagListForEntity();
    return isExpanded ? all : all.sublist(0, currentDefaultTagCountForEntity());
  }

  /// 最终显示tag个数
  int currentDefaultTagCountForEntity() {
    return currentTagListForEntity().length > getDefaultShowCount()
        ? getDefaultShowCount()
        : currentTagListForEntity().length;
  }

  /// 默认展示个数是否大于总tag个数
  bool isOverCurrentTagListSize() {
    return getDefaultShowCount() > currentTagListForEntity().length;
  }

  /// 接口返回默认展示tag个数
  int getDefaultShowCount() {
    int defaultShowCount = 3;
    if (extMap.containsKey('defaultShowCount')) {
      defaultShowCount = extMap['defaultShowCount'] ?? defaultShowCount;
    }
    return defaultShowCount;
  }

  List<DxSelectionItem> currentRangeListForEntity() {
    List<DxSelectionItem> list = [];
    for (var data in children) {
      if (data.type == DxSelectionType.range ||
          data.type == DxSelectionType.dateRange ||
          data.type == DxSelectionType.dateRangeCalendar) {
        list.add(data);
      }
    }
    return list;
  }

  bool isValidRange() {
    if (type == DxSelectionType.range ||
        type == DxSelectionType.dateRange ||
        type == DxSelectionType.dateRangeCalendar) {
      DateTime minTime = DateTime.parse(datePickerMinDatetime);
      DateTime maxTime = DateTime.parse(datePickerMaxDatetime);
      int limitMin = int.tryParse(extMap['min']?.toString() ?? "") ??
          (type == DxSelectionType.dateRange || type == DxSelectionType.dateRangeCalendar
              ? minTime.millisecondsSinceEpoch
              : 0);
      // 日期最大值没设置 默认是2121年01月01日 08:00:00
      int limitMax = int.tryParse(extMap['max']?.toString() ?? "") ??
          (type == DxSelectionType.dateRange || type == DxSelectionType.dateRangeCalendar
              ? maxTime.millisecondsSinceEpoch
              : 9999);

      if (customMap != null && customMap!.isNotEmpty) {
        String min = customMap!['min'] ?? "";
        String max = customMap!['max'] ?? "";
        if (min.isEmpty && max.isEmpty) {
          return true;
        }
        int? inputMin = int.tryParse(customMap!['min'] ?? "");
        int? inputMax = int.tryParse(customMap!['max'] ?? "");

        if (inputMax != null && inputMin != null) {
          if (inputMin >= limitMin && inputMax <= limitMax && inputMax >= inputMin) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return true;
  }

  void reverseSelected() => isSelected = !isSelected;

  int getFirstSelectedChildIndex() {
    return children.indexWhere((data) {
      return data.isSelected;
    });
  }
}
