/// Selected value of DatePicker.
typedef DateValueCallback = Function(DateTime dateTime, List<int> selectedIndex);

/// Pressed cancel callback.
typedef DateVoidCallback = Function();

/// Default value of minimum datetime.
const String DATE_PICKER_MIN_DATETIME = "1900-01-01 00:00:00";

/// Default value of maximum datetime.
const String DATE_PICKER_MAX_DATETIME = "2100-12-31 23:59:59";

/// Default value of date format
const String DATETIME_PICKER_DATE_FORMAT = 'yyyy-MM-dd';

/// Default value of time format
const String DATETIME_PICKER_TIME_FORMAT = 'HH:mm:ss';

/// Default value of datetime format
const String DATETIME_PICKER_DATETIME_FORMAT = 'yyyyMMdd HH:mm:ss';

@override
List<String> getMonths() {
  return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
}

@override
List<String> getWeeksFull() {
  return [
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日",
  ];
}

@override
List<String> getWeeksShort() {
  return [
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日",
  ];
}

@override
List<String>? getMonthsShort() {
  // TODO: implement getMonthsShort
  return null;
}
