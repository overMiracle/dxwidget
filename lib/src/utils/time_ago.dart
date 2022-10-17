library dxwidget_timeago;

/// 多久之前
/// github地址：https://github.com/andresaraujo/timeago.dart
class DxTimeAgo {
  /// 10位时间戳
  static String formatByTimestamp(int? timestamp, {DateTime? clock}) {
    if (timestamp == null) return '';
    return format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000), clock: clock);
  }

  static String format(DateTime? date, {DateTime? clock}) {
    if (date == null) return '';
    final $clock = clock ?? DateTime.now();
    var elapsed = $clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    String prefix, suffix;

    if (elapsed < 0) {
      elapsed = date.isBefore($clock) ? elapsed : elapsed.abs();
      suffix = '后';
    } else {
      suffix = '前';
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45) {
      result = '少于1分钟';
    } else if (seconds < 90) {
      result = '约1分钟';
    } else if (minutes < 45) {
      result = '约${minutes.round()}分钟';
    } else if (minutes < 90) {
      result = '约1小时';
    } else if (hours < 24) {
      result = '约${hours.round()}小时';
    } else if (hours < 48) {
      result = '约1天';
    } else if (days < 30) {
      result = '约${days.round()}天';
    } else if (days < 60) {
      result = '约1个月';
    } else if (days < 365) {
      result = '约${months.round()}个月';
    } else if (years < 2) {
      result = '约1年';
    } else {
      result = '约${years.round()}年';
    }

    return [result, suffix].where((str) => str.isNotEmpty).join('');
  }
}
