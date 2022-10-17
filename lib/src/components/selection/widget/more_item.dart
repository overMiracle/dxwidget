import 'dart:async';

import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///更多的筛选项里面的single 项
///主要是分为两种：标签（楼层）和跳到其他页面的layer（商圈）
///标签类型包罗了：标题、有无更多的展开收起、自定义输入、标签项
///页面类型保罗了：标题、选择框
class DxSelectionMoreWidget extends StatefulWidget {
  //entity 是商圈、钥匙等
  final DxSelectionItem selectionEntity;
  final StreamController<ClearEvent>? clearController;
  final DxOnCustomFloatingLayerClick? onCustomFloatingLayerClick;
  final DxSelectionThemeData themeData;

  const DxSelectionMoreWidget({
    Key? key,
    required this.selectionEntity,
    this.clearController,
    this.onCustomFloatingLayerClick,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionMoreWidget> createState() => _DxSelectionMoreWidgetState();
}

class _DxSelectionMoreWidgetState extends State<DxSelectionMoreWidget> {
  @override
  Widget build(BuildContext context) {
    //弹出浮层
    if (widget.selectionEntity.type == DxSelectionType.layer ||
        widget.selectionEntity.type == DxSelectionType.customLayer) {
      return FilterLayerTypeWidget(
        selectionEntity: widget.selectionEntity,
        onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick,
        themeData: widget.themeData,
      );
    }
    //标签类型
    return _FilterCommonTypeWidget(
      selectionEntity: widget.selectionEntity,
      clearController: widget.clearController,
      themeData: widget.themeData,
    );
  }
}

/// 展示标签的布局：标题+更多+标签+自定义
class _FilterCommonTypeWidget extends StatefulWidget {
  //楼层
  final DxSelectionItem selectionEntity;
  final StreamController<ClearEvent>? clearController;
  final DxSelectionThemeData themeData;

  const _FilterCommonTypeWidget({
    Key? key,
    required this.selectionEntity,
    this.clearController,
    required this.themeData,
  }) : super(key: key);

  @override
  State<_FilterCommonTypeWidget> createState() => __FilterCommonTypeWidgetState();
}

class __FilterCommonTypeWidgetState extends State<_FilterCommonTypeWidget> {
  bool isExpanded = false;

  ///展开收起的通知
  late ValueNotifier valueNotifier;

  ///用于 range和 tag 之间通信
  late StreamController<Event> streamController;

  @override
  void initState() {
    super.initState();
    streamController = StreamController.broadcast();

    //如果是输入事件
    //如果是单选的情况，将选中的tag清空
    //如果是多选则，不作处理
    streamController.stream.listen((event) {
      if (event is InputEvent) {
        setState(() {
          if (!event.filter) {
            //将所有tag设置为未选中
            event.rangeEntity.parent?.currentTagListForEntity().forEach((data) {
              data.clearSelectedEntity();
            });
          }
        });
      }
    });

    //展开收起的事件
    valueNotifier = ValueNotifier(isExpanded);
    valueNotifier.addListener(() {
      setState(() {
        isExpanded = valueNotifier.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, right: _isVisibleMore() ? 40 : 0),
                child: _buildTitleWidget(),
              ),
              //自定义输入框
              _buildRangeWidget(),
              //标签的筛选条件
              Visibility(
                visible: widget.selectionEntity.currentShowTagByExpanded(isExpanded).isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _buildSelectionTag(),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
              visible: _isVisibleMore(),
              child: _MoreArrow(
                valueNotifier: valueNotifier,
                themeData: widget.themeData,
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isVisibleMore() {
    return widget.selectionEntity.currentTagListForEntity().length > widget.selectionEntity.getDefaultShowCount();
  }

  ///标题和更多，比如商圈
  ///更多的展示逻辑：可展示的标签>默认展示的标签
  ///比如 后端下发 默认展示3个，但是可展示的只有2个，则不展示更多
  ///可展示标签：目前的逻辑为：非自定义的项
  Widget _buildTitleWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.selectionEntity.title,
            style: widget.themeData.titleForMoreTextStyle,
          ),
        ),
      ],
    );
  }

  /// 自定义筛选条件的显示
  Widget _buildRangeWidget() {
    return widget.selectionEntity.currentRangeListForEntity().isEmpty
        ? const SizedBox.shrink()
        : _MoreRangeWidget(
            themeData: widget.themeData,
            streamController: streamController,
            clearController: widget.clearController,
            rangeEntity: widget.selectionEntity.currentRangeListForEntity()[0],
          );
  }

  /// 标签的筛选条件显示  单选和多选是由 父节点控制
  /// 如果是单选： 先将选中的清空、再添加选中
  /// 如果是多选： 直接添加筛选项
  Widget _buildSelectionTag() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      addRepaintBoundaries: false,
      childAspectRatio: 2.4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.selectionEntity.currentShowTagByExpanded(isExpanded).map((DxSelectionItem data) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (data.type == DxSelectionType.radio) {
                data.parent?.clearSelectedEntity();
                data.isSelected = true;
                //用于发送 标签点击事件
                streamController.add(SelectEvent());
              } else if (data.type == DxSelectionType.checkbox) {
                if (!data.isSelected) {
                  if (!DxSelectionUtil.checkMaxSelectionCount(data)) {
                    DxToast.show('您选择的筛选条件数量已达上限');
                    return;
                  }
                }

                data.parent?.children
                    .where((_) => _.type == DxSelectionType.radio)
                    .forEach((f) => f.isSelected = false);
                data.isSelected = !data.isSelected;
                //用于发送 标签点击事件
                streamController.add(SelectEvent());
              } else if (data.type == DxSelectionType.date) {
                _showDatePicker(data);
              }
            });
          },
          child: _buildSingleTag(data),
        );
      }).toList(),
    );
  }

  Widget _buildSingleTag(DxSelectionItem entity) {
    bool isDate = entity.type == DxSelectionType.date;

    String? showName;

    if (isDate) {
      if (DxTools.isEmpty(entity.value)) {
        showName = entity.title;
      } else {
        int time = int.tryParse(entity.value ?? "") ?? DateTime.now().millisecondsSinceEpoch;
        showName = DateTimeFormatter.formatDate(DateTime.fromMillisecondsSinceEpoch(time), 'yyyy/MMMM/dd');
      }
    } else {
      showName = entity.title;
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: entity.isSelected
              ? widget.themeData.tagSelectedBackgroundColor
              : widget.themeData.tagNormalBackgroundColor,
          borderRadius: BorderRadius.circular(widget.themeData.tagRadius)),
      height: 34,
      child: Text(
        showName,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: entity.isSelected ? _selectedTextStyle() : _tagTextStyle(),
      ),
    );
  }

  TextStyle _tagTextStyle() {
    return widget.themeData.tagNormalTextStyle;
  }

  TextStyle _selectedTextStyle() {
    return widget.themeData.tagSelectedTextStyle;
  }

  void _showDatePicker(DxSelectionItem data) {
    int time = int.tryParse(data.value ?? "") ?? DateTime.now().millisecondsSinceEpoch;
    DxDatePicker.show(context,
        pickerMode: DxDateTimePickerMode.date,
        initialDateTime: DateTime.fromMillisecondsSinceEpoch(time),
        dateFormat: 'yyyy年,MMMM月,dd日', onConfirm: (dateTime, list) {
      if (mounted) {
        setState(() {
          data.parent?.clearSelectedEntity();
          data.isSelected = true;
          data.value = dateTime.millisecondsSinceEpoch.toString();
        });
      }
    }, onChange: (dateTime, list) {}, onCancel: () {}, onClose: () {});
  }
}

/// 更多和箭头widget
class _MoreArrow extends StatefulWidget {
  ///用于通知 展开和收起
  final ValueNotifier? valueNotifier;

  final DxSelectionThemeData themeData;

  const _MoreArrow({
    Key? key,
    this.valueNotifier,
    required this.themeData,
  }) : super(key: key);

  @override
  __MoreArrowState createState() => __MoreArrowState();
}

class __MoreArrowState extends State<_MoreArrow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String asset = isExpanded ? DxAsset.arrowUp : DxAsset.arrowDown;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          if (widget.valueNotifier != null) {
            widget.valueNotifier!.value = isExpanded;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '更多',
              style: widget.themeData.moreTextStyle,
            ),
            Container(
              height: 16,
              width: 16,
              padding: const EdgeInsets.only(left: 4),
              child: Image.asset(asset),
            )
          ],
        ),
      ),
    );
  }
}

/// 自定义筛选条件
class _MoreRangeWidget extends StatefulWidget {
  ///用于标签和自定义输入 通信
  final StreamController? streamController;

  ///用于自定义的筛选条件 最大值最小值
  final DxSelectionItem rangeEntity;

  ///用于监听重置事件
  final StreamController<ClearEvent>? clearController;

  final DxSelectionThemeData themeData;

  const _MoreRangeWidget({
    Key? key,
    required this.rangeEntity,
    this.streamController,
    this.clearController,
    required this.themeData,
  }) : super(key: key);

  @override
  State<_MoreRangeWidget> createState() => __MoreRangeWidgetState();
}

class __MoreRangeWidgetState extends State<_MoreRangeWidget> {
  //最小值 输入框监听
  TextEditingController minController = TextEditingController();

  //最大值 输入框监听
  TextEditingController maxController = TextEditingController();

  //最小值 焦点监听
  FocusNode minFocusNode = FocusNode();

  //最大值 焦点监听
  FocusNode maxFocusNode = FocusNode();

  //默认的最大值
  late int max;

  //默认的最小值
  late int min;

  @override
  void initState() {
    super.initState();

    widget.clearController?.stream.listen((event) {
      minController.clear();
      maxController.clear();
    });

    widget.rangeEntity.customMap ??= <String, String>{};

    minController.text = widget.rangeEntity.customMap!['min']?.toString() ?? '';
    maxController.text = widget.rangeEntity.customMap!['max']?.toString() ?? '';

    min = int.tryParse(widget.rangeEntity.extMap['min']?.toString() ?? "") ?? 0;
    max = int.tryParse(widget.rangeEntity.extMap['max']?.toString() ?? "") ?? 9999;

    ///处理的逻辑：
    ///       1：将输入框的 文本写入 customMap中
    ///       2：如果最大值和最小值满足条件 则将range选中
    minController.addListener(() {
      if (widget.rangeEntity.type != DxSelectionType.range) {
        return;
      }
      String minInput = minController.text;

      widget.rangeEntity.customMap ??= {};

      widget.rangeEntity.customMap!['min'] = minInput;

      widget.rangeEntity.isSelected = true;
    });

    maxController.addListener(() {
      if (widget.rangeEntity.type != DxSelectionType.range) {
        return;
      }
      String maxInput = maxController.text;
      widget.rangeEntity.customMap ??= {};

      widget.rangeEntity.customMap!['max'] = maxInput;

      widget.rangeEntity.isSelected = true;
    });

    ///只要获取了焦点
    ///        如果是单选 则将选中的清楚
    ///        如果是多选 则不处理
    minFocusNode.addListener(() {
      if (minFocusNode.hasFocus) {
        widget.streamController?.add(InputEvent(filter: false, rangeEntity: widget.rangeEntity));
      }
    });

    maxFocusNode.addListener(() {
      if (maxFocusNode.hasFocus) {
        widget.streamController?.add(InputEvent(filter: false, rangeEntity: widget.rangeEntity));
      }
    });

    ///用于监听tab的点击事件
    ///如果父亲是单选 则将输入框清空并失去焦点，并且将自定义筛选设置为 未选中,以及更新用于显示的map
    widget.streamController?.stream.listen((event) {
      if (event is SelectEvent) {
        maxController.clear();
        minController.clear();
        widget.rangeEntity.customMap?.remove('min');
        widget.rangeEntity.customMap?.remove('max');
        minFocusNode.unfocus();
        maxFocusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rangeEntity.type == DxSelectionType.dateRange) {
      return DxSelectionDateRangeItemWidget(
          item: widget.rangeEntity,
          isNeedTitle: false,
          showTextSize: 14,
          dateFormat: datetimePickerDateFormat,
          minTextEditingController: minController,
          maxTextEditingController: maxController,
          themeData: widget.themeData,
          onTapped: () {
            //点击选择框通知标签清空
            widget.streamController?.add(InputEvent(filter: false, rangeEntity: widget.rangeEntity));
          });
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _buildRangeField('最小值', minController, minFocusNode, widget.themeData),
          ),
          Container(
//          height: 38,
            alignment: Alignment.center,
            child: Text(
              '至',
              textAlign: TextAlign.center,
              style: widget.themeData.inputTextStyle,
            ),
          ),
          Expanded(
            child: _buildRangeField('最大值', maxController, maxFocusNode, widget.themeData),
          ),
        ],
      );
    }
  }

  Widget _buildRangeField(
    String hint,
    TextEditingController textEditingController,
    FocusNode focusNode,
    DxSelectionThemeData themeData,
  ) {
    return Center(
      child: TextField(
        focusNode: focusNode,
        textAlign: TextAlign.center,
        controller: textEditingController,
        cursorColor: DxStyle.$0984F9,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: widget.themeData.inputTextStyle,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: widget.themeData.hintTextStyle,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(widget.themeData.tagRadius),
            borderSide: const BorderSide(width: 1, color: DxStyle.$F0F0F0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(widget.themeData.tagRadius),
            borderSide: const BorderSide(width: 1, color: DxStyle.$F0F0F0),
          ),
        ),
      ),
    );
  }
}
