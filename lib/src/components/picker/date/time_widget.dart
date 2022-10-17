import 'dart:math';

import 'package:dxwidget/src/components/picker/base/picker.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// TimePicker widget.
enum ColumnType { hour, minute, second }

// ignore: must_be_immutable
class DxTimeWidget extends StatefulWidget {
  final DateTime? minDateTime, maxDateTime, initDateTime;
  final String? dateFormat;
  final DxPickerTitleConfig pickerTitleConfig;
  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;
  final int minuteDivider;

  DxTimeWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initDateTime,
    this.dateFormat = datetimePickerTimeFormat,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.minuteDivider = 1,
    this.onCancel,
    this.onChange,
    this.onConfirm,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDatetime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDatetime);
    assert(minTime.compareTo(maxTime) < 0);
  }

  @override
  State<StatefulWidget> createState() => _DxTimeWidgetState();
}

class _DxTimeWidgetState extends State<DxTimeWidget> {
  late DateTime _minTime, _maxTime, _initTime;
  late int _currHour, _currMinute, _currSecond;
  late List<int> _hourRange, _minuteRange, _secondRange;
  late FixedExtentScrollController _hourScrollCtrl, _minuteScrollCtrl, _secondScrollCtrl;

  late Map<String, FixedExtentScrollController?> _scrollCtrlMap;
  late Map<String, List<int>> _valueRangeMap;

  bool _isChangeTimeRange = false;

  @override
  void initState() {
    super.initState();
    _initTime = widget.initDateTime ?? DateTime.now();
    _currHour = _initTime.hour;
    _currMinute = _initTime.minute;
    _currSecond = _initTime.second;

    // limit the range of hour
    _hourRange = _calcHourRange();
    _currHour = min(max(_hourRange.first, _currHour), _hourRange.last);

    // limit the range of minute
    _minuteRange = _calcMinuteRange();
    _currMinute = min(max(_minuteRange.first, _currMinute), _minuteRange.last);
    _currMinute -= _currMinute % widget.minuteDivider;
    // limit the range of second
    _secondRange = _calcSecondRange();
    _currSecond = min(max(_secondRange.first, _currSecond), _secondRange.last);

    // create scroll controller
    _hourScrollCtrl = FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl =
        FixedExtentScrollController(initialItem: (_currMinute - _minuteRange.first) ~/ widget.minuteDivider);
    _secondScrollCtrl = FixedExtentScrollController(initialItem: _currSecond - _secondRange.first);

    _scrollCtrlMap = {'H': _hourScrollCtrl, 'm': _minuteScrollCtrl, 's': _secondScrollCtrl};
    _valueRangeMap = {'H': _hourRange, 'm': _minuteRange, 's': _secondRange};
  }

  @override
  Widget build(BuildContext context) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: _renderPickerView(context, themeData),
    );
  }

  /// render simple picker widgets
  Widget _renderPickerView(BuildContext context, DxPickerThemeData themeData) {
    Widget pickerWidget = _renderDatePickerWidget(themeData);

    // display the title widget
    if (widget.pickerTitleConfig.title != null || widget.pickerTitleConfig.showTitle) {
      Widget titleWidget = DxPickerTitle(
        pickerTitleConfig: widget.pickerTitleConfig,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: <Widget>[titleWidget, pickerWidget]);
    }
    return pickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    widget.onCancel?.call();
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      DateTime now = DateTime.now();
      DateTime dateTime = DateTime(now.year, now.month, now.day, _currHour, _currMinute, _currSecond);
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected simple changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime now = DateTime.now();
      DateTime dateTime = DateTime(now.year, now.month, now.day, _currHour, _currMinute, _currSecond);
      widget.onChange!(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController? _findScrollCtrl(String format) {
    FixedExtentScrollController? scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
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
          } else if (format.contains('s')) {
            _changeSecondSelection(value);
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
    return Expanded(
      flex: 1,
      child: Container(
        height: themeData.pickerHeight,
        decoration: BoxDecoration(color: themeData.backgroundColor),
        child: DxPicker.builder(
          backgroundColor: themeData.backgroundColor,
          lineColor: themeData.dividerColor,
          scrollController: scrollCtrl,
          itemExtent: themeData.itemHeight,
          onSelectedItemChanged: valueChanged,
          childCount: format.contains('m')
              ? _calculateMinuteChildCount(valueRange, widget.minuteDivider)
              : valueRange!.last - valueRange.first + 1,
          itemBuilder: (context, index) {
            int value = valueRange!.first + index;

            if (format.contains('m')) {
              value = widget.minuteDivider * index;
            }

            return _renderDatePickerItemComponent(
              themeData,
              getColumnType(format),
              index,
              value,
              format,
            );
          },
        ),
      ),
    );
  }

  // ignore: missing_return
  ColumnType? getColumnType(String format) {
    if (format.contains('H')) {
      return ColumnType.hour;
    } else if (format.contains('m')) {
      return ColumnType.minute;
    } else if (format.contains('s')) {
      return ColumnType.second;
    }
    return null;
  }

  _calculateMinuteChildCount(List<int>? valueRange, int? divider) {
    if (divider == 0) {
      return (valueRange!.last - valueRange.first + 1);
    }

    return (valueRange!.last - valueRange.first + 1) ~/ divider!;
  }

  Widget _renderDatePickerItemComponent(
    DxPickerThemeData themeData,
    ColumnType? columnType,
    int index,
    int value,
    String format,
  ) {
    TextStyle textStyle = themeData.itemTextStyle;
    if ((ColumnType.hour == columnType && index == _calcSelectIndexList()[0]) ||
        (ColumnType.minute == columnType && index == _calcSelectIndexList()[1]) ||
        (ColumnType.second == columnType && index == _calcSelectIndexList()[2])) {
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
    if (_currHour != value) {
      _currHour = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMinuteSelection(int index) {
    int value = index * widget.minuteDivider;
    if (_currMinute != value) {
      _currMinute = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of second picker
  void _changeSecondSelection(int index) {
    int value = _secondRange.first + index;
    if (_currSecond != value) {
      _currSecond = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change range of minute and second
  void _changeTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first || _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
      _currMinute -= _currMinute % widget.minuteDivider;
    }

    List<int> secondRange = _calcSecondRange();
    bool secondRangeChanged = _secondRange.first != secondRange.first || _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap['m'] = minuteRange;
      _valueRangeMap['s'] = secondRange;
    });

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMinute = _currMinute;
      _minuteScrollCtrl.jumpToItem((minuteRange.last - minuteRange.first) ~/ widget.minuteDivider);
      if (currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem(currMinute - minuteRange.first);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currSecond = _currSecond;
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(currSecond - secondRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int hourIndex = _currHour - _hourRange.first;
    int minuteIndex = (_currMinute - _minuteRange.first) ~/ widget.minuteDivider;
    int secondIndex = _currSecond - _secondRange.first;
    return [hourIndex, minuteIndex, secondIndex];
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
    currHour ??= _currHour;

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

  /// calculate the range of second
  List<int> _calcSecondRange({currHour, currMinute}) {
    int minSecond = 0, maxSecond = 59;
    int minHour = _minTime.hour;
    int maxHour = _maxTime.hour;
    int minMinute = _minTime.minute;
    int maxMinute = _maxTime.minute;
    currHour ??= _currHour;
    currMinute ??= _currMinute;

    if (minHour == currHour && minMinute == currMinute) {
      // selected minimum hour and minute, limit second range
      minSecond = _minTime.second;
    }
    if (maxHour == currHour && maxMinute == currMinute) {
      // selected maximum hour and minute, limit second range
      maxSecond = _maxTime.second;
    }
    return [minSecond, maxSecond];
  }
}
