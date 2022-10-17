import 'package:dxwidget/src/components/picker/bottom_picker.dart';

/// 数据适配 Delegate
abstract class DxMultiAbstractDelegate {
  /// 数据列
  List<DxPickerItem> getItems();

  /// 定义显示几列内容
  int numberOfComponent();

  /// 定义每一列所显示的行数， component 代表列的索引，
  int numberOfRowsInComponent(int component);

  /// 定义某列某行所显示的内容，component 代表列的索引，index 代表 第component列中的第 index 个元素
  String titleForRowInComponent(int component, int index);

  /// 定义每列内容的高度
  double? rowHeightForComponent(int component);

  /// 定义选择更改后的操作
  void selectRowInComponent(int component, int row);

  /// 定义初始选中的行数
  int initSelectedRowForComponent(int component);
}
