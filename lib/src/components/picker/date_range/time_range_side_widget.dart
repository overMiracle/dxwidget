import 'dart:math';

import 'package:dxwidget/src/components/picker/base/picker.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// TimeRangeSidePicker widget.
// ignore: must_be_immutable
class DxTimeRangeSideWidget extends StatefulWidget {
  /// 可选最小时间
  final DateTime? minDateTime;

  /// 可选最大时间
  final DateTime? maxDateTime;

  /// 初始开始选中时间
  final DateTime? initialStartDateTime;

  /// 时间展示格式
  final String? dateFormat;

  /// 时间选择变化时回调
  final DateRangeSideValueCallback? onChange;

  /// 分钟的展示间隔
  final int minuteDivider;

  /// 当前默认选择的时间变化时对外部回调，外部监听该事件同步修改默认初始选中的时间
  final DateRangeSideValueCallback? onInitSelectChange;

  DxTimeRangeSideWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initialStartDateTime,
    this.dateFormat = datetimeRangePickerTimeFormat,
    this.minuteDivider = 1,
    this.onChange,
    this.onInitSelectChange,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDatetime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDatetime);
    assert(minTime.compareTo(maxTime) <= 0);
  }

  @override
  State<DxTimeRangeSideWidget> createState() => _DxTimePickerWidgetState();
}

class _DxTimePickerWidgetState extends State<DxTimeRangeSideWidget> {
  late DateTime _minTime, _maxTime, _initStartTime;
  late int _currStartHour, _currStartMinute;
  late List<int> _hourRange, _minuteRange;
  late FixedExtentScrollController _startHourScrollCtrl, _startMinuteScrollCtrl;

  late Map<String, FixedExtentScrollController> _startScrollCtrlMap;
  late Map<String, List<int>> _valueRangeMap;

  bool _isChangeTimeRange = false;

  bool _scrolledNotMinute = false;

  DateTime now = DateTime.now();

  void _initData(
    DateTime? initStartTime,
    DateTime? minTime,
    DateTime? maxTime,
  ) {
    _initStartTime = initStartTime ?? now;
    _minTime = minTime ?? now;
    _maxTime = maxTime ?? DateTime.parse(datePickerMaxDatetime);

    _currStartHour = _initStartTime.hour;
    _hourRange = _calcHourRange();
    _currStartHour = min(max(_hourRange.first, _currStartHour), _hourRange.last);

    _currStartMinute = _initStartTime.minute;
    _minuteRange = _calcMinuteRange();
    _currStartMinute = min(max(_minuteRange.first, _currStartMinute), _minuteRange.last);
    _currStartMinute -= _currStartMinute % widget.minuteDivider;

    /// notify selected simple changed
    if (widget.onInitSelectChange != null) {
      DateTime now = DateTime.now();
      DateTime startDateTime = DateTime(now.year, now.month, now.day, _currStartHour, _currStartMinute);
      widget.onInitSelectChange!(startDateTime, _calcStartSelectIndexList());
    }

    /// create scroll controller
    _startHourScrollCtrl = FixedExtentScrollController(initialItem: _currStartHour - _hourRange.first);
    _startMinuteScrollCtrl =
        FixedExtentScrollController(initialItem: (_currStartMinute - _minuteRange.first) ~/ widget.minuteDivider);
    _startScrollCtrlMap = {
      'H': _startHourScrollCtrl,
      'm': _startMinuteScrollCtrl,
    };

    _valueRangeMap = {'H': _hourRange, 'm': _minuteRange};
  }

  @override
  void initState() {
    super.initState();
    _initData(widget.initialStartDateTime, widget.minDateTime, widget.maxDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context);
    _initData(widget.initialStartDateTime, _minTime, _maxTime);
    return Container(
      color: themeData.backgroundColor,
      child: _renderPickerView(context, themeData),
    );
  }

  /// render simple picker widgets
  Widget _renderPickerView(BuildContext context, DxPickerThemeData themeData) {
    return _renderDatePickerWidget(themeData);
  }

  /// notify selected simple changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime now = DateTime.now();
      DateTime startDateTime = DateTime(now.year, now.month, now.day, _currStartHour, _currStartMinute);
      widget.onChange!(startDateTime, _calcStartSelectIndexList());
    }
  }

  /// find start scroll controller by specified format
  FixedExtentScrollController? _findScrollCtrl(String format) {
    FixedExtentScrollController? scrollCtrl;
    _startScrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int>? _findPickerItemRange(String format) {
    List<int>? valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget(DxPickerThemeData themeData) {
    List<Widget> pickers = [];
    List<String> formatArr = DateTimeFormatter.splitDateFormat(widget.dateFormat);
    for (var format in formatArr) {
      List<int>? valueRange = _findPickerItemRange(format);

      Widget pickerColumn = _renderDatePickerColumnComponent(
        themeData: themeData,
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        valueChanged: (value) {
          if (format.contains('H')) {
            _changeHourSelection(value);
          } else if (format.contains('m')) {
            _changeMinuteSelection(value);
          }
        },
      );
      pickers.add(pickerColumn);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  Widget _renderDatePickerColumnComponent({
    required DxPickerThemeData themeData,
    required FixedExtentScrollController? scrollCtrl,
    required List<int>? valueRange,
    required String format,
    required ValueChanged<int> valueChanged,
  }) {
    GlobalKey? globalKey;
    if (_scrolledNotMinute && format.contains("m")) {
      globalKey = GlobalKey();
      _scrolledNotMinute = false;
    }

    return Expanded(
      flex: 1,
      child: Container(
        height: themeData.pickerHeight,
        color: themeData.backgroundColor,
        child: DxPicker.builder(
          key: globalKey,
          backgroundColor: themeData.backgroundColor,
          lineColor: themeData.dividerColor,
          scrollController: scrollCtrl,
          itemExtent: themeData.itemHeight,
          onSelectedItemChanged: (int index) {
            if (!format.contains("m")) {
              _scrolledNotMinute = true;
            }
            valueChanged(index);
          },
          childCount: format.contains('m')
              ? _calculateMinuteChildCount(valueRange, widget.minuteDivider)
              : valueRange!.last - valueRange.first + 1,
          itemBuilder: (context, index) {
            int value = valueRange!.first + index;

            if (format.contains('m')) {
              value = valueRange.first + widget.minuteDivider * index;
            }
            return _renderDatePickerItemComponent(themeData, index, format.contains('m'), value, format);
          },
        ),
      ),
    );
  }

  _calculateMinuteChildCount(List<int>? valueRange, int? divider) {
    if (divider == 0 || divider == 1) {
      return (valueRange!.last - valueRange.first + 1);
    }

    return ((valueRange!.last - valueRange.first) ~/ divider!) + 1;
  }

  Widget _renderDatePickerItemComponent(
    DxPickerThemeData themeData,
    int index,
    bool isMinuteColumn,
    int value,
    String format,
  ) {
    TextStyle textStyle = themeData.itemTextStyle;
    if ((!isMinuteColumn && (index == _calcStartSelectIndexList()[0])) ||
        ((isMinuteColumn && (index == _calcStartSelectIndexList()[1])))) {
      textStyle = themeData.itemTextSelectedStyle;
    }
    return Container(
      height: themeData.itemHeight,
      alignment: Alignment.center,
      child: Text(DateTimeFormatter.formatDateTime(value, format), style: textStyle),
    );
  }

  /// change the selection of hour picker
  void _changeHourSelection(int index) {
    int value = _hourRange.first + index;
    _currStartHour = value;
    _changeStartTimeRange();
    _onSelectedChange();
  }

  /// change the selection of month picker
  void _changeMinuteSelection(int index) {
    int value = _minuteRange.first + index * widget.minuteDivider;
    _currStartMinute = value;
    _changeStartTimeRange();
    _onSelectedChange();
  }

  /// change range of minute and second
  void _changeStartTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first || _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currStartMinute = max(min(_currStartMinute, minuteRange.last), minuteRange.first);
    }

    setState(() {
      _minuteRange = minuteRange;
      _valueRangeMap['m'] = minuteRange;
    });

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMinute = _currStartMinute;
      _startMinuteScrollCtrl.jumpToItem((minuteRange.last - minuteRange.first) ~/ widget.minuteDivider);
      if (currMinute < minuteRange.last) {
        _startMinuteScrollCtrl.jumpToItem((currMinute - minuteRange.first) ~/ widget.minuteDivider);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcStartSelectIndexList() {
    int hourIndex = _currStartHour - _hourRange.first;
    int minuteIndex = (_currStartMinute - _minuteRange.first) ~/ widget.minuteDivider;
    return [hourIndex, minuteIndex];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    return [_minTime.hour, _maxTime.hour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({currHour}) {
    int minMinute = 0, maxMinute = 59;
    int minHour = _minTime.hour;
    int maxHour = _maxTime.hour;
    currHour ??= _currStartHour;

    if (minHour == currHour) {
      // selected minimum hour, limit minute range
      minMinute = _minTime.minute;
    }
    if (maxHour == currHour) {
      // selected maximum hour, limit minute range
      maxMinute = _maxTime.minute;
    }
    return [minMinute, maxMinute];
  }
}
