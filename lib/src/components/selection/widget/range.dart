import 'dart:ui';

import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

class DxSelectionRangeGroupWidget extends StatefulWidget {
  static final double screenWidth = window.physicalSize.width / window.devicePixelRatio;

  final DxSelectionItem item;
  final double maxContentHeight;
  final bool showSelectedCount;
  final VoidCallback? bgClickFunction;
  final DxOnRangeSelectionConfirm? onSelectionConfirm;

  final int? rowCount;

  final double marginTop;

  final DxSelectionThemeData themeData;

  const DxSelectionRangeGroupWidget({
    Key? key,
    required this.item,
    this.maxContentHeight = designSelectionHeight,
    this.rowCount,
    this.showSelectedCount = false,
    this.bgClickFunction,
    this.onSelectionConfirm,
    this.marginTop = 0,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionRangeGroupWidget> createState() => _DxSelectionRangeGroupWidgetState();
}

class _DxSelectionRangeGroupWidgetState extends State<DxSelectionRangeGroupWidget> with SingleTickerProviderStateMixin {
  List<DxSelectionItem> _originalSelectedItemsList = [];
  List<DxSelectionItem> _firstList = [];
  List<DxSelectionItem> _secondList = [];
  int _firstIndex = -1;
  int _secondIndex = -1;
  int totalLevel = 0;

  late TabController _tabController;

  final TextEditingController _minTextEditingController = TextEditingController();
  final TextEditingController _maxTextEditingController = TextEditingController();

  bool _isConfirmClick = false;

  @override
  void initState() {
    _initData();
    _tabController = TabController(vsync: this, length: _firstList.length);
    if (_firstIndex >= 0) {
      _tabController.index = _firstIndex;
    }
    _tabController.addListener(() {
      _clearAllSelectedItems();
      _clearNotTagItem(totalLevel == 1 ? _firstList : _firstList[_tabController.index].children);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (!_isConfirmClick) {
      _resetSelectionData(widget.item);
      _clearNotTagItem(totalLevel == 1 ? _firstList : _firstList[_tabController.index].children);
      _resetCustomMapData();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalLevel = DxSelectionUtil.getTotalLevel(widget.item);
    return GestureDetector(
      onTap: () => _backgroundTap(),
      child: Container(
        color: Colors.transparent,
        child: Column(children: _configWidgets()),
      ),
    );
  }

  //pragma mark -- config widgets

  List<Widget> _configWidgets() {
    List<Widget> widgetList = [];
    widgetList.add(_listWidget());
    return widgetList;
  }

  Widget _listWidget() {
    Widget? rangeWidget;

    if (_firstList.isNotEmpty && _secondList.isEmpty) {
      /// 1、仅有一级的情况
      /// 1.2 一级多选 || 存在自定义范围的情况
      rangeWidget = _createNewTagAndRangeWidget(_firstList, Colors.white);
    } else if (_firstList.isNotEmpty && _secondList.isNotEmpty) {
      /// 2、有二级的情况
      rangeWidget = _createNewTagAndRangeWidget(_firstList, Colors.white);
    }

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      constraints: _hasCalendarItem(widget.item)
          ? BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - widget.marginTop)
          : BoxConstraints(maxHeight: widget.maxContentHeight + designBottomHeight),
      child: rangeWidget,
    );
  }

  Widget _createNewTagAndRangeWidget(List<DxSelectionItem> firstList, Color white) {
    if (firstList.isNotEmpty && DxSelectionUtil.getTotalLevel(widget.item) == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScrollConfiguration(
            behavior: DxNoScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _getOneTabContent(widget.item),
              ),
            ),
          ),
          _bottomWidget(),
        ],
      );
    } else if (firstList.isNotEmpty && DxSelectionUtil.getTotalLevel(widget.item) == 2) {
      return const SizedBox(
        child: Text('因为有tabBar，等待完善'),
      );
      // var tabBar = DxTabBar(
      //   // tabHeight: 50,
      //   // controller: _tabController,
      //   // children: firstList.map((f) => BadgeTab(text: f.title)).toList(),
      // );
      // var tabContent = SingleChildScrollView(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: _getOneTabContent(
      //       firstList[_tabController.index],
      //     ),
      //   ),
      // );
      //
      // return Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: <Widget>[
      //     tabBar,
      //     Flexible(child: tabContent),
      //     const Divider(height: 0.5),
      //     _bottomWidget(),
      //   ],
      // );
    } else {
      return const SizedBox.shrink();
    }
  }

  List<Widget> _getOneTabContent(DxSelectionItem filterItem) {
    List<DxSelectionItem> subFilterList = filterItem.children;

    /// TODO 还要添加 Date  DateRange 类型的判断。
    List<DxSelectionItem> tagFilterList = subFilterList
        .where((f) =>
            f.type != DxSelectionType.range &&
            f.type != DxSelectionType.date &&
            f.type != DxSelectionType.dateRange &&
            f.type != DxSelectionType.dateRangeCalendar)
        .toList();
    Size maxWidthSize = Size.zero;
    for (DxSelectionItem item in subFilterList) {
      Size size = textSize(item.title, widget.themeData.tagNormalTextStyle);
      if (maxWidthSize.width < size.width) {
        maxWidthSize = size;
      }
    }

    int tagWidth;

    ///如果指定展示列，则按照指定列展示，否则动态计算宽度。最大不超过四列。
    if (widget.rowCount == null) {
      int oneCountTagWidth = (DxSelectionRangeGroupWidget.screenWidth - 40 - 12 * (1 - 1)) ~/ 1;
      int twoCountTagWidth = (DxSelectionRangeGroupWidget.screenWidth - 40 - 12 * (2 - 1)) ~/ 2;
      int threeCountTagWidth = (DxSelectionRangeGroupWidget.screenWidth - 40 - 12 * (3 - 1)) ~/ 3;
      int fourCountTagWidth = (DxSelectionRangeGroupWidget.screenWidth - 40 - 12 * (4 - 1)) ~/ 4;
      if (maxWidthSize.width > twoCountTagWidth) {
        tagWidth = oneCountTagWidth;
      } else if (threeCountTagWidth < maxWidthSize.width && maxWidthSize.width <= twoCountTagWidth) {
        tagWidth = twoCountTagWidth;
      } else if (fourCountTagWidth < maxWidthSize.width && maxWidthSize.width <= threeCountTagWidth) {
        tagWidth = threeCountTagWidth;
      } else {
        tagWidth = fourCountTagWidth;
      }
    } else {
      tagWidth = (DxSelectionRangeGroupWidget.screenWidth - 40 - 12 * (widget.rowCount! - 1)) ~/ widget.rowCount!;
    }

    var tagContainer = tagFilterList.isNotEmpty
        ? Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20.0),
            child: DxSelectionRangeTagWidget(
                tagWidth: tagWidth,
                tagFilterList: tagFilterList,
                initFocusedIndex: _getInitFocusedIndex(subFilterList),
                themeData: widget.themeData,
                onSelect: (index, isSelected) {
                  setState(() {
                    _setFirstIndex(_tabController.index);
                    _setSecondIndex(index);
                    _clearNotTagItem(totalLevel == 1 ? _firstList : _firstList[_tabController.index].children);
                    _clearEditRangeText();
                  });
                }),
          )
        : Container();

    Widget? content;
    for (DxSelectionItem item in subFilterList) {
      if (item.type == DxSelectionType.range) {
        content = DxSelectionRangeItemWidget(
            item: item,
            minTextEditingController: _minTextEditingController,
            maxTextEditingController: _maxTextEditingController,
            themeData: widget.themeData,
            onFocusChanged: (bool focus) {
              item.isSelected = focus;
              if (focus) {
                setState(() {
                  _clearTagSelectStatus(subFilterList);
                });
              }
            });
        break;
      } else if (item.type == DxSelectionType.dateRange) {
        content = DxSelectionDateRangeItemWidget(
            item: item,
            minTextEditingController: _minTextEditingController,
            maxTextEditingController: _maxTextEditingController,
            themeData: widget.themeData,
            onTapped: () {
              setState(() {
                _clearTagSelectStatus(subFilterList);
              });
            });
        break;
      } else if (item.type == DxSelectionType.date) {
        DateTime? initialStartDate = DateTimeFormatter.convertIntValueToDateTime(item.value);
        DateTime? initialEndDate = DateTimeFormatter.convertIntValueToDateTime(item.value);
        content = DxCalendar.single(
          key: GlobalKey(),
          initStartSelectedDate: initialStartDate,
          initEndSelectedDate: initialEndDate,
          initDisplayDate: initialEndDate,
          dateChange: (DateTime date) {
            item.value = date.millisecondsSinceEpoch.toString();
            item.isSelected = true;
            setState(() {
              _clearTagSelectStatus(subFilterList);
            });
          },
        );
      } else if (item.type == DxSelectionType.dateRangeCalendar) {
        DateTime? initialStartDate =
            item.customMap == null ? null : DateTimeFormatter.convertIntValueToDateTime(item.customMap!['min']);
        DateTime? initialEndDate =
            item.customMap == null ? null : DateTimeFormatter.convertIntValueToDateTime(item.customMap!['max']);
        content = DxCalendar.range(
          key: GlobalKey(),
          initStartSelectedDate: initialStartDate,
          initEndSelectedDate: initialEndDate,
          rangeDateChange: (DateTimeRange range) {
            item.customMap = {};
            item.customMap = {
              'min': range.start.millisecondsSinceEpoch.toString(),
              'max': range.end.millisecondsSinceEpoch.toString()
            };
            item.isSelected = true;
            setState(() {
              _clearTagSelectStatus(subFilterList);
            });
          },
        );
      }
    }
    var widgets = <Widget>[tagContainer];
    if (content != null) {
      widgets.add(content);
    }
    return widgets;
  }

  Widget _bottomWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: DxButton(
              block: true,
              title: '重置',
              titleColor: DxStyle.$CCCCCC,
              plain: true,
              square: true,
              height: 46,
              border: Border.all(color: DxStyle.$F0F0F0, width: 0.5),
              onClick: () => _clearAllSelectedItems(),
            ),
          ),
          Expanded(
            child: DxButton(
              block: true,
              square: true,
              height: 46,
              onClick: () => _confirmButtonClickEvent(),
            ),
          ),
        ],
      ),
    );
  }

  //pragma mark -- event responder

  /// 点击确定按钮时，处理数据。
  ///
  void _confirmButtonClickEvent() {
    _isConfirmClick = true;

    if (totalLevel == 2) {
      List<DxSelectionItem> subFilterList = widget.item.children[_tabController.index].children;
      List<DxSelectionItem> selectItems = subFilterList.where((f) => f.isSelected).toList();
      if (selectItems.isNotEmpty) {
        _firstList[_tabController.index].isSelected = true;
      } else {
        _firstList[_tabController.index].isSelected = false;
      }
    }

    // 处理Range类型的校验
    DxSelectionItem? rangeItem =
        _getSelectRangeItem(totalLevel == 1 ? _firstList : _firstList[_tabController.index].children);
    if (rangeItem != null) {
      if (rangeItem.customMap != null &&
          (!DxTools.isEmpty(rangeItem.customMap!['min']) || !DxTools.isEmpty(rangeItem.customMap!['max']))) {
        if (!rangeItem.isValidRange()) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (rangeItem.type == DxSelectionType.range) {
            DxToast.show('您输入的区间有误');
          } else if (rangeItem.type == DxSelectionType.dateRange ||
              rangeItem.type == DxSelectionType.dateRangeCalendar) {
            DxToast.show('您选择的区间有误');
          }
          return;
        }
      } else {
        rangeItem.isSelected = false;
      }
    }

    if (widget.onSelectionConfirm != null) {
      widget.onSelectionConfirm!(widget.item, _firstIndex, _secondIndex, -1);
    }
  }

  void _clearAllSelectedItems() {
    _resetSelectionData(widget.item);
    _clearNotTagItem(totalLevel == 1 ? _firstList : _firstList[_tabController.index].children);
    _clearEditRangeText();
    setState(() {
      _configDefaultInitSelectIndex();
      _refreshDataSource();
    });
  }

  // 初始化数据
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
    _firstIndex = _secondIndex = -1;
  }

  void _setFirstIndex(int firstIndex) {
    _firstIndex = firstIndex;
    _secondIndex = -1;
    if (widget.item.children.length > _firstIndex) {
      List<DxSelectionItem> seconds = widget.item.children[_firstIndex].children;
      if (seconds.isNotEmpty) {
        for (DxSelectionItem item in seconds) {
          if (item.isSelected) {
            _setSecondIndex(seconds.indexOf(item));
            break;
          }
        }
      }
    }
    setState(() {
      _refreshDataSource();
    });
  }

  void _setSecondIndex(int secondIndex) {
    _secondIndex = secondIndex;
    setState(() {
      _refreshDataSource();
    });
  }

  // 刷新3个ListView的数据源
  void _refreshDataSource() {
    _firstList = widget.item.children;
    if (_firstIndex >= 0 && _firstList.length > _firstIndex) {
      _secondList = _firstList[_firstIndex].children;
    } else {
      _secondList = [];
    }
  }

  void _configDefaultSelectedData() {
    _firstList = widget.item.children;
    //是否已选择的item里面有第一列的
    if (_firstList.isEmpty) {
      _secondIndex = -1;
      _secondList = [];
      return;
    }
    for (DxSelectionItem item in _firstList) {
      if (item.isSelected) {
        _firstIndex = _firstList.indexOf(item);
        break;
      }
    }

    if (_firstIndex >= 0 && _firstIndex < _firstList.length) {
      _secondList = _firstList[_firstIndex].children;
      if (_secondList.isNotEmpty) {
        for (DxSelectionItem item in _secondList) {
          if (item.isSelected) {
            _secondIndex = _secondList.indexOf(item);
            break;
          }
        }
      }
    }
  }

  //设置数据为未选中状态
  void _resetSelectionData(DxSelectionItem item) {
    item.isSelected = false;
    item.customMap = {};
    for (DxSelectionItem subItem in item.children) {
      _resetSelectionData(subItem);
    }
  }

  void _clearNotTagItem(List<DxSelectionItem> subFilterList) {
    subFilterList
        .where((f) =>
            f.type == DxSelectionType.range ||
            f.type == DxSelectionType.date ||
            f.type == DxSelectionType.dateRange ||
            f.type == DxSelectionType.dateRangeCalendar)
        .forEach((f) {
      f.isSelected = false;
      f.customMap = {};
      f.value = null;
    });
  }

  void _clearEditRangeText() {
    _minTextEditingController.text = "";
    _maxTextEditingController.text = "";
    DxEventBus.instance.fire(ClearSelectionFocusEvent());
  }

  void _clearTagSelectStatus(List<DxSelectionItem> subFilterList) {
    subFilterList
        .where((f) => f.type != DxSelectionType.range)
        .where((f) => f.type != DxSelectionType.date)
        .where((f) => f.type != DxSelectionType.dateRange)
        .where((f) => f.type != DxSelectionType.dateRangeCalendar)
        .forEach((f) {
      f.isSelected = false;
      f.customMap = {};
    });
  }

  /// 获取针对 Range 类型进行value 检查。 DateRange、DateRangeCalendar 类型不需要检查，因为在选择时间的时候已经做了时间范围限制。
  DxSelectionItem? _getSelectRangeItem(List<DxSelectionItem> filterList) {
    List<DxSelectionItem> ranges = filterList
        .where((f) =>
            (f.type == DxSelectionType.range ||
                f.type == DxSelectionType.dateRange ||
                f.type == DxSelectionType.dateRangeCalendar) &&
            f.isSelected)
        .toList();

    if (ranges.isNotEmpty) {
      return ranges[0];
    }
    return null;
  }

  void _backgroundTap() {
    _resetSelectStatus();
    if (widget.bgClickFunction != null) {
      widget.bgClickFunction!();
    }
  }

  void _resetSelectStatus() {
    _clearAllSelectedItems();
    _resetCustomMapData();
  }

  ///数据还原
  void _resetCustomMapData() {
    for (DxSelectionItem commonItem in _originalSelectedItemsList) {
      commonItem.isSelected = true;
      commonItem.customMap = Map.from(commonItem.originalCustomMap);
    }
  }

  /// 如果自定义输入和默认选中都没有，则尝试默认高亮【不限】这种类型的 Tag。
  int _getInitFocusedIndex(List<DxSelectionItem> subFilterList) {
    bool isCustomInputSelected = false;
    for (DxSelectionItem item in subFilterList) {
      if (DxSelectionType.range == item.type ||
          DxSelectionType.dateRange == item.type ||
          DxSelectionType.dateRangeCalendar == item.type) {
        isCustomInputSelected = item.isSelected;
        break;
      }
    }

    var selectedItem = subFilterList
        .where((f) =>
            f.type != DxSelectionType.range &&
            f.type != DxSelectionType.dateRange &&
            f.type != DxSelectionType.dateRangeCalendar &&
            f.isSelected)
        .toList();
    if (!isCustomInputSelected && DxTools.isEmpty(selectedItem)) {
      for (DxSelectionItem item in subFilterList) {
        if (item.isUnLimit()) {
          return subFilterList.indexOf(item);
        }
      }
    }

    return -1;
  }

  bool _hasCalendarItem(DxSelectionItem item) {
    bool hasCalendarItem = false;
    hasCalendarItem = item.children
        .where((_) => _.type == DxSelectionType.date || _.type == DxSelectionType.dateRangeCalendar)
        .toList()
        .isNotEmpty;

    /// 查找第二层级
    if (!hasCalendarItem) {
      for (DxSelectionItem subItem in item.children) {
        int count = subItem.children
            .where((_) => _.type == DxSelectionType.date || _.type == DxSelectionType.dateRangeCalendar)
            .toList()
            .length;
        if (count > 0) {
          hasCalendarItem = true;
          break;
        }
      }
    }
    return hasCalendarItem;
  }
}
