import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/picker/base/picker.dart';
import 'package:dxwidget/src/components/picker/base/picker_clip_rrect.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:dxwidget/src/components/picker/delegate/abstract_delegate.dart';
import 'package:flutter/material.dart';

/// 可以自定义实现 item Widget样式，更灵活
/// [isSelect] 是否被选中
/// [column] 第几列
/// [row] 第几行
/// [selectedItems] 当前被选中的数据列表
typedef DxMultiDataPickerCreateWidgetCallback = Widget Function(bool isSelect, int column, int row, List selectedItems);

/// 创建一级数据widget列表
typedef CreateWidgetList = List<Widget> Function();

/// 确定筛选内容事件回调
typedef DxMultiDataPickerConfirm = void Function(Map<String, dynamic>);

/// 多级数据选择弹窗
// ignore: must_be_immutable
class DxMultiDataPicker extends StatefulWidget {
  /// 多级数据选择弹窗所要覆盖页面的context
  final BuildContext context;

  /// 多级数据选择弹窗标题
  final String title;

  /// 多级数据选择弹窗的数据来源，自定义delegate继承该类，实现具体方法即可自定义每一列、每一行的具体内容
  final DxMultiAbstractDelegate delegate;

  /// 多级数据选择每一级的默认标题
  final List<String>? pickerTitles;

  /// 多级数据选择每一级默认标题的字体大小
  final double? pickerTitleFontSize;

  /// 多级数据选择每一级默认标题的文案颜色
  final Color? pickerTitleColor;

  /// 多级数据选择数据widget容器
  final List<FixedExtentScrollController> controllers = [];

  /// 多级数据选择确认点击回调
  final DxMultiDataPickerConfirm? onConfirm;

  /// 选择轮盘的滚动行为
  final ScrollBehavior? behavior;

  /// 返回自定义 itemWidget 的回调
  final DxMultiDataPickerCreateWidgetCallback? createItemWidget;

  /// 是否复位数据位置。默认 true
  final bool sync;

  DxPickerThemeData? themeData;

  DxMultiDataPicker({
    Key? key,
    required this.context,
    required this.delegate,
    this.title = '请选择',
    this.pickerTitles,
    this.pickerTitleFontSize,
    this.pickerTitleColor,
    this.behavior,
    this.onConfirm,
    this.createItemWidget,
    this.themeData,
    this.sync = true,
  }) : super(key: key) {
    themeData = DxPickerThemeData().merge(themeData);
  }

  @override
  State<DxMultiDataPicker> createState() => _DxMultiDataPickerState();

  static void show(
    context, {
    bool isDismissible = true,
    required String title,
    required DxMultiAbstractDelegate delegate,
    List<String>? pickerTitles,
    double? pickerTitleFontSize = 12,
    Color? pickerTitleColor = DxStyle.$666666,
    DxMultiDataPickerConfirm? onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (BuildContext context) {
        return DxMultiDataPicker(
          context: context,
          title: title,
          delegate: delegate,
          pickerTitles: pickerTitles,
          pickerTitleFontSize: pickerTitleFontSize,
          pickerTitleColor: pickerTitleColor,
          onConfirm: onConfirm,
        );
      },
    );
  }
}

class _DxMultiDataPickerState extends State<DxMultiDataPicker> with WidgetsBindingObserver {
  final List<int> _selectedIndexList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.delegate.numberOfComponent(); i++) {
      _selectedIndexList.add(widget.delegate.initSelectedRowForComponent(i));
    }

    /// 绘制完成关闭弹窗
    WidgetsBinding.instance.addPostFrameCallback((callback) => DxToast.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return DxPickerClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.themeData!.cornerRadius),
        topRight: Radius.circular(widget.themeData!.cornerRadius),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: <Widget>[
            _createContentWidget(),
            _createHeaderWidget(),
          ],
        ),
      ),
    );
  }

  //头部widget
  Widget _createHeaderWidget() {
    return DxPickerTitle(
      themeData: widget.themeData,
      pickerTitleConfig: DxPickerTitleConfig(titleText: widget.title),
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        widget.onConfirm?.call(getSelectedList());
        Navigator.of(context).pop(_selectedIndexList);
      },
    );
  }

  // 选择的内容widget
  Widget _createContentWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: widget.pickerTitles != null ? _pickersWithTitle() : _pickers(),
    );
  }

  List<Widget> _pickersWithTitle() {
    List<Widget> pickersWithTitle = [];
    for (int i = 0; i < widget.delegate.numberOfComponent(); i++) {
      int initRow = widget.delegate.initSelectedRowForComponent(i);
      FixedExtentScrollController controller = FixedExtentScrollController(initialItem: initRow);
      widget.controllers.add(controller);
      if (i >= _selectedIndexList.length) _selectedIndexList.add(0);
      Widget picker = _configSinglePicker(i);
      pickersWithTitle.add(
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    widget.pickerTitles![i],
                    style: TextStyle(fontSize: widget.pickerTitleFontSize, color: widget.pickerTitleColor),
                  ),
                ),
              ),
              Expanded(flex: 5, child: picker)
            ],
          ),
        ),
      );
    }
    return pickersWithTitle;
  }

  //picker数据
  List<Widget> _pickers() {
    List<Widget> pickers = [];
    for (int i = 0; i < widget.delegate.numberOfComponent(); i++) {
      int initRow = widget.delegate.initSelectedRowForComponent(i);
      FixedExtentScrollController controller = FixedExtentScrollController(initialItem: initRow);
      widget.controllers.add(controller);
      if (i >= _selectedIndexList.length) _selectedIndexList.add(0);
      Widget picker = _configSinglePicker(i);
      pickers.add(Expanded(flex: 1, child: picker));
    }
    return pickers;
  }

  //构建单列数据
  Widget _configSinglePicker(int component) {
    return _DxSinglePicker(
      backgroundColor: widget.themeData!.backgroundColor,
      lineColor: widget.themeData!.dividerColor,
      controller: widget.controllers[component],
      key: Key(component.toString()),
      createWidgetList: () {
        if (widget.createItemWidget != null) {
          List<Widget> widgetList = [];
          for (int i = 0; i < widget.delegate.numberOfRowsInComponent(component); i++) {
            bool isSelect = _selectedIndexList[component] == i;
            widgetList.add(widget.createItemWidget != null
                ? widget.createItemWidget!(isSelect, component, i, _selectedIndexList)
                : const SizedBox.shrink());
          }
          return widgetList;
        } else {
          List<Widget> list = [];
          for (int i = 0; i < widget.delegate.numberOfRowsInComponent(component); i++) {
            list.add(Center(
              child: Text(
                widget.delegate.titleForRowInComponent(component, i),
                style: _selectedIndexList[component] == i
                    ? widget.themeData!.itemTextSelectedStyle
                    : widget.themeData!.itemTextStyle,
              ),
            ));
          }
          return list;
        }
      },
      itemExtent: widget.delegate.rowHeightForComponent(component) ?? widget.themeData!.itemHeight,
      changed: (int index) {
        widget.delegate.selectRowInComponent(component, index);
        _selectedIndexList[component] = index;
        setState(() {
          for (int i = component + 1; i < widget.delegate.numberOfComponent(); i++) {
            List list = [];
            for (int j = 0; j < widget.delegate.numberOfRowsInComponent(component); j++) {
              list.add(widget.delegate.titleForRowInComponent(component, index));
            }
            FixedExtentScrollController controller = widget.controllers[i];
            if (widget.sync) {
              controller.jumpTo(0);
              _selectedIndexList[i] = 0;
            }
          }
        });
      },
      scrollBehavior: widget.behavior,
    );
  }

  /// 返回选中的结果
  Map<String, dynamic> getSelectedList() {
    List<DxPickerItem> items = widget.delegate.getItems();
    List<DxPickerItem>? list2 = items.elementAt(_selectedIndexList[0]).child;
    List<DxPickerItem?>? list3 = list2?.elementAt(_selectedIndexList[1]).child;

    /// 第一项一定不为空
    DxPickerItem item1 = items[_selectedIndexList[0]];
    DxPickerItem? item2 = list2?.elementAt(_selectedIndexList[1]);
    DxPickerItem? item3 = list3?.elementAt(_selectedIndexList[2]);

    String idString = item1.id.toString();
    String nameString = item1.name;
    List<int> idList = [item1.id];
    List<String> nameList = [item1.name];
    if (item2 != null) {
      idString += ",${item2.id}";
      nameString += ",${item2.name}";
      idList.add(item2.id);
      nameList.add(item2.name);
    }
    if (item3 != null) {
      idString += ",${item3.id}";
      nameString += ",${item3.name}";
      idList.add(item3.id);
      nameList.add(item3.name);
    }

    return {
      'idString': idString,
      'nameString': nameString,
      'idList': idList,
      'nameList': nameList,
    };
  }
}

/// 单列数据选择widget
class _DxSinglePicker extends StatefulWidget {
  ///创建数据widget列表
  final CreateWidgetList? createWidgetList;

  ///数据选择改变回调
  final ValueChanged<int>? changed;

  /// 数据显示高度
  final double itemExtent;

  /// 滚动行为
  final ScrollBehavior? scrollBehavior;

  final FixedExtentScrollController? controller;
  final Color backgroundColor;
  final Color? lineColor;

  const _DxSinglePicker({
    Key? key,
    this.createWidgetList,
    this.changed,
    this.scrollBehavior,
    this.itemExtent = 45,
    this.controller,
    this.backgroundColor = Colors.white,
    this.lineColor,
  }) : super(key: key);

  @override
  State<_DxSinglePicker> createState() => __DxSinglePickerState();
}

class __DxSinglePickerState extends State<_DxSinglePicker> {
  @override
  Widget build(BuildContext context) {
    var children = widget.createWidgetList!();
    return DxPicker(
      key: widget.key,
      scrollController: widget.controller,
      itemExtent: widget.itemExtent,
      backgroundColor: widget.backgroundColor,
      lineColor: widget.lineColor,
      onSelectedItemChanged: (index) => widget.changed?.call(index),
      children: children.isNotEmpty
          ? children
          : [
              const Center(child: Text('')),
            ],
    );
  }
}
