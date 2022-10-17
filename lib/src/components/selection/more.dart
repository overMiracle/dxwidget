import 'dart:async';

import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:flutter/material.dart';

/// 更多的多选页面
/// 展示的内容：
///         1：以纯标签的形式展示筛选条件 比如：朝向
///         2：以可点击的layout 展示跳转至列表页面 比如：商圈
///         3：以标签和自定义的输入展示筛选条件 比如：面积
///
/// 筛选条件的单选多选判定规则是：父节点的 type 决定子节点的单选多选类型
///                          子节点的 type 决定了自己的展示UI
/// 比如 楼层，楼层节点的type是radio，那么 一层、二层都是 只能选中一个
///                               如果他的某个子节点是range type， 该子节点的展示是自定义输入
///
///
/// 参考[DxSelectionItem]和[DxSelectionView]
class DxSelectionMorePage extends StatefulWidget {
  final DxSelectionItem item;
  final Function(DxSelectionItem)? confirmCallback;
  final DxOnCustomFloatingLayerClick? onCustomFloatingLayerClick;
  final DxSelectionThemeData themeData;

  const DxSelectionMorePage({
    Key? key,
    required this.item,
    this.confirmCallback,
    this.onCustomFloatingLayerClick,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionMorePage> createState() => _DxSelectionMorePageState();
}

class _DxSelectionMorePageState extends State<DxSelectionMorePage> with SingleTickerProviderStateMixin {
  final List<DxSelectionItem> _originalSelectedItemsList = [];
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final StreamController<ClearEvent> _clearController = StreamController.broadcast();
  bool isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween(end: Offset.zero, begin: const Offset(1.0, 0.0)).animate(_controller);
    _controller.forward();

    _originalSelectedItemsList.addAll(widget.item.allSelectedList());
    for (DxSelectionItem entity in _originalSelectedItemsList) {
      entity.isSelected = true;
      if (entity.customMap != null) {
        // originalCustomMap 是用来存临时状态数据, customMap 用来展示 ui
        entity.originalCustomMap = Map.from(entity.customMap!);
      }
    }
  }

  /// 页面结构：左侧的透明黑 + 右侧宽为300的内容区域
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x660c0c0c),
      body: Row(
        children: <Widget>[
          _buildLeftSlide(context),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => SlideTransition(position: _animation, child: child),
            child: _buildRightSlide(context),
          )
        ],
      ),
      //为了解决 键盘抬起按钮的问题 将按钮移动到 此区域
      bottomNavigationBar: SizedBox(
        height: 80 + _getBottomAreaHeight(),
        child: Row(
          children: <Widget>[
            _buildLeftSlide(context),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => SlideTransition(position: _animation, child: child),
              child: Container(
                width: 300,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    const Divider(),
                    Padding(padding: const EdgeInsets.only(top: 14), child: _buildBottomButtons()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _clearController.close();
    super.dispose();
  }

  /// 左侧为透明黑，点击直接退出页面
  Widget _buildLeftSlide(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          DxSelectionUtil.resetSelectionData(widget.item);
          //把数据还原
          for (var data in _originalSelectedItemsList) {
            data.isSelected = true;
            if (data.customMap != null) {
              // originalCustomMap 是用来存临时状态数据, customMap 用来展示 ui
              data.customMap = <String, String>{};
              data.originalCustomMap.forEach((key, value) {
                data.customMap![key.toString()] = value.toString();
              });
            }
          }
          Navigator.maybePop(context);
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  /// 右侧为内容区域：标题+更多+筛选项的列表 + 底部按钮区域
  Widget _buildRightSlide(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: _buildSelectionListView(),
      ),
    );
  }

  /// 标题+筛选条件的 列表
  Widget _buildSelectionListView() {
    return ScrollConfiguration(
      behavior: DxNoScrollBehavior(),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return DxSelectionMoreWidget(
              clearController: _clearController,
              selectionEntity: widget.item.children[index],
              onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick,
              themeData: widget.themeData);
        },
        itemCount: widget.item.children.length,
      ),
    );
  }

  /// 清空筛选项 + 确定按钮
  Widget _buildBottomButtons() {
    return DxSelectionMoreBottomWidget(
      item: widget.item,
      themeData: widget.themeData,
      clearCallback: () {
        setState(() {
          _clearController.add(ClearEvent());
          _clearUIData(widget.item);
        });
      },
      conformCallback: (data) {
        checkValue(data);
        if (!isValid) {
          isValid = true;
          return;
        }
        for (var data in widget.item.children) {
          data.isSelected = data.selectedList().isNotEmpty ? true : false;
        }
        widget.confirmCallback?.call(data);
        Navigator.of(context).pop();
      },
    );
  }

  //清空UI效果
  void _clearUIData(DxSelectionItem entity) {
    entity.isSelected = false;
    entity.customMap = <String, String>{};
    if (DxSelectionType.range == entity.type) {
      entity.title = '';
    }
    for (DxSelectionItem subEntity in entity.children) {
      _clearUIData(subEntity);
    }
  }

  void checkValue(DxSelectionItem entity) {
    clearSelectedEntity();
  }

  void clearSelectedEntity() {
    List<DxSelectionItem> tmp = [];
    DxSelectionItem node = widget.item;
    tmp.add(node);
    while (tmp.isNotEmpty) {
      node = tmp.removeLast();
      if (node.isSelected &&
          (node.type == DxSelectionType.range ||
              node.type == DxSelectionType.dateRange ||
              node.type == DxSelectionType.dateRangeCalendar)) {
        if (node.customMap != null &&
            !DxTools.isEmpty(node.customMap!['min']) &&
            !DxTools.isEmpty(node.customMap!['max'])) {
          if (!node.isValidRange()) {
            isValid = false;
            if (node.type == DxSelectionType.range) {
              DxToast.show('您输入的区间有误');
            } else if (node.type == DxSelectionType.dateRange || node.type == DxSelectionType.dateRangeCalendar) {
              DxToast.show('您选择的区间有误');
            }
            return;
          }
        } else {
          node.isSelected = false;
        }
      }
      for (var data in node.children) {
        tmp.add(data);
      }
    }
  }

  double _getBottomAreaHeight() {
    return MediaQuery.of(context).padding.bottom;
  }
}
