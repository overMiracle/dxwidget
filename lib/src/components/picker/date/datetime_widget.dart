import 'dart:math';

import 'package:dxwidget/src/components/picker/base/picker.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

enum ColumnType { year, month, day, hour, minute, second }

/// DateTimePicker widget. Can display date and simple picker
// ignore: must_be_immutable
class DxDateTimeWidget extends StatefulWidget {
  final DateTime? minDateTime, maxDateTime, initDateTime;
  final int minuteDivider;
  final String? dateFormat;
  final DxPickerTitleConfig pickerTitleConfig;

  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;

  const DxDateTimeWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initDateTime,
    this.dateFormat = datetimePickerTimeFormat,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.minuteDivider = 1,
  }) : super(key: key);

  @override
  State<DxDateTimeWidget> createState() => _DxDateTimeWidgetState();
}

class _DxDateTimeWidgetState extends State<DxDateTimeWidget> {
  late DateTime _minTime, _maxTime;
  late int _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond;
  late List<int> _yearRange, _monthRange, _dayRange, _hourRange, _minuteRange, _secondRange;
  late FixedExtentScrollController _yearScrollCtrl,
      _monthScrollCtrl,
      _dayScrollCtrl,
      _hourScrollCtrl,
      _minuteScrollCtrl,
      _secondScrollCtrl;

  late Map<String, FixedExtentScrollController?> _scrollCtrlMap;
  late Map<String, List<int>?> _valueRangeMap;

  bool _isChangeTimeRange = false;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    DateTime initTime = widget.initDateTime ?? now;
    DateTime minTime = widget.minDateTime ?? now;
    DateTime maxTime = widget.maxDateTime ?? now;
    // limit initTime value
    if (initTime.compareTo(minTime) < 0) initTime = minTime;
    if (initTime.compareTo(maxTime) > 0) initTime = maxTime;

    _minTime = minTime;
    _maxTime = maxTime;
    _currYear = initTime.year;
    _currMonth = initTime.month;
    _currDay = initTime.day;
    _currHour = initTime.hour;
    _currMinute = initTime.minute;
    _currSecond = initTime.second;

    // limit the range of year
    _yearRange = _calcYearRange();
    _currYear = min(max(_minTime.year, _currYear), _maxTime.year);
    // limit the range of month
    _monthRange = _calcMonthRange();
    _currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);
    // limit the range of date
    _dayRange = _calcDayRange();
    _currDay = min(max(_dayRange.first, _currDay), _dayRange.last);
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
    _yearScrollCtrl = FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(initialItem: _currMonth - _monthRange.first);
    _dayScrollCtrl = FixedExtentScrollController(initialItem: _currDay - _dayRange.first);
    _hourScrollCtrl = FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl =
        FixedExtentScrollController(initialItem: (_currMinute - _minuteRange.first) ~/ widget.minuteDivider);
    _secondScrollCtrl = FixedExtentScrollController(initialItem: _currSecond - _secondRange.first);

    _scrollCtrlMap = {
      'y': _yearScrollCtrl,
      'M': _monthScrollCtrl,
      'd': _dayScrollCtrl,
      'H': _hourScrollCtrl,
      'm': _minuteScrollCtrl,
      's': _secondScrollCtrl
    };
    _valueRangeMap = {
      'y': _yearRange,
      'M': _monthRange,
      'd': _dayRange,
      'H': _hourRange,
      'm': _minuteRange,
      's': _secondRange
    };
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
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      List<String> formatArr = DateTimeFormatter.splitDateFormat(widget.dateFormat);

      /// 如果传入的时间格式不包含 月、天、小时、分钟、秒。则相对应的时间置为 1,1,0,0,0；
      DateTime dateTime = DateTime(
        _currYear,
        (formatArr.where((format) => format.contains('M')).toList()).isNotEmpty ? _currMonth : 1,
        (formatArr.where((format) => format.contains('d')).toList()).isNotEmpty ? _currDay : 1,
        (formatArr.where((format) => format.contains('H')).toList()).isNotEmpty ? _currHour : 0,
        (formatArr.where((format) => format.contains('m')).toList()).isNotEmpty ? _currMinute : 0,
        (formatArr.where((format) => format.contains('s')).toList()).isNotEmpty ? _currSecond : 0,
      );
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected datetime changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime dateTime = DateTime(_currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond);
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

    // render simple picker column
    for (var format in formatArr) {
      List<int>? valueRange = _findPickerItemRange(format);

      Widget pickerColumn = _renderDatePickerColumnComponent(
        themeData: themeData,
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        flex: 1,
        valueChanged: (value) {
          if (format.contains('y')) {
            _changeYearSelection(value);
          } else if (format.contains('M')) {
            _changeMonthSelection(value);
          } else if (format.contains('d')) {
            _changeDaySelection(value);
          } else if (format.contains('H')) {
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
    required int flex,
    IndexedWidgetBuilder? itemBuilder,
  }) {
    Widget columnWidget = Container(
      width: double.infinity,
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
        itemBuilder: itemBuilder ??
            (context, index) {
              int value = valueRange!.first + index;

              if (format.contains('m')) {
                value = valueRange.first + widget.minuteDivider * index;
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
    );
    return Expanded(flex: flex, child: columnWidget);
  }

  _calculateMinuteChildCount(List<int>? valueRange, int? divider) {
    if (divider == 0 || divider == 1) {
      return (valueRange!.last - valueRange.first + 1);
    }

    return ((valueRange!.last - valueRange.first) ~/ divider!) + 1;
  }

  // ignore: missing_return
  ColumnType? getColumnType(String format) {
    if (format.contains('y')) {
      return ColumnType.year;
    } else if (format.contains('M')) {
      return ColumnType.month;
    } else if (format.contains('d')) {
      return ColumnType.day;
    } else if (format.contains('H')) {
      return ColumnType.hour;
    } else if (format.contains('m')) {
      return ColumnType.minute;
    } else if (format.contains('s')) {
      return ColumnType.second;
    }
    return null;
  }

  /// change the selection of year picker
  void _changeYearSelection(int index) {
    int year = _yearRange.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeDateRange();
      _onSelectedChange();
      _changeTimeRange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    int month = _monthRange.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeDateRange();
      _onSelectedChange();
      _changeTimeRange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int index) {
    int dayOfMonth = _dayRange.first + index;
    if (_currDay != dayOfMonth) {
      _currDay = dayOfMonth;
      _changeDateRange();
      _onSelectedChange();
      _changeTimeRange();
    }
  }

  /// change range of month and day
  void _changeDateRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> monthRange = _calcMonthRange();
    bool monthRangeChanged = _monthRange.first != monthRange.first || _monthRange.last != monthRange.last;
    if (monthRangeChanged) {
      // selected year changed
      _currMonth = max(min(_currMonth, monthRange.last), monthRange.first);
    }

    List<int> dayRange = _calcDayRange();
    bool dayRangeChanged = _dayRange.first != dayRange.first || _dayRange.last != dayRange.last;
    if (dayRangeChanged) {
      // day range changed, need limit the value of selected day
      _currDay = max(min(_currDay, dayRange.last), dayRange.first);
    }

    setState(() {
      _monthRange = monthRange;
      _dayRange = dayRange;

      _valueRangeMap['M'] = monthRange;
      _valueRangeMap['d'] = dayRange;
    });

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      _monthScrollCtrl.jumpToItem(monthRange.last - monthRange.first);
      if (_currMonth < monthRange.last) {
        _monthScrollCtrl.jumpToItem(_currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      _dayScrollCtrl.jumpToItem(dayRange.last - dayRange.first);
      if (_currDay < dayRange.last) {
        _dayScrollCtrl.jumpToItem(_currDay - dayRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// render hour、minute、second picker item
  Widget _renderDatePickerItemComponent(
    DxPickerThemeData themeData,
    ColumnType? columnType,
    int index,
    int value,
    String format,
  ) {
    TextStyle textStyle = themeData.itemTextStyle;
    if ((ColumnType.year == columnType && index == _calcSelectIndexList()[0]) ||
        (ColumnType.month == columnType && index == _calcSelectIndexList()[1]) ||
        (ColumnType.day == columnType && index == _calcSelectIndexList()[2]) ||
        (ColumnType.hour == columnType && index == _calcSelectIndexList()[3]) ||
        (ColumnType.minute == columnType && index == _calcSelectIndexList()[4]) ||
        (ColumnType.second == columnType && index == _calcSelectIndexList()[5])) {
      textStyle = themeData.itemTextSelectedStyle;
    }

    return Container(
      height: themeData.itemHeight,
      alignment: Alignment.center,
      child: Text(DateTimeFormatter.formatDateTime(value, format), style: textStyle),
    );
  }

//  /// change the selection of day picker
//  void _changeDaySelection(int days) {
//    int value = _dayRange.first + days;
//    if (_currDay != value) {
//      _currDay = value;
//      _changeTimeRange();
//      _onSelectedChange();
//    }
//  }

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
    int value = _minuteRange.first + index * widget.minuteDivider;
    _currMinute = value;
    _changeTimeRange();
    _onSelectedChange();
  }

  /// change the selection of second picker
  void _changeSecondSelection(int index) {
    int value = _secondRange.first + index;
    _currSecond = value;
    _changeTimeRange();
    _onSelectedChange();
  }

  /// change range of minute and second
  void _changeTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> hourRange = _calcHourRange();
    bool hourRangeChanged = _hourRange.first != hourRange.first || _hourRange.last != hourRange.last;
    if (hourRangeChanged) {
      // selected day changed
      _currHour = max(min(_currHour, hourRange.last), hourRange.first);
    }

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first || _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
    }

    List<int> secondRange = _calcSecondRange();
    bool secondRangeChanged = _secondRange.first != secondRange.first || _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _hourRange = hourRange;
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap['H'] = hourRange;
      _valueRangeMap['m'] = minuteRange;
      _valueRangeMap['s'] = secondRange;
    });

    if (hourRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      _hourScrollCtrl.jumpToItem(hourRange.last - hourRange.first);
      if (_currHour < hourRange.last) {
        _hourScrollCtrl.jumpToItem(_currHour - hourRange.first);
      }
    }

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      _minuteScrollCtrl.jumpToItem((minuteRange.last - minuteRange.first) ~/ widget.minuteDivider);
      if (_currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem((_currMinute - minuteRange.first) ~/ widget.minuteDivider);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (_currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(_currSecond - secondRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int yearIndex = _currYear - _yearRange.first;
    int monthIndex = _currMonth - _monthRange.first;
    int dayIndex = _currDay - _dayRange.first;
    int hourIndex = _currHour - _hourRange.first;
    int minuteIndex = (_currMinute - _minuteRange.first) ~/ widget.minuteDivider;
    int secondIndex = _currSecond - _secondRange.first;
    return [yearIndex, monthIndex, dayIndex, hourIndex, minuteIndex, secondIndex];
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    return [_minTime.year, _maxTime.year];
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    int minMonth = 1, maxMonth = 12;
    int minYear = _minTime.year;
    int maxYear = _maxTime.year;
    if (minYear == _currYear) {
      // selected minimum year, limit month range
      minMonth = _minTime.month;
    }
    if (maxYear == _currYear) {
      // selected maximum year, limit month range
      maxMonth = _maxTime.month;
    }
    return [minMonth, maxMonth];
  }

  /// Solar months of 31 days.
  static const List<int> _solarMonthsOf31Days = <int>[1, 3, 5, 7, 8, 10, 12];

  /// whether or not is leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate the count of day in current month
  int _calcDayCountOfMonth() {
    if (_currMonth == 2) {
      return isLeapYear(_currYear) ? 29 : 28;
    } else if (_solarMonthsOf31Days.contains(_currMonth)) {
      return 31;
    }
    return 30;
  }

  /// calculate the range of day
  List<int> _calcDayRange({currMonth}) {
    int minDay = 1, maxDay = _calcDayCountOfMonth();
    int minYear = _minTime.year;
    int maxYear = _maxTime.year;
    int minMonth = _minTime.month;
    int maxMonth = _maxTime.month;
    currMonth ??= _currMonth;
    if (minYear == _currYear && minMonth == currMonth) {
      // selected minimum year and month, limit day range
      minDay = _minTime.day;
    }
    if (maxYear == _currYear && maxMonth == currMonth) {
      // selected maximum year and month, limit day range
      maxDay = _maxTime.day;
    }
    return [minDay, maxDay];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    int minHour = 0, maxHour = 23;
    if (_currYear == _minTime.year && _currMonth == _minTime.month && _currDay == _minTime.day) {
      minHour = _minTime.hour;
    }

    int modValue = _minTime.minute % widget.minuteDivider;
    int minMinute = modValue == 0 ? _minTime.minute : (_minTime.minute - modValue + widget.minuteDivider);
    if (minMinute == 60) {
      minHour = minHour + 1 > _maxTime.hour ? _maxTime.hour : minHour + 1;
    }

    if (_currYear == _maxTime.year && _currMonth == _maxTime.month && _currDay == _maxTime.day) {
      maxHour = _maxTime.hour;
    }
    return [minHour, maxHour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({currHour}) {
    int minMinute = 0, maxMinute = 59;
    currHour ??= _currHour;

    if (_currYear == _minTime.year &&
        _currMonth == _minTime.month &&
        _currDay == _minTime.day &&
        _currHour == _minTime.hour) {
      // selected minimum day、hour, limit minute range
      int modValue = _minTime.minute % widget.minuteDivider;
      minMinute = modValue == 0 ? _minTime.minute : (_minTime.minute - modValue + widget.minuteDivider);
      if (minMinute == 60) {
        minMinute = 0;
        currHour = currHour + 1 > _maxTime.hour ? _maxTime.hour : currHour + 1;
      }
    }
    if (_currYear == _maxTime.year &&
        _currMonth == _maxTime.month &&
        _currDay == _maxTime.day &&
        _currHour == _maxTime.hour) {
      // selected maximum day、hour, limit minute range
      maxMinute = _maxTime.minute - _maxTime.minute % widget.minuteDivider;
    }
    return [minMinute, maxMinute];
  }

  /// calculate the range of second
  List<int> _calcSecondRange() {
    int minSecond = 0, maxSecond = 59;
    return [minSecond, maxSecond];
  }
}
