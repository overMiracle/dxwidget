import 'dart:math';

import 'package:dxwidget/src/components/picker/base/picker.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

enum ColumnType { year, month, day }

/// Solar months of 31 days.
const List<int> _solarMonthsOf31Days = <int>[1, 3, 5, 7, 8, 10, 12];

/// DatePicker widget.

// ignore: must_be_immutable
class DxDateWidget extends StatefulWidget {
  final DateTime? minDateTime, maxDateTime, initialDateTime;
  final String? dateFormat;
  final DxPickerTitleConfig pickerTitleConfig;

  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;
  final bool canPop;

  DxDateWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.dateFormat = datetimePickerDateFormat,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.canPop = true,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDatetime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDatetime);
    assert(minTime.compareTo(maxTime) <= 0);
  }

  @override
  State<DxDateWidget> createState() => _DxDateWidgetState();
}

class _DxDateWidgetState extends State<DxDateWidget> {
  late DateTime _minDateTime, _maxDateTime;
  late int _currYear, _currMonth, _currDay;
  late List<int> _yearRange, _monthRange, _dayRange;
  late FixedExtentScrollController? _yearScrollCtrl, _monthScrollCtrl, _dayScrollCtrl;

  late Map<String, FixedExtentScrollController?> _scrollCtrlMap;
  late Map<String, List<int>?> _valueRangeMap;

  bool _isChangeDateRange = false;
  final DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // handle current selected year、month、day
    DateTime initDateTime = widget.initialDateTime ?? now;
    _currYear = initDateTime.year;
    _currMonth = initDateTime.month;
    _currDay = initDateTime.day;

    // handle DateTime range
    _minDateTime = widget.minDateTime ?? now;
    _maxDateTime = widget.maxDateTime ?? DateTime.parse(datePickerMaxDatetime);

    // limit the range of year
    _yearRange = _calcYearRange();
    _currYear = min(max(_minDateTime.year, _currYear), _maxDateTime.year);

    // limit the range of month
    _monthRange = _calcMonthRange();
    _currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);

    // limit the range of day
    _dayRange = _calcDayRange();
    _currDay = min(max(_dayRange.first, _currDay), _dayRange.last);

    // create scroll controller
    _yearScrollCtrl = FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(initialItem: _currMonth - _monthRange.first);
    _dayScrollCtrl = FixedExtentScrollController(initialItem: _currDay - _dayRange.first);

    _scrollCtrlMap = {'y': _yearScrollCtrl, 'M': _monthScrollCtrl, 'd': _dayScrollCtrl};
    _valueRangeMap = {'y': _yearRange, 'M': _monthRange, 'd': _dayRange};
  }

  @override
  Widget build(BuildContext context) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: _renderPickerView(context, themeData),
    );
  }

  /// render date picker widgets
  Widget _renderPickerView(BuildContext context, DxPickerThemeData themeData) {
    Widget datePickerWidget = _renderDatePickerWidget(themeData);

    // display the title widget
    if (widget.pickerTitleConfig.title != null || widget.pickerTitleConfig.showTitle) {
      Widget titleWidget = DxPickerTitle(
        pickerTitleConfig: widget.pickerTitleConfig,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[titleWidget, datePickerWidget]);
    }
    return datePickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    widget.onCancel?.call();
    if (widget.canPop) Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    if (widget.canPop) Navigator.pop(context);
  }

  /// notify selected date changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
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
      List<int> valueRange = _findPickerItemRange(format)!;

      Widget pickerColumn = _renderDatePickerColumnComponent(
        themeData: themeData,
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        valueChanged: (value) {
          if (format.contains('y')) {
            _changeYearSelection(value);
          } else if (format.contains('M')) {
            _changeMonthSelection(value);
          } else if (format.contains('d')) {
            _changeDaySelection(value);
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
    required List<int> valueRange,
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
          childCount: valueRange.last - valueRange.first + 1,
          itemBuilder: (context, index) => _renderDatePickerItemComponent(
            themeData,
            format.contains("y") ? ColumnType.year : (format.contains("M") ? ColumnType.month : ColumnType.day),
            index,
            valueRange.first + index,
            format,
          ),
        ),
      ),
    );
  }

  Widget _renderDatePickerItemComponent(
    DxPickerThemeData themeData,
    ColumnType columnType,
    int index,
    int value,
    String format,
  ) {
    TextStyle textStyle = themeData.itemTextStyle;
    if ((ColumnType.year == columnType && index == _calcSelectIndexList()[0]) ||
        (ColumnType.month == columnType && index == _calcSelectIndexList()[1]) ||
        (ColumnType.day == columnType && index == _calcSelectIndexList()[2])) {
      textStyle = themeData.itemTextSelectedStyle;
    }
    return Container(
      height: themeData.itemHeight,
      alignment: Alignment.center,
      child: Text(DateTimeFormatter.formatDateTime(value, format), style: textStyle),
    );
  }

  /// change the selection of year picker
  void _changeYearSelection(int index) {
    int year = _yearRange.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    int month = _monthRange.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int index) {
    int dayOfMonth = _dayRange.first + index;
    if (_currDay != dayOfMonth) {
      _currDay = dayOfMonth;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change range of month and day
  void _changeDateRange() {
    if (_isChangeDateRange) {
      return;
    }
    _isChangeDateRange = true;

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
      int currMonth = _currMonth;
      _monthScrollCtrl!.jumpToItem(monthRange.last - monthRange.first);
      if (currMonth < monthRange.last) {
        _monthScrollCtrl!.jumpToItem(currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currDay = _currDay;
      _dayScrollCtrl!.jumpToItem(dayRange.last - dayRange.first);
      if (currDay < dayRange.last) {
        _dayScrollCtrl!.jumpToItem(currDay - dayRange.first);
      }
    }

    _isChangeDateRange = false;
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

  /// whether or not is leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int yearIndex = _currYear - _minDateTime.year;
    int monthIndex = _currMonth - _monthRange.first;
    int dayIndex = _currDay - _dayRange.first;
    return [yearIndex, monthIndex, dayIndex];
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    return [_minDateTime.year, _maxDateTime.year];
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    int minMonth = 1, maxMonth = 12;
    int minYear = _minDateTime.year;
    int maxYear = _maxDateTime.year;
    if (minYear == _currYear) {
      // selected minimum year, limit month range
      minMonth = _minDateTime.month;
    }
    if (maxYear == _currYear) {
      // selected maximum year, limit month range
      maxMonth = _maxDateTime.month;
    }
    return [minMonth, maxMonth];
  }

  /// calculate the range of day
  List<int> _calcDayRange({currMonth}) {
    int minDay = 1, maxDay = _calcDayCountOfMonth();
    int minYear = _minDateTime.year;
    int maxYear = _maxDateTime.year;
    int minMonth = _minDateTime.month;
    int maxMonth = _maxDateTime.month;
    currMonth ??= _currMonth;
    if (minYear == _currYear && minMonth == currMonth) {
      // selected minimum year and month, limit day range
      minDay = _minDateTime.day;
    }
    if (maxYear == _currYear && maxMonth == currMonth) {
      // selected maximum year and month, limit day range
      maxDay = _maxDateTime.day;
    }
    return [minDay, maxDay];
  }
}
