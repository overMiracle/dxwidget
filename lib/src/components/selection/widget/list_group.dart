import 'dart:math';

import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DxSelectionListGroupWidget extends StatefulWidget {
  final DxSelectionItem item;
  final double maxContentHeight;
  final bool showSelectedCount;
  final VoidCallback? bgClickFunction;
  final DxOnRangeSelectionConfirm? onSelectionConfirm;
  DxSelectionThemeData themeData;

  DxSelectionListGroupWidget({
    Key? key,
    required this.item,
    this.maxContentHeight = designSelectionHeight,
    this.showSelectedCount = false,
    this.bgClickFunction,
    this.onSelectionConfirm,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionListGroupWidget> createState() => _DxSelectionListGroupState();
}

class _DxSelectionListGroupState extends State<DxSelectionListGroupWidget> {
  final int maxShowCount = 6;

  List<DxSelectionItem> _firstList = [];
  List<DxSelectionItem> _secondList = [];
  List<DxSelectionItem> _thirdList = [];
  List<DxSelectionItem> _originalSelectedItemsList = [];
  int _firstIndex = -1;
  int _secondIndex = -1;
  int _thirdIndex = -1;

  int totalLevel = 0;

  bool _isConfirmClick = false;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    if (!_isConfirmClick) {
      _resetSelectionData(widget.item);
      _restoreOriginalData();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalLevel = DxSelectionUtil.getTotalLevel(widget.item);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _backgroundTap(),
      child: Column(children: _configWidgets()),
    );
  }

  //pragma mark -- config widgets

  List<Widget> _configWidgets() {
    List<Widget> widgetList = [];

    widgetList.add(_listWidget());
    // TODO 判断是否添加 Bottom
    widgetList.add(_bottomWidget());
    return widgetList;
  }

  Widget _listWidget() {
    List<Widget> widgets = [];

    if (!DxTools.isEmpty(_firstList) && DxTools.isEmpty(_secondList) && DxTools.isEmpty(_thirdList)) {
      /// 1、仅有一级的情况
      /// 1.1 一级单选 && 没有自定义范围的情况
      widgets.add(DxSelectionSingleListWidget(
          items: _firstList,
          themeData: widget.themeData,
          backgroundColor: _getBgByListIndex(1),
          selectedBackgroundColor: _getSelectBgByListIndex(1),
          maxHeight: widget.maxContentHeight,
          flex: _getFlexByListIndex(1),
          focusedIndex: _firstIndex,
          singleListItemSelect: (int listIndex, int index, DxSelectionItem item) {
            _setFirstIndex(index);
            if (totalLevel == 1 && widget.item.type == DxSelectionType.radio) {
              _confirmButtonClickEvent();
            }
          }));
    } else if (!DxTools.isEmpty(_firstList) && !DxTools.isEmpty(_secondList) && DxTools.isEmpty(_thirdList)) {
      /// 2、有二级的情况
      widgets.add(DxSelectionSingleListWidget(
          items: _firstList,
          themeData: widget.themeData,
          backgroundColor: _getBgByListIndex(1),
          selectedBackgroundColor: _getSelectBgByListIndex(1),
          flex: _getFlexByListIndex(1),
          focusedIndex: _firstIndex,
          singleListItemSelect: (int listIndex, int index, DxSelectionItem item) {
            _setFirstIndex(index);
          }));

      widgets.add(DxSelectionSingleListWidget(
          items: _secondList,
          themeData: widget.themeData,
          backgroundColor: _getBgByListIndex(2),
          selectedBackgroundColor: _getSelectBgByListIndex(2),
          flex: _getFlexByListIndex(2),
          focusedIndex: _secondIndex,
          singleListItemSelect: (int listIndex, int index, DxSelectionItem item) {
            _setSecondIndex(index);
          }));
    } else if (!DxTools.isEmpty(_firstList) && !DxTools.isEmpty(_secondList) && !DxTools.isEmpty(_thirdList)) {
      /// 3、有三级的情况
      widgets.add(DxSelectionSingleListWidget(
          items: _firstList,
          themeData: widget.themeData,
          backgroundColor: _getBgByListIndex(1),
          selectedBackgroundColor: _getSelectBgByListIndex(1),
          flex: _getFlexByListIndex(1),
          focusedIndex: _firstIndex,
          singleListItemSelect: (int listIndex, int index, DxSelectionItem item) {
            _setFirstIndex(index);
          }));

      widgets.add(DxSelectionSingleListWidget(
          items: _secondList,
          themeData: widget.themeData,
          backgroundColor: _getBgByListIndex(2),
          selectedBackgroundColor: _getSelectBgByListIndex(2),
          flex: _getFlexByListIndex(2),
          focusedIndex: _secondIndex,
          singleListItemSelect: (int listIndex, int index, DxSelectionItem item) {
            _setSecondIndex(index);
          }));
      widgets.add(DxSelectionSingleListWidget(
          items: _thirdList,
          themeData: widget.themeData,
          backgroundColor: _getBgByListIndex(3),
          selectedBackgroundColor: _getSelectBgByListIndex(3),
          flex: _getFlexByListIndex(3),
          focusedIndex: _thirdIndex,
          singleListItemSelect: (int listIndex, int index, DxSelectionItem item) {
            if (item.isSelected) {
              _thirdIndex = index;
            } else {
              _thirdIndex = -1;
            }
            setState(() {});
          }));
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          color: Colors.white,
          constraints: BoxConstraints(maxHeight: widget.maxContentHeight),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: widgets,
          ),
        ),
        // 目前列表最大高度为 240，每个 Item 高度为 40。顾最大展示个数是 6，大于 6 则显示阴影。
        _getListMaxCount(widgets.length) > maxShowCount
            ? IgnorePointer(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white,
                      ],
                      stops: const [0, 1.0],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget _bottomWidget() {
    return ColoredBox(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: DxButton(
              height: 46,
              block: true,
              title: '重置',
              titleColor: DxStyle.$CCCCCC,
              plain: true,
              square: true,
              border: Border.all(color: DxStyle.$F0F0F0, width: 0.5),
              onClick: () => _clearAllSelectedItems(),
            ),
          ),
          Expanded(
            child: DxButton(
              height: 46,
              block: true,
              square: true,
              onClick: () => _confirmButtonClickEvent(),
            ),
          )
        ],
      ),
    );
  }

  //pragma mark -- event responder

  void _confirmButtonClickEvent() {
    _isConfirmClick = true;

    /// 确认回调前 根据规则，统一处理筛选数据选择状态
    _processFilterDataOnConfirm();
    if (widget.onSelectionConfirm != null) {
      //更多和无tips等外部调用的多选需要传递此值selectedLastColumnArray
      widget.onSelectionConfirm!(widget.item, _firstIndex, _secondIndex, _thirdIndex);
    }
  }

  void _clearAllSelectedItems() {
    _resetSelectionData(widget.item);
    setState(() {
      _configDefaultInitSelectIndex();
      _refreshDataSource();
    });
  }

  /// 初始化数据
  void _initData() {
    // 生成筛选节点树
    _originalSelectedItemsList = widget.item.selectedList();
    for (DxSelectionItem item in _originalSelectedItemsList) {
      item.isSelected = true;
      if (item.customMap != null) {
        item.originalCustomMap = Map.from(item.customMap!);
      }
    }

    // 初始化每列的选中 index 为 -1，未选中。
    _configDefaultInitSelectIndex();
    // 遍历数据源，设置真正选中的index
    _configDefaultSelectedData();
    // 使用真正选中的index来刷新数组
    _refreshDataSource();
  }

  // 设置默认无选中项的时候默认选择index
  void _configDefaultInitSelectIndex() {
    _firstIndex = _secondIndex = _thirdIndex = -1;
  }

  // 刷新3个ListView的数据源
  void _refreshDataSource() {
    _firstList = widget.item.children;
    if (_firstIndex >= 0 && _firstList.length > _firstIndex) {
      _secondList = _firstList[_firstIndex].children;
      if (_secondIndex >= 0 && _secondList.length > _secondIndex) {
        _thirdList = _secondList[_secondIndex].children;
      } else {
        _thirdList = [];
      }
    } else {
      _secondList = [];
      _thirdList = [];
    }
  }

  void _configDefaultSelectedData() {
    _firstList = widget.item.children;
    //是否已选择的item里面有第一列的
    if (_firstList.isEmpty) {
      _secondIndex = -1;
      _secondList = [];

      _thirdIndex = -1;
      _thirdList = [];

      return;
    }
    _firstIndex = _getInitialSelectIndex(_firstList);

    if (_firstIndex >= 0 && _firstIndex < _firstList.length) {
      _secondList = _firstList[_firstIndex].children;
      _secondIndex = _getInitialSelectIndex(_secondList);
    }

    if (_secondList.isEmpty) {
      _thirdIndex = -1;
      _thirdList = [];
      return;
    }
    if (_secondIndex >= 0 && _secondIndex < _secondList.length) {
      _thirdList = _secondList[_secondIndex].children;
      if (_thirdList.isNotEmpty) {
        _thirdIndex = _getInitialSelectIndex(_thirdList);
      }
    }
  }

  ///还原数据选中状态
  void _resetSelectionData(DxSelectionItem item) {
    item.isSelected = false;
    item.customMap = {};
    if (DxSelectionType.range == item.type) {
      item.title = '';
    }
    for (DxSelectionItem item in item.children) {
      _resetSelectionData(item);
    }
  }

  ///数据还原
  void _restoreOriginalData() {
    for (DxSelectionItem item in _originalSelectedItemsList) {
      item.isSelected = true;
      item.customMap = Map.from(item.originalCustomMap);
    }
  }

  void _setFirstIndex(int firstIndex) {
    _firstIndex = firstIndex;
    _secondIndex = -1;
    if (widget.item.children.length > _firstIndex) {
      List<DxSelectionItem> seconds = widget.item.children[_firstIndex].children;
      _secondIndex = _getInitialSelectIndex(seconds);
      if (_secondIndex >= 0) {
        _setSecondIndex(_secondIndex);
      }
    }
    setState(() {
      _refreshDataSource();
    });
  }

  void _setSecondIndex(int secondIndex) {
    _secondIndex = secondIndex;
    _thirdIndex = -1;
    List<DxSelectionItem> seconds = widget.item.children[_firstIndex].children;
    if (seconds.length > _secondIndex) {
      List<DxSelectionItem> thirds = seconds[_secondIndex].children;
      if (thirds.isNotEmpty) {
        _thirdIndex = _getInitialSelectIndex(thirds);
      }
    }
    setState(() {
      _refreshDataSource();
    });
  }

  int _getInitialSelectIndex(List<DxSelectionItem> levelList) {
    int index = -1;
    if (levelList.isEmpty) {
      return index;
    }

    for (DxSelectionItem item in levelList) {
      if (item.isSelected) {
        index = levelList.indexOf(item);
        break;
      }
    }

    /// 非跨区域选择时，走此方法设置默认选择 index
    if (index < 0) {
      for (DxSelectionItem item in levelList) {
        if (item.isUnLimit() &&
            DxSelectionUtil.getTotalLevel(item) > 1 &&
            !(item.parent?.hasCheckBoxBrother() ?? false)) {
          index = levelList.indexOf(item);
          break;
        }
      }
    }
    return index;
  }

  /// 默认占比为 1，
  /// 其中一列、两列情况下，占比都是 1
  /// 当为三列数据时，占比随着 listIndex 增加而增大。为 3：3：4 比例水平占据屏幕
  int _getFlexByListIndex(int listIndex) {
    int flex = 1;
    if (totalLevel == 1 || totalLevel == 2) {
      flex = 1;
    } else if (totalLevel == 3) {
      if (listIndex == 1) {
        flex = 3;
      } else if (listIndex == 2) {
        if (_thirdList.isEmpty) {
          flex = 7;
        } else {
          flex = 3;
        }
      } else if (listIndex == 3) {
        flex = 4;
      }
    }
    return flex;
  }

  Color _getSelectBgByListIndex(int listIndex) {
    Color deepSelectBgColor = widget.themeData.deepSelectBgColor;
    Color middleSelectBgColor = widget.themeData.middleSelectBgColor;
    Color lightSelectBgColor = widget.themeData.lightSelectBgColor;
    if (totalLevel == 1) {
      return lightSelectBgColor;
    } else if (totalLevel == 2) {
      if (listIndex == 1) {
        return middleSelectBgColor;
      } else {
        return lightSelectBgColor;
      }
    } else {
      if (listIndex == 1) {
        return deepSelectBgColor;
      } else if (listIndex == 2) {
        return middleSelectBgColor;
      } else if (listIndex == 3) {
        return lightSelectBgColor;
      }
    }
    return lightSelectBgColor;
  }

  Color _getBgByListIndex(int listIndex) {
    Color deepNormalBgColor = widget.themeData.deepNormalBgColor;
    Color middleNormalBgColor = widget.themeData.middleNormalBgColor;
    Color lightNormalBgColor = widget.themeData.lightNormalBgColor;
    if (totalLevel == 1) {
      return lightNormalBgColor;
    } else if (totalLevel == 2) {
      if (listIndex == 1) {
        return middleNormalBgColor;
      } else {
        return lightNormalBgColor;
      }
    } else {
      if (listIndex == 1) {
        return deepNormalBgColor;
      } else if (listIndex == 2) {
        return middleNormalBgColor;
      } else if (listIndex == 3) {
        return lightNormalBgColor;
      }
    }
    return lightNormalBgColor;
  }

  void _backgroundTap() {
    //还原数据：内部先将最新的状态清空，然后数据还原。
    _resetSelectStatus();
    if (widget.bgClickFunction != null) {
      //执行回调
      widget.bgClickFunction!();
    }
  }

  void _resetSelectStatus() {
    _clearAllSelectedItems();
    //数据还原
    for (DxSelectionItem item in _originalSelectedItemsList) {
      item.isSelected = true;
      item.customMap = Map.from(item.originalCustomMap);
    }
  }

  /// 提交前对筛选数据做进一步处理，
  /// !!! 只有子筛选项存在被选中的 Item 才可以被设置为 true。
  void _processFilterDataOnConfirm() {
    _processSelectedStatus(widget.item);
  }

  _processSelectedStatus(DxSelectionItem item) {
    if (item.children.isNotEmpty) {
      for (var f in item.children) {
        _processSelectedStatus(f);
      }
      if (item.hasCheckBoxBrother()) {
        item.isSelected = item.children.where((_) => _.isSelected).isNotEmpty;
      }
    }
  }

  int _getListMaxCount(int length) {
    int mostCount = 0;
    if (length == 1) {
      mostCount = _firstList.length;
    } else if (length == 2) {
      int firstCount = _firstList.length;
      int secondCount = _secondList.length;
      mostCount = max(firstCount, secondCount);
    } else if (length == 3) {
      int firstCount = _firstList.length;
      int secondCount = _secondList.length;
      int thirdCount = _secondList.length;
      mostCount = max(firstCount, max(secondCount, thirdCount));
    }
    return mostCount;
  }
}
