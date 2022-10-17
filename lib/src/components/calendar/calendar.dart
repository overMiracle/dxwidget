import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///单选日期回调函数
typedef DxCalendarDateChange = Function(DateTime date);

///范围选择日期回调函数
typedef DxCalendarRangeDateChange = Function(DateTimeRange range);

/// 展示模式，周视图模式，月视图模式
enum DxCalendarDisplayMode { week, month }

/// 时间选择模式，单个时间，时间范围
enum DxCalendarSelectMode { single, range }

const List<String> _defaultWeekNames = ['日', '一', '二', '三', '四', '五', '六'];

/// 日历组件 包括月视图，周视图、日期单选、日期范围选等功能。
/// 1、点击不同月份日期，自动切换到最新选中日期所在月份。
/// 2、日历组件支持时间范围展示，仅展示范围内的日历视图，范围外日期置灰不可点击。日期范围边界后不可再翻页。
class DxCalendar extends StatefulWidget {
  const DxCalendar({
    Key? key,
    this.selectMode = DxCalendarSelectMode.single,
    this.displayMode = DxCalendarDisplayMode.month,
    this.weekNames = _defaultWeekNames,
    this.showControllerBar = true,
    this.initStartSelectedDate,
    this.initEndSelectedDate,
    this.initDisplayDate,
    this.dateChange,
    this.rangeDateChange,
    this.minDate,
    this.maxDate,
  })  : assert(weekNames.length == 7),
        assert(selectMode == DxCalendarSelectMode.single && dateChange != null ||
            selectMode == DxCalendarSelectMode.range && rangeDateChange != null),
        super(key: key);

  const DxCalendar.single({
    Key? key,
    this.displayMode = DxCalendarDisplayMode.month,
    this.weekNames = _defaultWeekNames,
    this.showControllerBar = true,
    this.initStartSelectedDate,
    this.initEndSelectedDate,
    this.initDisplayDate,
    required this.dateChange,
    this.minDate,
    this.maxDate,
  })  : selectMode = DxCalendarSelectMode.single,
        rangeDateChange = null,
        assert(weekNames.length == 7),
        super(key: key);

  const DxCalendar.range({
    Key? key,
    this.displayMode = DxCalendarDisplayMode.month,
    this.weekNames = _defaultWeekNames,
    this.showControllerBar = true,
    this.initStartSelectedDate,
    this.initEndSelectedDate,
    this.initDisplayDate,
    required this.rangeDateChange,
    this.minDate,
    this.maxDate,
  })  : selectMode = DxCalendarSelectMode.range,
        dateChange = null,
        assert(weekNames.length == 7),
        super(key: key);

  /// 展示模式， Week, Month
  final DxCalendarDisplayMode displayMode;

  /// 选择模式， 单选, 范围选择
  final DxCalendarSelectMode selectMode;

  /// 日历日期选择范围最小值
  ///
  /// 默认 `DateTime(1970)`
  final DateTime? minDate;

  /// 日历日期选择范围最大值
  ///
  /// 默认 `DateTime(2100)`
  final DateTime? maxDate;

  /// 日历日期初始选中最小值
  final DateTime? initStartSelectedDate;

  /// 日历日期初始选中最大值
  final DateTime? initEndSelectedDate;

  /// 是否展示顶部控制按钮
  final bool showControllerBar;

  /// 自定义星期的名称
  final List<String> weekNames;

  /// 初始展示月份
  ///
  /// 默认当前时间
  final DateTime? initDisplayDate;

  /// single 类型选择日期回调
  final DxCalendarDateChange? dateChange;

  /// range 类型选择日期回调
  final DxCalendarRangeDateChange? rangeDateChange;

  @override
  State<DxCalendar> createState() => _DxCustomCalendarState();
}

class _DxCustomCalendarState extends State<DxCalendar> {
  List<DateTime> dateList = <DateTime>[];
  late DateTime _currentDate;
  late DxCalendarDisplayMode _displayMode;
  late DateTime _minDate, _maxDate;
  DateTime? _currentStartSelectedDate, _currentEndSelectedDate;

  @override
  void initState() {
    _displayMode = widget.displayMode;
    _currentDate = widget.initDisplayDate ?? DateTime.now();
    _minDate = widget.minDate ?? DateTime(1970);
    _maxDate = widget.maxDate ?? DateTime(2100);
    _currentStartSelectedDate = widget.initStartSelectedDate;
    _currentEndSelectedDate = widget.initEndSelectedDate;

    if (_displayMode == DxCalendarDisplayMode.month) {
      _setListOfMonthDate(_currentDate);
    } else if (_displayMode == DxCalendarDisplayMode.week) {
      _setListOfWeekDate(_currentDate);
    }
    super.initState();
  }

  void _setListOfWeekDate(DateTime weekDate) {
    dateList.clear();
    List<DateTime> tmpDateList = [];
    int previousDay = weekDate.weekday % 7;
    for (int i = 0; i < weekDate.weekday; i++) {
      tmpDateList.add(weekDate.subtract(Duration(days: previousDay - i)));
    }
    int preCount = tmpDateList.length;
    for (int i = 0; i < (7 - preCount); i++) {
      tmpDateList.add(weekDate.add(Duration(days: i)));
    }

    dateList.addAll(tmpDateList.map((f) => DateTime(f.year, f.month, f.day)));
  }

  void _setListOfMonthDate(DateTime monthDate) {
    dateList.clear();
    List<DateTime> tmpDateList = [];
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMonthDay = (newDate.weekday + 1) % 7;
    for (int i = 1; i <= previousMonthDay; i++) {
      tmpDateList.add(newDate.subtract(Duration(days: previousMonthDay - i)));
    }
    int preMonthCount = tmpDateList.length;
    for (int i = 0; i < (42 - preMonthCount); i++) {
      tmpDateList.add(newDate.add(Duration(days: i + 1)));
    }
    dateList.addAll(tmpDateList.map((f) => DateTime(f.year, f.month, f.day)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _controllerBar(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: _getDaysNameUI()),
        ),
        Column(children: _getDaysNoUI()),
      ],
    );
  }

  Widget _controllerBar() {
    bool isPreIconEnable = _isIconEnable(true);
    bool isNextIconEnable = _isIconEnable(false);
    if (widget.showControllerBar) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (!isPreIconEnable) return;
                setState(() {
                  if (_displayMode == DxCalendarDisplayMode.month) {
                    _currentDate = DateTime(_currentDate.year, _currentDate.month, 0);
                    _setListOfMonthDate(_currentDate);
                  } else if (_displayMode == DxCalendarDisplayMode.week) {
                    _currentDate = _currentDate.subtract(const Duration(days: 7));
                    _setListOfWeekDate(_currentDate);
                  }
                });
              },
              child: Container(
                height: 25,
                width: 40,
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.center,
                child: isPreIconEnable
                    ? Image.asset(DxAsset.calendarPreMonth, package: 'dxwidget')
                    : Image.asset(DxAsset.calendarPreMonth, color: DxStyle.$CCCCCC, package: 'dxwidget'),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(DateFormat('yyyy年MM月').format(_currentDate), style: DxStyle.$222222$14$W500),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!isNextIconEnable) return;
                setState(() {
                  if (_displayMode == DxCalendarDisplayMode.month) {
                    _currentDate = DateTime(_currentDate.year, _currentDate.month + 2, 0);
                    _setListOfMonthDate(_currentDate);
                  } else if (_displayMode == DxCalendarDisplayMode.week) {
                    _currentDate = _currentDate.add(const Duration(days: 7));
                    _setListOfWeekDate(_currentDate);
                  }
                });
              },
              child: Container(
                height: 25,
                width: 40,
                color: Colors.transparent,
                padding: const EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                child: isPreIconEnable
                    ? Image.asset(DxAsset.calendarNextMonth, package: 'dxwidget')
                    : Image.asset(DxAsset.calendarNextMonth, color: DxStyle.$CCCCCC, package: 'dxwidget'),
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  bool _isIconEnable(bool isPre) {
    if (isPre) {
      if (dateList[0].year < _minDate.year) {
        return false;
      }
      if (dateList[0].year == _minDate.year) {
        if (_displayMode == DxCalendarDisplayMode.week) {
          if (dateList[0].month < _minDate.month) {
            return false;
          }
          if (dateList[0].month == _minDate.month) {
            if (dateList[0].day <= _minDate.day) {
              return false;
            }
          }
        } else {
          if (dateList[0].month <= _minDate.month && _currentDate.month == _minDate.month) {
            return false;
          }
        }
      }
      return true;
    } else {
      if (dateList.last.year > _maxDate.year) {
        return false;
      }
      if (dateList.last.year == _maxDate.year) {
        if (_displayMode == DxCalendarDisplayMode.week) {
          if (dateList.last.month > _maxDate.month) {
            return false;
          }
          if (dateList.last.month == _maxDate.month) {
            if (dateList.last.day >= _maxDate.day) {
              return false;
            }
          }
        } else {
          if (dateList.last.month >= _maxDate.month && _currentDate.month == _maxDate.month) {
            return false;
          }
        }
      }
      return true;
    }
  }

  List<Widget> _getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(_getChinaWeekName(i), style: DxStyle.$222222$14),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> _getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  // 范围颜色条
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: _isStartDateRadius(date) ? 8 : 0,
                          right: _isEndDateRadius(date) ? 8 : 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _currentStartSelectedDate != null && _currentEndSelectedDate != null
                              ? (_getIsItStartAndEndDate(date) || _getIsInRange(date)
                                  ? DxStyle.$0984F9.withOpacity(0.14)
                                  : Colors.transparent)
                              : Colors.transparent,
                          borderRadius: BorderRadius.horizontal(
                            left: _isStartDateRadius(date) ? const Radius.circular(24.0) : const Radius.circular(0.0),
                            right: _isEndDateRadius(date) ? const Radius.circular(24.0) : const Radius.circular(0.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getIsItStartAndEndDate(date) ? DxStyle.$0984F9 : Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {
                        final DateTime newMinimumDate = DateTime(_minDate.year, _minDate.month, _minDate.day - 1);
                        final DateTime newMaximumDate = DateTime(_maxDate.year, _maxDate.month, _maxDate.day + 1);
                        if (date.isAfter(newMinimumDate) && date.isBefore(newMaximumDate)) {
                          _currentDate = date;
                          if (_displayMode == DxCalendarDisplayMode.week) {
                            _setListOfWeekDate(_currentDate);
                          } else if (_displayMode == DxCalendarDisplayMode.month) {
                            _setListOfMonthDate(_currentDate);
                          }
                          if (widget.selectMode == DxCalendarSelectMode.single) {
                            _onSingleDateClick(date);
                          } else {
                            _onRangeDateClick(date);
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Text(
                            date.day > 9 ? '${date.day}' : '0${date.day}',
                            style: TextStyle(
                                color: _displayMode == DxCalendarDisplayMode.month
                                    ? (_getIsItStartAndEndDate(date)
                                        ? Colors.white
                                        : _currentDate.month == date.month &&
                                                0 <= date.compareTo(_minDate) &&
                                                date.compareTo(_maxDate) <= 0
                                            ? DxStyle.$222222
                                            : DxStyle.$CCCCCC)
                                    : (_getIsItStartAndEndDate(date)
                                        ? Colors.white
                                        : (0 <= date.compareTo(_minDate) && date.compareTo(_maxDate) <= 0
                                            ? DxStyle.$222222
                                            : DxStyle.$CCCCCC)),
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                          color: DateTime.now().day == date.day &&
                                  DateTime.now().month == date.month &&
                                  DateTime.now().year == date.year
                              ? DxStyle.$0984F9
                              : Colors.transparent,
                          shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool _getIsInRange(DateTime date) {
    if (_currentStartSelectedDate != null && _currentEndSelectedDate != null) {
      if (date.isAfter(_currentStartSelectedDate!) && date.isBefore(_currentEndSelectedDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool _getIsItStartAndEndDate(DateTime date) {
    if (_currentStartSelectedDate != null &&
        _currentStartSelectedDate!.day == date.day &&
        _currentStartSelectedDate!.month == date.month &&
        _currentStartSelectedDate!.year == date.year) {
      return true;
    } else if (_currentEndSelectedDate != null &&
        _currentEndSelectedDate!.day == date.day &&
        _currentEndSelectedDate!.month == date.month &&
        _currentEndSelectedDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool _isStartDateRadius(DateTime date) {
    if (_currentStartSelectedDate != null &&
        _currentStartSelectedDate!.day == date.day &&
        _currentStartSelectedDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  bool _isEndDateRadius(DateTime date) {
    if (_currentEndSelectedDate != null &&
        _currentEndSelectedDate!.day == date.day &&
        _currentEndSelectedDate!.month == date.month) {
      return true;
    } else if (date.weekday == 6) {
      return true;
    } else {
      return false;
    }
  }

  void _onSingleDateClick(DateTime date) {
    _currentStartSelectedDate = date;
    _currentEndSelectedDate = date;
    setState(() {
      try {
        if (widget.dateChange != null) {
          widget.dateChange!(date);
        }
      } catch (_) {}
    });
  }

  void _onRangeDateClick(DateTime date) {
    if (_currentStartSelectedDate == null) {
      _currentStartSelectedDate = date;
    } else if (_currentStartSelectedDate != date && _currentEndSelectedDate == null) {
      _currentEndSelectedDate = date;
    } else if (_currentStartSelectedDate == null && _currentEndSelectedDate != null) {
      _currentStartSelectedDate = _currentEndSelectedDate;
      _currentEndSelectedDate = null;
    } else {
      _currentStartSelectedDate = date;
      _currentEndSelectedDate = null;
    }

    if (_currentStartSelectedDate != null && _currentEndSelectedDate != null) {
      if (!_currentEndSelectedDate!.isAfter(_currentStartSelectedDate!)) {
        final DateTime d = _currentStartSelectedDate!;
        _currentStartSelectedDate = _currentEndSelectedDate;
        _currentEndSelectedDate = d;
      }
      if (date.isBefore(_currentStartSelectedDate!)) {
        _currentStartSelectedDate = date;
      }
      if (date.isAfter(_currentEndSelectedDate!)) {
        _currentEndSelectedDate = date;
      }
    }

    setState(() {
      if (_currentStartSelectedDate != null && _currentEndSelectedDate != null && widget.rangeDateChange != null) {
        widget.rangeDateChange!(DateTimeRange(
          start: _currentStartSelectedDate!,
          end: _currentEndSelectedDate!,
        ));
      }
    });
  }

  String _getChinaWeekName(int weekOfDay) {
    return widget.weekNames[weekOfDay];
  }
}
