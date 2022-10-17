import 'dart:math';

import 'package:dxwidget/src/components/picker/base/picker.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_range_side_widget.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// Solar months of 31 days.
const List<int> _solarMonthsOf31Days = <int>[1, 3, 5, 7, 8, 10, 12];

/// DatePicker widget.
// ignore: must_be_immutable
class DxDateRangeWidget extends StatefulWidget {
  /// 可选最小时间
  final DateTime? minDateTime;

  /// 可选最大时间
  final DateTime? maxDateTime;

  /// 初始选中的开始时间
  final DateTime? initialStartDateTime;

  /// 初始选中的结束时间
  final DateTime? initialEndDateTime;

  /// 时间展示格式
  final String? dateFormat;

  /// cancel 回调
  final DateVoidCallback? onCancel;

  /// 选中时间变化时的回调，返回选中的开始、结束时间
  final DateRangeValueCallback? onChange;

  /// 确定回调，返回选中的开始、结束时间
  final DateRangeValueCallback? onConfirm;

  /// Picker title  相关内容配置
  final DxPickerTitleConfig pickerTitleConfig;

  DxDateRangeWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initialStartDateTime,
    this.initialEndDateTime,
    this.dateFormat = datetimeRangePickerDateFormat,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.onCancel,
    this.onChange,
    this.onConfirm,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDatetime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDatetime);
    assert(minTime.compareTo(maxTime) < 0);
  }

  @override
  State<DxDateRangeWidget> createState() => _DxDateRangeWidgetState();
}

class _DxDateRangeWidgetState extends State<DxDateRangeWidget> {
  late DateTime _minDateTime, _maxDateTime;
  late int _currStartYear, _currStartMonth, _currStartDay;
  late int _currEndYear, _currEndMonth, _currEndDay;

  late List<int> _monthRange, _startDayRange, _endDayRange;
  late DateTime _startSelectedDateTime;
  late DateTime _endSelectedDateTime;
  DateTime now = DateTime.now();

  bool _isFirstScroll = false;
  bool _isSecondScroll = false;

  @override
  void initState() {
    super.initState();
    _initData(widget.initialStartDateTime, widget.initialEndDateTime, widget.minDateTime, widget.maxDateTime);
  }

  void _initData(
    DateTime? initialStartDateTime,
    DateTime? initialEndDateTime,
    DateTime? minDateTime,
    DateTime? maxDateTime,
  ) {
    _minDateTime = minDateTime ?? now;
    _maxDateTime = maxDateTime ?? now;
    DateTime initStartDateTime = initialStartDateTime ?? now;
    DateTime initEndDateTime = initialEndDateTime ?? now;

    _currStartYear = initStartDateTime.year;
    _currStartMonth = initStartDateTime.month;
    _currStartDay = initStartDateTime.day;

    _currEndYear = initEndDateTime.year;
    _currEndMonth = initEndDateTime.month;
    _currEndDay = initEndDateTime.day;

    // limit the range of year
    _currStartYear = min(max(_minDateTime.year, _currStartYear), _maxDateTime.year);
    _currEndYear = min(_maxDateTime.year, _currEndYear);

    // limit the range of month
    _monthRange = _calcMonthRange();
    _currStartMonth = min(max(_monthRange.first, _currStartMonth), _monthRange.last);
    _currEndMonth = min(_monthRange.last, _currEndMonth);

    // limit the range of day
    _startDayRange = _calcDayRange(currMonth: _currStartMonth);
    _currStartDay = min(max(_startDayRange.first, _currStartDay), _startDayRange.last);
    _endDayRange = _calcDayRange(currMonth: _currEndMonth);
    _currEndDay = min(_endDayRange.last, _currEndDay);

    _startSelectedDateTime = DateTime(_currStartYear, _currStartMonth, _currStartDay);
    _endSelectedDateTime = DateTime(_currEndYear, _currEndMonth, _currEndDay, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context);
    _initData(_startSelectedDateTime, _endSelectedDateTime, _minDateTime, _maxDateTime);
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
      return Column(children: <Widget>[titleWidget, datePickerWidget]);
    }
    return datePickerWidget;
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
    widget.onConfirm?.call(_startSelectedDateTime, _endSelectedDateTime);
    Navigator.pop(context);
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget(DxPickerThemeData themeData) {
    /// 用于强制刷新 Widget
    GlobalKey? firstGlobalKey;
    GlobalKey? secondGlobalKey;

    if (_isFirstScroll) {
      secondGlobalKey = GlobalKey();
      _isFirstScroll = false;
    }
    if (_isSecondScroll) {
      firstGlobalKey = GlobalKey();
      _isSecondScroll = false;
    }

    List<Widget> pickers = [];
    pickers.add(Expanded(
        flex: 6,
        child: Container(
            height: themeData.pickerHeight,
            color: themeData.backgroundColor,
            padding: const EdgeInsets.only(left: 10),
            child: DxDateRangeSideWidget(
              key: firstGlobalKey,
              dateFormat: widget.dateFormat,
              minDateTime: widget.minDateTime,
              maxDateTime: widget.maxDateTime,
              initialStartDateTime: _startSelectedDateTime,
              onInitSelectChange: (DateTime selectedDateTime, List<int> selected) {
                _startSelectedDateTime = selectedDateTime;
              },
              onChange: (DateTime selectedDateTime, List<int> selectedIndex) {
                setState(() {
                  _startSelectedDateTime = selectedDateTime;
                  _isFirstScroll = true;
                });
              },
            ))));
    pickers.add(_renderDatePickerMiddleColumnComponent(themeData));
    pickers.add(Expanded(
        flex: 6,
        child: Container(
            height: themeData.pickerHeight,
            color: themeData.backgroundColor,
            child: DxDateRangeSideWidget(
              key: secondGlobalKey,
              dateFormat: widget.dateFormat,
              minDateTime: _startSelectedDateTime,
              maxDateTime: widget.maxDateTime,
              initialStartDateTime: _endSelectedDateTime.compareTo(_startSelectedDateTime) > 0
                  ? _endSelectedDateTime
                  : _startSelectedDateTime,
              onInitSelectChange: (DateTime selectedDateTime, List<int> selectedIndex) {
                _endSelectedDateTime = selectedDateTime;
              },
              onChange: (DateTime selectedDateTime, List<int> selectedIndex) {
                setState(() {
                  _endSelectedDateTime = selectedDateTime;
                  _isSecondScroll = true;
                });
              },
            ))));
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  Widget _renderDatePickerMiddleColumnComponent(DxPickerThemeData themeData) {
    return Expanded(
      flex: 1,
      child: Container(
        height: themeData.pickerHeight,
        decoration: BoxDecoration(
          border: const Border(left: BorderSide.none, right: BorderSide.none),
          color: themeData.backgroundColor,
        ),
        child: DxPicker.builder(
          backgroundColor: themeData.backgroundColor,
          lineColor: themeData.dividerColor,
          itemExtent: themeData.itemHeight,
          childCount: 1,
          itemBuilder: (context, index) {
            return Container(
              height: themeData.itemHeight,
              alignment: Alignment.center,
              child: Text('至', style: themeData.itemTextStyle),
            );
          },
          onSelectedItemChanged: (int value) {},
        ),
      ),
    );
  }

  /// calculate the count of day in current month
  int _calcDayCountOfMonth() {
    if (_currStartMonth == 2) {
      return isLeapYear(_currStartYear) ? 29 : 28;
    } else if (_solarMonthsOf31Days.contains(_currStartMonth)) {
      return 31;
    }
    return 30;
  }

  /// whether or not is leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    int minMonth = 1, maxMonth = 12;
    int minYear = _minDateTime.year;
    int maxYear = _maxDateTime.year;
    if (minYear == _currStartYear) {
      // selected minimum year, limit month range
      minMonth = _minDateTime.month;
    }
    if (maxYear == _currStartYear) {
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
    currMonth ??= _currStartMonth;
    if (minYear == _currStartYear && minMonth == currMonth) {
      // selected minimum year and month, limit day range
      minDay = _minDateTime.day;
    }
    if (maxYear == _currStartYear && maxMonth == currMonth) {
      // selected maximum year and month, limit day range
      maxDay = _maxDateTime.day;
    }
    return [minDay, maxDay];
  }
}
