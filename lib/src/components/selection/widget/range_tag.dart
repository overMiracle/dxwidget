import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

/// /// /// /// /// /// /// /// /// /
/// 描述: 多选 tag 组件
/// /// /// /// /// /// /// /// /// /
class DxSelectionRangeTagWidget extends StatefulWidget {
  //tag 显示的文本
  @required
  final List<DxSelectionItem> tagFilterList;

  //初始选中的 Index 列表
  final List<bool>? initSelectStatus;

  //选择tag的回调
  final void Function(int, bool)? onSelect;
  final double spacing;
  final double verticalSpacing;
  final int tagWidth;
  final double tagHeight;
  final int initFocusedIndex;

  final DxSelectionThemeData themeData;

  const DxSelectionRangeTagWidget({
    Key? key,
    required this.tagFilterList,
    this.initSelectStatus,
    this.onSelect,
    this.spacing = 12,
    this.verticalSpacing = 10,
    this.tagWidth = 75,
    this.tagHeight = 34,
    required this.themeData,
    this.initFocusedIndex = -1,
  }) : super(key: key);

  @override
  State<DxSelectionRangeTagWidget> createState() => _DxSelectionRangeTagWidgetState();
}

class _DxSelectionRangeTagWidgetState extends State<DxSelectionRangeTagWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: widget.verticalSpacing,
      spacing: widget.spacing,
      children: _tagWidgetList(context),
    );
  }

  List<Widget> _tagWidgetList(context) {
    List<Widget> list = [];
    for (int nameIndex = 0; nameIndex < widget.tagFilterList.length; nameIndex++) {
      Widget tagWidget = _tagWidgetAtIndex(nameIndex);
      GestureDetector gdt = GestureDetector(
          child: tagWidget,
          onTap: () {
            var selectedEntity = widget.tagFilterList[nameIndex];
            DxSelectionUtil.processBrotherItemSelectStatus(selectedEntity);
            if (null != widget.onSelect) {
              widget.onSelect!(nameIndex, selectedEntity.isSelected);
            }
            setState(() {});
          });
      list.add(gdt);
    }
    return list;
  }

  Widget _tagWidgetAtIndex(int nameIndex) {
    bool selected = widget.tagFilterList[nameIndex].isSelected || nameIndex == widget.initFocusedIndex;
    String text = widget.tagFilterList[nameIndex].title;
    if (widget.tagFilterList[nameIndex].type == DxSelectionType.date &&
        !DxTools.isEmpty(widget.tagFilterList[nameIndex].value)) {
      if (int.tryParse(widget.tagFilterList[nameIndex].value ?? '') != null) {
        DateTime? dateTime = DateTimeFormatter.convertIntValueToDateTime(widget.tagFilterList[nameIndex].value);
        if (dateTime != null) {
          text = DateTimeFormatter.formatDate(dateTime, 'yyyy年MM月dd日');
        }
      } else {
        text = widget.tagFilterList[nameIndex].value ?? '';
      }
    }

    Text tx = Text(text, style: selected ? widget.themeData.tagSelectedTextStyle : widget.themeData.tagNormalTextStyle);
    Container tagItem = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? widget.themeData.tagSelectedBackgroundColor : widget.themeData.tagNormalBackgroundColor,
        borderRadius: BorderRadius.circular(widget.themeData.tagRadius),
      ),
      width: widget.tagWidth.toDouble(),
      height: widget.tagHeight,
      child: tx,
    );
    return tagItem;
  }
}
