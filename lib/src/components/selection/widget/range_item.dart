import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 清空自定义范围输入框焦点的事件类
class ClearSelectionFocusEvent {}

class DxSelectionRangeItemWidget extends StatefulWidget {
  final DxSelectionItem item;

  final RangeChangedCallback? onRangeChanged;
  final ValueChanged<bool>? onFocusChanged;

  final bool isShouldClearText;

  final TextEditingController minTextEditingController;
  final TextEditingController maxTextEditingController;

  final DxSelectionThemeData themeData;

  const DxSelectionRangeItemWidget({
    Key? key,
    required this.item,
    required this.minTextEditingController,
    required this.maxTextEditingController,
    this.isShouldClearText = false,
    this.onRangeChanged,
    this.onFocusChanged,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionRangeItemWidget> createState() => _DxSelectionRangeItemWidgetState();
}

class _DxSelectionRangeItemWidgetState extends State<DxSelectionRangeItemWidget> {
  final FocusNode _minFocusNode = FocusNode();
  final FocusNode _maxFocusNode = FocusNode();

  @override
  void initState() {
    widget.minTextEditingController.text = (widget.item.customMap != null && widget.item.customMap!['min'] != null)
        ? widget.item.customMap!['min']?.toString() ?? ''
        : '';
    widget.maxTextEditingController.text = (widget.item.customMap != null && widget.item.customMap!['max'] != null)
        ? widget.item.customMap!['max']?.toString() ?? ''
        : '';

    //输入框焦点
    _minFocusNode.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged!(_minFocusNode.hasFocus || _maxFocusNode.hasFocus);
      }
    });

    _maxFocusNode.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged!(_minFocusNode.hasFocus || _maxFocusNode.hasFocus);
      }
    });

    widget.minTextEditingController.addListener(() {
      String minInput = widget.minTextEditingController.text;

      widget.item.customMap ??= {};
      widget.item.customMap!['min'] = minInput;
      widget.item.isSelected = true;
    });

    widget.maxTextEditingController.addListener(() {
      String maxInput = widget.maxTextEditingController.text;
      widget.item.customMap ??= {};
      widget.item.customMap!['max'] = maxInput;
      widget.item.isSelected = true;
    });

    DxEventBus.instance.on<ClearSelectionFocusEvent>().listen((ClearSelectionFocusEvent event) {
      _minFocusNode.unfocus();
      _maxFocusNode.unfocus();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "${widget.item.title.isNotEmpty ? widget.item.title : '自定义区间'}(${widget.item.extMap['unit']?.toString() ?? ''})",
              textAlign: TextAlign.left,
              style: widget.themeData.rangeTitleTextStyle,
            ),
          ),
          Row(
            children: <Widget>[
              getRangeTextField(false),
              Text(
                '至',
                style: widget.themeData.inputTextStyle,
              ),
              getRangeTextField(true),
            ],
          )
        ],
      ),
    );
  }

  Widget getRangeTextField(bool isMax) {
    return Expanded(
      child: TextFormField(
        style: widget.themeData.inputTextStyle,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: const TextInputType.numberWithOptions(),
        onChanged: (input) {
          widget.item.isSelected = true;
        },
        focusNode: isMax ? _maxFocusNode : _minFocusNode,
        controller: isMax ? widget.maxTextEditingController : widget.minTextEditingController,
        cursorColor: DxStyle.$0984F9,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintStyle: widget.themeData.hintTextStyle,
          hintText: (isMax ? '最大值' : '最小值'),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: DxStyle.$F0F0F0)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: DxStyle.$F0F0F0)),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
