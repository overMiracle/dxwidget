import 'dart:async';

import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

class DxSelectionMenuWidget extends StatefulWidget {
  final List<DxSelectionItem> items;
  final BuildContext context;
  final double height;
  final double? width;
  final DxOnRangeSelectionConfirm? onConfirm;
  final DxOnMenuItemClick? onMenuItemClick;
  final DxConfigTagCountPerRow? configRowCount;

  ///筛选所在列表的外部列表滚动需要收起筛选，此处为最外层列表，有点恶心，但是暂时只想到这个方法，有更好方式的一定要告诉我
  final ScrollController? extraScrollController;

  ///指定筛选固定的相对于屏幕的顶部距离，默认null不指定
  final double? constantTop;

  final DxSelectionThemeData themeData;

  const DxSelectionMenuWidget({
    Key? key,
    required this.context,
    required this.items,
    this.height = 50.0,
    this.width,
    this.onMenuItemClick,
    this.onConfirm,
    this.configRowCount,
    this.extraScrollController,
    this.constantTop,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionMenuWidget> createState() => _DxSelectionMenuWidgetState();
}

class _DxSelectionMenuWidgetState extends State<DxSelectionMenuWidget> {
  bool _needRefreshTitle = true;
  List<DxSelectionItem> result = [];
  List<String> titles = [];
  List<bool> menuItemActiveState = [];
  List<bool> menuItemHighlightState = [];

  DxSelectionListViewController listViewController = DxSelectionListViewController();
  ScrollController? _scrollController;

  late StreamSubscription _refreshTitleSubscription;

  late StreamSubscription _closeSelectionPopupWindowSubscription;

  @override
  void initState() {
    super.initState();
    _refreshTitleSubscription = DxEventBus.instance.on<RefreshMenuTitleEvent>().listen((RefreshMenuTitleEvent event) {
      _needRefreshTitle = true;
      setState(() {});
    });

    _closeSelectionPopupWindowSubscription =
        DxEventBus.instance.on<CloseSelectionViewEvent>().listen((CloseSelectionViewEvent event) {
      _closeSelectionPopupWindow();
    });

    if (widget.extraScrollController != null) {
      _scrollController = widget.extraScrollController!;
      _scrollController!.addListener(_closeSelectionPopupWindow);
    }

    for (DxSelectionItem parentEntity in widget.items) {
      titles.add(parentEntity.title);
      menuItemActiveState.add(false);
      menuItemHighlightState.add(false);
    }
  }

  void _closeSelectionPopupWindow() {
    if (listViewController.isShow) {
      listViewController.hide();
      setState(() {
        for (int i = 0; i < menuItemActiveState.length; i++) {
          if (i != listViewController.menuIndex) {
            menuItemActiveState[i] = false;
          } else {
            menuItemActiveState[i] = !menuItemActiveState[i];
          }
          if (widget.items[listViewController.menuIndex].type == DxSelectionType.more) {
            menuItemActiveState[i] = false;
          }
        }
      });
    }
  }

  @override
  dispose() {
    _scrollController?.removeListener(_closeSelectionPopupWindow);
    _refreshTitleSubscription.cancel();
    _closeSelectionPopupWindowSubscription.cancel();
    listViewController.hide();
    super.dispose();
  }

  /// 根据【Filter组】 创建 widget。
  OverlayEntry _createEntry(DxSelectionItem entity) {
    var content = _isRange(entity) ? _createRangeView(entity) : _createSelectionListView(entity);
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () => _closeSelectionPopupWindow(),
        child: Padding(
          padding: EdgeInsets.only(top: listViewController.listViewTop ?? 0),
          child: Stack(
            children: <Widget>[
              DxSelectionAnimationWidget(controller: listViewController, view: content),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: (widget.width != null) ? widget.width : MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 990,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _configMenuItems(),
            ),
          ),
          const Expanded(flex: 10, child: Divider(height: 0.5, color: DxStyle.$F0F0F0)),
        ],
      ),
    );
  }

  List<Widget> _configMenuItems() {
    List<Widget> itemViewList = [];
    itemViewList.add(const Padding(padding: EdgeInsets.only(left: 14)));
    for (int index = 0; index < titles.length; index++) {
      if (_needRefreshTitle) {
        _refreshSelectionMenuTitle(index, widget.items[index]);
        if (index == titles.length - 1) {
          _needRefreshTitle = false;
        }
      }
      itemViewList.add(const Padding(padding: EdgeInsets.only(left: 6)));
      itemViewList.add(DxSelectionMenuItemWidget(
        title: titles[index],
        themeData: widget.themeData,
        active: menuItemActiveState[index],
        isHighLight: menuItemActiveState[index] || menuItemHighlightState[index],

        /// 拦截 menuItem 点击
        itemClick: () {
          if (widget.onMenuItemClick != null) {
            if (widget.onMenuItemClick!(index)) {
              return;
            }
          }
          RenderBox? dropDownItemRenderBox;
          if (context.findRenderObject() != null && context.findRenderObject() is RenderBox) {
            dropDownItemRenderBox = context.findRenderObject() as RenderBox;
          }
          Offset? position = dropDownItemRenderBox?.localToGlobal(Offset.zero, ancestor: null);
          Size? size = dropDownItemRenderBox?.size;
          listViewController.listViewTop = (size?.height ?? 0) + (widget.constantTop ?? position?.dy ?? 0);
          if (listViewController.isShow && listViewController.menuIndex != index) {
            listViewController.hide();
          }

          if (listViewController.isShow) {
            listViewController.hide();
          } else {
            /// 点击不是 More、自定义类型，则直接展开。
            if (widget.items[index].type != DxSelectionType.more &&
                widget.items[index].type != DxSelectionType.customHandle) {
              /// 创建筛选组件的入口
              OverlayEntry entry = _createEntry(widget.items[index]);
              Overlay.of(widget.context)?.insert(entry);

              listViewController.entry = entry;
              listViewController.show(index);
            } else if (widget.items[index].type == DxSelectionType.customHandle) {
              /// 记录自定义筛选 menu 的点击状态，当点击自定义的 menu 时，menu 文案默认高亮。
              listViewController.show(index);
              _refreshSelectionMenuTitle(index, widget.items[index]);
            } else {
              _refreshSelectionMenuTitle(index, widget.items[index]);
            }
          }

          setState(() {
            for (int i = 0; i < menuItemActiveState.length; i++) {
              if (i != index) {
                menuItemActiveState[i] = false;
              } else {
                menuItemActiveState[i] = !menuItemActiveState[i];
              }
              if (widget.items[index].type == DxSelectionType.more) {
                menuItemActiveState[i] = false;
              }
            }
          });
        },
      ));
      itemViewList.add(const Padding(padding: EdgeInsets.only(left: 6)));
    }
    itemViewList.add(const Padding(padding: EdgeInsets.only(left: 14)));
    return itemViewList;
  }

  /// 1、子筛选项包含自定义范围的时候，使用 Tag 模式展示。
  /// 2、被指定为 Tag 模式展示。
  /// 3、只有一列筛选数据，且为多选时，使用 Tag 模式展示
  bool _isRange(DxSelectionItem entity) {
    if (DxSelectionUtil.hasRangeItem(entity.children) || entity.filterShowType == DxSelectionWindowType.range) {
      return true;
    }
    var totalLevel = DxSelectionUtil.getTotalLevel(entity);
    if (totalLevel == 1 && entity.type == DxSelectionType.checkbox) {
      return true;
    }
    return false;
  }

  Widget _createRangeView(DxSelectionItem entity) {
    int? rowCount;
    if (widget.configRowCount != null) {
      rowCount = widget.configRowCount!(widget.items.indexOf(entity), entity) ?? rowCount;
    }
    return DxSelectionRangeGroupWidget(
      item: entity,
      marginTop: listViewController.listViewTop ?? 0,
      maxContentHeight: designSelectionHeight / designScreenHeight * MediaQuery.of(context).size.height,
      // UI 给出的内容高度比例 248:812
      themeData: widget.themeData,
      rowCount: rowCount,
      bgClickFunction: () {
        setState(() {
          menuItemActiveState[listViewController.menuIndex] = false;
          if (entity.selectedListWithoutUnlimited().isNotEmpty) {
            menuItemHighlightState[listViewController.menuIndex] = true;
          }
          listViewController.hide();
        });
      },
      onSelectionConfirm: (DxSelectionItem result, int firstIndex, int secondIndex, int thirdIndex) {
        setState(() {
          _onConfirmSelect(entity, result, firstIndex, secondIndex, thirdIndex);
        });
      },
    );
  }

  Widget _createSelectionListView(DxSelectionItem entity) {
    /// 顶层筛选 Tab
    return DxSelectionListGroupWidget(
      item: entity,
      maxContentHeight: designSelectionHeight / designScreenHeight * MediaQuery.of(context).size.height,
      themeData: widget.themeData,
      // UI 给出的内容高度比例 248:812
      bgClickFunction: () {
        setState(() {
          menuItemActiveState[listViewController.menuIndex] = false;
          if (entity.selectedListWithoutUnlimited().isNotEmpty) {
            menuItemHighlightState[listViewController.menuIndex] = true;
          }
          listViewController.hide();
        });
      },
      onSelectionConfirm: (DxSelectionItem result, int firstIndex, int secondIndex, int thirdIndex) {
        setState(() {
          _onConfirmSelect(entity, result, firstIndex, secondIndex, thirdIndex);
        });
      },
    );
  }

  void _onConfirmSelect(
      DxSelectionItem entity, DxSelectionItem result, int firstIndex, int secondIndex, int thirdIndex) {
    if (listViewController.menuIndex < titles.length) {
      if (widget.onConfirm != null) {
        widget.onConfirm!(result, firstIndex, secondIndex, thirdIndex);
      }
      menuItemActiveState[listViewController.menuIndex] = false;
      _refreshSelectionMenuTitle(listViewController.menuIndex, entity);
      listViewController.hide();
    }
  }

  /// 筛选 Title 展示规则
  String? _getSelectedResultTitle(DxSelectionItem item) {
    /// 更多筛选不改变 title.故返回 null
    if (item.type == DxSelectionType.more) {
      return null;
    }
    if (DxTools.isEmpty(item.customTitle)) {
      return _getTitle(item);
    } else {
      return item.customTitle;
    }
  }

  String? _getTitle(DxSelectionItem entity) {
    String? title;
    List<DxSelectionItem> firstColumn = DxSelectionUtil.currentSelectListForEntity(entity);
    List<DxSelectionItem> secondColumn = [];
    List<DxSelectionItem> thirdColumn = [];
    if (firstColumn.isNotEmpty) {
      for (DxSelectionItem firstEntity in firstColumn) {
        secondColumn.addAll(DxSelectionUtil.currentSelectListForEntity(firstEntity));
        if (secondColumn.isNotEmpty) {
          for (DxSelectionItem secondEntity in secondColumn) {
            thirdColumn.addAll(DxSelectionUtil.currentSelectListForEntity(secondEntity));
          }
        }
      }
    }

    if (firstColumn.isEmpty || firstColumn.length > 1) {
      title = entity.title;
    } else {
      /// 第一列选中了一个，为【不限】类型，使用上一级别的名字展示。
      if (firstColumn[0].isUnLimit()) {
        title = entity.title;
      } else if (firstColumn[0].type == DxSelectionType.range ||
          firstColumn[0].type == DxSelectionType.date ||
          firstColumn[0].type == DxSelectionType.dateRange ||
          firstColumn[0].type == DxSelectionType.dateRangeCalendar) {
        title = _getDateAndRangeTitle(firstColumn, entity);
      } else {
        if (secondColumn.isEmpty || secondColumn.length > 1) {
          title = firstColumn[0].title;
        } else {
          /// 第二列选中了一个，为【不限】类型，使用上一级别的名字展示。
          if (secondColumn[0].isUnLimit()) {
            title = firstColumn[0].title;
          } else if (secondColumn[0].type == DxSelectionType.range ||
              secondColumn[0].type == DxSelectionType.date ||
              secondColumn[0].type == DxSelectionType.dateRange ||
              secondColumn[0].type == DxSelectionType.dateRangeCalendar) {
            title = _getDateAndRangeTitle(secondColumn, firstColumn[0]);
          } else {
            if (thirdColumn.isEmpty || thirdColumn.length > 1) {
              title = secondColumn[0].title;
            } else {
              /// 第三列选中了一个，为【不限】类型，使用上一级别的名字展示。
              if (thirdColumn[0].isUnLimit()) {
                title = secondColumn[0].title;
              } else if (thirdColumn[0].type == DxSelectionType.range ||
                  thirdColumn[0].type == DxSelectionType.date ||
                  thirdColumn[0].type == DxSelectionType.dateRange ||
                  thirdColumn[0].type == DxSelectionType.dateRangeCalendar) {
                title = _getDateAndRangeTitle(thirdColumn, secondColumn[0]);
              } else {
                title = thirdColumn[0].title;
              }
            }
          }
        }
      }
    }
    String joinTitle = _getJoinTitle(entity, firstColumn, secondColumn, thirdColumn);
    title = DxTools.isEmpty(joinTitle) ? title : joinTitle;
    return title;
  }

  String? _getDateAndRangeTitle(List<DxSelectionItem> list, DxSelectionItem entity) {
    String? title = '';
    if (!DxTools.isEmpty(list[0].customMap)) {
      if (list[0].type == DxSelectionType.range) {
        title = '${list[0].customMap!['min']}-${list[0].customMap!['max']}(${list[0].extMap['unit']?.toString()})';
      } else if (list[0].type == DxSelectionType.dateRange || list[0].type == DxSelectionType.dateRangeCalendar) {
        title = _getDateRangeTitle(list);
      }
    } else {
      if (list[0].type == DxSelectionType.date) {
        title = _getDateTimeTitle(list);
      } else {
        title = entity.title;
      }
    }
    return title;
  }

  String _getDateRangeTitle(List<DxSelectionItem> list) {
    String minDateTime = '';
    String maxDateTime = '';

    if (list[0].customMap != null &&
        list[0].customMap!['min'] != null &&
        int.tryParse(list[0].customMap!['min'] ?? '') != null) {
      DateTime? minDate = DateTimeFormatter.convertIntValueToDateTime(list[0].customMap!['min']);
      if (minDate != null) {
        minDateTime = DateTimeFormatter.formatDate(minDate, 'yyyy年MM月dd日');
      }
    }
    if (list[0].customMap != null &&
        list[0].customMap!['max'] != null &&
        int.tryParse(list[0].customMap!['max'] ?? '') != null) {
      DateTime? maxDate = DateTimeFormatter.convertIntValueToDateTime(list[0].customMap!['max']);
      if (maxDate != null) {
        maxDateTime = DateTimeFormatter.formatDate(maxDate, 'yyyy年MM月dd日');
      }
    }
    return '$minDateTime-$maxDateTime';
  }

  String? _getDateTimeTitle(List<DxSelectionItem> list) {
    String? title = "";
    int? msDateTime = int.tryParse(list[0].value ?? '');
    title = msDateTime != null
        ? DateTimeFormatter.formatDate(DateTime.fromMillisecondsSinceEpoch(msDateTime), 'yyyy年MM月dd日')
        : list[0].title;
    return title;
  }

  String _getJoinTitle(DxSelectionItem entity, List<DxSelectionItem> firstColumn, List<DxSelectionItem> secondColumn,
      List<DxSelectionItem> thirdColumn) {
    String title = "";
    if (entity.canJoinTitle) {
      if (firstColumn.length == 1) {
        title = firstColumn[0].title;
      }
      if (secondColumn.length == 1) {
        title += secondColumn[0].title;
      }
      if (thirdColumn.length == 1) {
        title += thirdColumn[0].title;
      }
    }
    return title;
  }

  void _refreshSelectionMenuTitle(int index, DxSelectionItem entity) {
    if (entity.type == DxSelectionType.more) {
      if (entity.allSelectedList().isNotEmpty) {
        menuItemHighlightState[index] = true;
      } else {
        menuItemHighlightState[index] = false;
      }
      return;
    }
    String? title = _getSelectedResultTitle(entity);
    if (title != null) {
      titles[index] = title;
    }
    if (entity.selectedListWithoutUnlimited().isNotEmpty) {
      menuItemHighlightState[index] = true;
    } else if (!DxTools.isEmpty(entity.customTitle)) {
      menuItemHighlightState[index] = entity.isCustomTitleHighLight;
    } else {
      menuItemHighlightState[index] = false;
    }
  }
}
