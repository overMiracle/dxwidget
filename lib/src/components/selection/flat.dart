import 'dart:async';

import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 支持tag 、输入 、range、选择等类型混合一级筛选
/// 也可支持点击选项跳转二级页面

// ignore: must_be_immutable
class DxFlatSelection extends StatefulWidget {
  /// 筛选原始数据
  final List<DxSelectionItem> items;

  /// 点击确定回调
  final Function(Map<String, String>)? confirmCallback;

  /// 每行展示tag数量  默认是3个
  final int rowCount;

  /// 当[DxSelectionItem.filterType]为[DxSelectionFilterType.layer] or[DxSelectionFilterType.customLayer]时
  /// 跳转到二级页面的自定义操作
  final DxOnCustomFloatingLayerClick? onCustomFloatingLayerClick;

  /// controller.dispose() 操作交由外部处理
  final DxFlatSelectionController? controller;

  /// 是否需要配置子选项
  final bool isNeedConfigChild;

  /// 主题配置
  /// 如有对文本样式、圆角、间距等[DxSelectionConfig]有特定要求可以配置该属性
  DxSelectionThemeData? themeData;

  DxFlatSelection({
    Key? key,
    required this.items,
    this.confirmCallback,
    this.onCustomFloatingLayerClick,
    this.rowCount = 3,
    this.isNeedConfigChild = true,
    this.controller,
    this.themeData,
  }) : super(key: key) {
    themeData = DxSelectionThemeData().merge(themeData);
  }

  @override
  State<DxFlatSelection> createState() => _DxFlatSelectionState();
}

class _DxFlatSelectionState extends State<DxFlatSelection> with SingleTickerProviderStateMixin {
  final List<DxSelectionItem> _originalSelectedItemsList = [];

  StreamController<FlatClearEvent> clearController = StreamController.broadcast();
  bool isValid = true;

  double _lineWidth = 0.0;

  @override
  void initState() {
    super.initState();

    if (widget.isNeedConfigChild) {
      for (var f in widget.items) {
        f.configRelationshipAndDefaultValue();
      }
    }
    widget.controller?.addListener(_handleFlatControllerTick);

    List<DxSelectionItem> firstColumn = [];
    if (widget.items.isNotEmpty) {
      for (DxSelectionItem entity in widget.items) {
        if (entity.isSelected) {
          firstColumn.add(entity);
        }
      }
    }
    _originalSelectedItemsList.addAll(firstColumn);
    if (firstColumn.isNotEmpty) {
      for (DxSelectionItem firstEntity in firstColumn) {
        List<DxSelectionItem> secondColumn = DxSelectionUtil.currentSelectListForEntity(firstEntity);
        _originalSelectedItemsList.addAll(secondColumn);
        if (secondColumn.isNotEmpty) {
          for (DxSelectionItem secondEntity in secondColumn) {
            List<DxSelectionItem> thirdColumn = DxSelectionUtil.currentSelectListForEntity(secondEntity);
            _originalSelectedItemsList.addAll(thirdColumn);
          }
        }
      }
    }

    for (DxSelectionItem entity in _originalSelectedItemsList) {
      entity.isSelected = true;
      if (entity.customMap != null) {
        // originalCustomMap 是用来存临时状态数据, customMap 用来展示 ui
        entity.originalCustomMap = Map.from(entity.customMap!);
      }
    }
  }

  void _handleFlatControllerTick() {
    if (widget.controller?.isResetSelectedOptions ?? false) {
      if (mounted) {
        setState(() {
          _resetSelectedOptions();
        });
      }
      widget.controller?.isResetSelectedOptions = false;
    } else if (widget.controller?.isCancelSelectedOptions ?? false) {
      // 外部关闭调用无UI更新操作
      _cancelSelectedOptions();
      widget.controller?.isCancelSelectedOptions = false;
    } else if (widget.controller?.isConfirmSelectedOptions ?? false) {
      _confirmSelectedOptions();
      widget.controller?.isConfirmSelectedOptions = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (size) {
        setState(() {
          _lineWidth = size.width;
        });
      },
      child: _buildSelectionListView(),
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleFlatControllerTick);
    super.dispose();
  }

  /// 取消
  _cancelSelectedOptions() {
    if (widget.items.isEmpty) {
      return;
    }
    for (DxSelectionItem entity in widget.items) {
      DxSelectionUtil.resetSelectionData(entity);
    }
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
  }

  /// 重置
  _resetSelectedOptions() {
    clearController.add(FlatClearEvent());
    if (widget.items.isNotEmpty) {
      for (DxSelectionItem entity in widget.items) {
        _clearUIData(entity);
      }
    }
  }

  /// 确定
  void _confirmSelectedOptions() {
    _clearSelectedEntity();
    if (!isValid) {
      isValid = true;
      return;
    }

    for (var data in widget.items) {
      data.isSelected = data.selectedList().isNotEmpty ? true : false;
    }
    if (widget.confirmCallback != null) {
      widget.confirmCallback!(const DefaultSelectionConverter().convertSelectedData(widget.items));
    }
  }

  /// 标题+筛选条件的 列表
  Widget _buildSelectionListView() {
    var contentWidget = Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        child: ScrollConfiguration(
          behavior: DxNoScrollBehavior(),
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return DxFlatMoreSelection(
                clearController: clearController,
                selectionEntity: widget.items[index],
                onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick,
                rowCount: widget.rowCount,
                parentWidth: _lineWidth,
                themeData: widget.themeData!,
              );
            },
            itemCount: widget.items.length,
          ),
        ),
      ),
    );

    return contentWidget;
  }

  /// 清空UI效果
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

  void _clearSelectedEntity() {
    List<DxSelectionItem> tmp = [];
    DxSelectionItem node;
    tmp.addAll(widget.items);
    while (tmp.isNotEmpty) {
      node = tmp.removeLast();
      if (!node.isValidRange()) {
        isValid = false;
        DxToast.show('您输入的区间有误');
        return;
      }
      for (var data in node.children) {
        tmp.add(data);
      }
    }
  }
}

typedef OnWidgetSizeChange = void Function(Size size);

/// 描述: 计算 Widget 宽高的工具类。
class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = Size.zero;
    if (child != null) {
      newSize = child!.size;
    }
    if (oldSize == newSize) return;

    oldSize = newSize;

    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}
