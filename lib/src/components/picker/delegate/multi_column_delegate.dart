import 'package:dxwidget/src/components/picker/bottom_picker.dart';
import 'package:dxwidget/src/components/picker/delegate/abstract_delegate.dart';

/// 多列选择代理
class DxMultiColumnDataPickerDelegate implements DxMultiAbstractDelegate {
  /// 几列
  final int columnNum;

  /// 列表数据，格式为id，name，pid，child
  List<DxPickerItem> items;

  /// 第一列选中的值
  final int firstSelectedId;

  /// 第二列选中的值
  final int secondSelectedId;

  /// 第三列选中的值
  final int thirdSelectedId;

  int _firstSelectedIndex = 0;
  int _secondSelectedIndex = 0;
  int _thirdSelectedIndex = 0;

  DxMultiColumnDataPickerDelegate({
    required this.columnNum,
    required this.items,
    this.firstSelectedId = 0,
    this.secondSelectedId = 0,
    this.thirdSelectedId = 0,
  }) : assert(columnNum <= 3 && columnNum >= 1, 'columnNum只能为1，2，3') {
    _firstSelectedIndex = _getListIndexById(items, firstSelectedId);
    List<DxPickerItem>? secondList = items.elementAt(_firstSelectedIndex).child;
    _secondSelectedIndex = _getListIndexById(secondList, secondSelectedId);
    List<DxPickerItem>? thirdList = secondList?.elementAt(_secondSelectedIndex).child;
    _thirdSelectedIndex = _getListIndexById(thirdList, thirdSelectedId);
  }

  /// 数据列
  @override
  List<DxPickerItem> getItems() => items;

  /// 定义显示几列内容
  @override
  int numberOfComponent() => columnNum;

  /// 定义每一列所显示的行数， component 代表列的索引，
  @override
  int numberOfRowsInComponent(int component) {
    if (0 == component) {
      return items.length;
    } else if (1 == component) {
      List<DxPickerItem>? secondList = items.elementAt(_firstSelectedIndex).child;
      return secondList?.length ?? 0;
    } else {
      List<DxPickerItem>? secondList = items.elementAt(_firstSelectedIndex).child;
      List<DxPickerItem>? thirdList = secondList?.elementAt(_secondSelectedIndex).child;
      return thirdList?.length ?? 0;
    }
  }

  /// 定义某列某行所显示的内容，component 代表列的索引，index 代表 第component列中的第 index 个元素
  @override
  String titleForRowInComponent(int component, int index) {
    if (0 == component) {
      return items[index].name;
    } else if (1 == component) {
      List<DxPickerItem>? secondList = items.elementAt(_firstSelectedIndex).child;
      return secondList?.elementAt(index).name ?? '';
    } else {
      List<DxPickerItem>? secondList = items.elementAt(_firstSelectedIndex).child;
      List<DxPickerItem>? thirdList = secondList?.elementAt(_secondSelectedIndex).child;
      return thirdList?.elementAt(index).name ?? '';
    }
  }

  /// 定义每列内容的高度
  @override
  double? rowHeightForComponent(int component) => 48;

  /// 定义选择更改后的操作
  @override
  selectRowInComponent(int component, int row) {
    if (0 == component) {
      _firstSelectedIndex = row;
    } else if (1 == component) {
      _secondSelectedIndex = row;
    } else {
      _thirdSelectedIndex = row;
    }
  }

  /// 定义初始选中的行数
  @override
  int initSelectedRowForComponent(int component) {
    switch (component) {
      case 0:
        return _firstSelectedIndex;
      case 1:
        return _secondSelectedIndex;
      case 2:
        return _thirdSelectedIndex;
      default:
        return 0;
    }
  }

  /// 集合根据指定的key获取index
  int _getListIndexById(List<DxPickerItem>? list, int id) {
    if (list == null || list.isEmpty) return 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) return i;
    }
    return 0;
  }
}
