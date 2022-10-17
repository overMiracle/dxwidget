import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date/date_widget.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String _defaultDateFormat = 'yyyy年MM月dd日';

class DxSelectionDateRangeItemWidget extends StatefulWidget {
  final DxSelectionItem item;

  /// 输入框显示文字大小
  final double showTextSize;

  /// 是否需要标题
  final bool isNeedTitle;

  /// 日期格式
  final String dateFormat;

  final TextEditingController minTextEditingController;
  final TextEditingController maxTextEditingController;

  final VoidCallback? onTapped;

  final DxSelectionThemeData themeData;

  const DxSelectionDateRangeItemWidget({
    Key? key,
    required this.item,
    required this.minTextEditingController,
    required this.maxTextEditingController,
    this.isNeedTitle = true,
    this.showTextSize = 16,
    this.dateFormat = _defaultDateFormat,
    this.onTapped,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionDateRangeItemWidget> createState() => _DxSelectionDateRangeItemWidgetState();
}

class _DxSelectionDateRangeItemWidgetState extends State<DxSelectionDateRangeItemWidget> {
  final DxSelectionDatePickerController _datePickerController = DxSelectionDatePickerController();

  @override
  void initState() {
    DateTime? minDateTime;
    if (widget.item.customMap != null && widget.item.customMap!['min'] != null) {
      minDateTime = DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['min']);
    }
    DateTime? maxDateTime;
    if (widget.item.customMap != null && widget.item.customMap!['max'] != null) {
      maxDateTime = DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['max']);
    }
    widget.minTextEditingController.text =
        minDateTime != null ? DateTimeFormatter.formatDate(minDateTime, widget.dateFormat) : '';
    widget.maxTextEditingController.text =
        maxDateTime != null ? DateTimeFormatter.formatDate(maxDateTime, widget.dateFormat) : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          widget.isNeedTitle
              ? Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.item.title.isEmpty ? '自定义区间' : widget.item.title,
                    textAlign: TextAlign.left,
                    style: widget.themeData.rangeTitleTextStyle,
                  ),
                )
              : const SizedBox.shrink(),
          Row(
            children: <Widget>[
              getDateRangeTextField(false),
              Text('至', style: widget.themeData.inputTextStyle),
              getDateRangeTextField(true),
            ],
          )
        ],
      ),
    );
  }

  Widget getDateRangeTextField(bool isMax) {
    return Expanded(
      child: TextField(
        enableInteractiveSelection: false,
        readOnly: true,
        onTap: () {
          if (widget.onTapped != null) {
            widget.onTapped!();
          }
          onTextTapped(isMax);
        },
        style: widget.themeData.inputTextStyle,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: const TextInputType.numberWithOptions(),
        onChanged: (input) => widget.item.isSelected = true,
        controller: isMax ? widget.maxTextEditingController : widget.minTextEditingController,
        cursorColor: DxStyle.$0984F9,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintStyle: widget.themeData.hintTextStyle,
          hintText: (!isMax ? '开始日期' : '结束日期'),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: DxStyle.$F0F0F0)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1, color: DxStyle.$F0F0F0)),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  void onTextTapped(bool isMax) {
    if (_datePickerController.isShow) return;
    String format = 'yyyy年,MM月,dd日';
    DateTime? minDate = DateTimeFormatter.convertIntValueToDateTime((widget.item.extMap)['min']);
    DateTime? maxDate = DateTimeFormatter.convertIntValueToDateTime((widget.item.extMap)['max']);

    DateTime? minSelectedDateTime = DxTools.isEmpty(widget.item.customMap)
        ? null
        : DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['min']);
    DateTime? maxSelectedDateTime = DxTools.isEmpty(widget.item.customMap)
        ? null
        : DateTimeFormatter.convertIntValueToDateTime(widget.item.customMap!['max']);

    DateTime? minDateTime;
    DateTime? maxDateTime;
    if (widget.item.customMap == null ||
        (widget.item.customMap!['min'] == null && widget.item.customMap!['max'] == null)) {
      // 如果开始时间和结束时间均未选择
      minDateTime = minDate;
      maxDateTime = maxDate;
    } else {
      minDateTime = !isMax ? minDate : (minSelectedDateTime ?? minDate);
      maxDateTime = isMax ? maxDate : (maxSelectedDateTime ?? maxDate);
    }

    Widget content = DxDateWidget(
      canPop: false,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      initialDateTime: isMax ? maxSelectedDateTime : minSelectedDateTime,
      dateFormat: format,
      pickerTitleConfig: DxPickerTitleConfig(
          showTitle: true,
          // UI 规范规定高度按照比例设置，UI稿的比利为 240 / 812
          titleText: isMax ? '请选择结束时间' : '请选择开始时间'),
      onCancel: () {
        closeSelectionPopupWindow();
      },
      onConfirm: (DateTime selectedDate, List<int> selectedIndex) {
        widget.item.isSelected = true;
        String selectedDateStr = DateTimeFormatter.formatDate(selectedDate, widget.dateFormat);
        if (isMax) {
          widget.maxTextEditingController.text = selectedDateStr;
        } else {
          widget.minTextEditingController.text = selectedDateStr;
        }
        widget.item.customMap ??= {};
        widget.item.customMap![isMax ? 'max' : 'min'] = selectedDate.millisecondsSinceEpoch.toString();
        closeSelectionPopupWindow();

        if (!isMax && DxTools.isEmpty(widget.maxTextEditingController.text)) {
          onTextTapped(true);
        }
        setState(() {});
      },
    );
    OverlayEntry entry = _createDatePickerEntry(context, content);
    Overlay.of(context)?.insert(entry);
    _datePickerController.entry = entry;
    _datePickerController.show();
  }

  OverlayEntry _createDatePickerEntry(BuildContext context, Widget content) {
    return OverlayEntry(builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => closeSelectionPopupWindow(),
        child: Container(
          color: const Color(0xB3000000),
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: DxSelectionDatePickerAnimationWidget(controller: _datePickerController, view: content),
        ),
      );
    });
  }

  void closeSelectionPopupWindow() {
    if (_datePickerController.isShow) {
      _datePickerController.hide();
    }
  }

  @override
  void dispose() {
    _datePickerController.hide();
    super.dispose();
  }
}
