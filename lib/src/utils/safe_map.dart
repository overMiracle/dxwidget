import 'dart:core';

/// 安全map
/// [x] 安全取值：可以从Map中连续使用[]操作符取值，任何错误取值都会返回null而不会报错。
/// [x] 安全的嵌套Map：你可以轻松取出深度嵌套Map中的数据，因为即使对Value为null的SafeMap使用[]操作符，也只会返回一个新的SafeMap(null)对象。
/// [x] 按类型取值：支持直接取出期望类型的数据，类型不正确就会返回null而不会报错。
/// [x] 类似Js的空值判断：通过调用isEmpty()方法，空数组，空字典，空字符串或0都会返回true，帮助你快速判断空值。
/// Map map = {
///       'id': 3,
///       'tag': 'student',
///       'info': {
///         'name': 'Jerry',
///       },
///       'class': [
///         {
///           "name": 'class 1',
///           'tag': '',
///         },
///         {},
///       ],
///     };
/// SafeMap safeMap = DxSafeMap(map);

/// 取值,错误的类型会返回SafeMap(null)
/// assert(safeMap['id'].value == 3);
/// assert(safeMap['id'].string == null);

/// 错误的下标也会返回SafeMap(null)
/// assert(safeMap['tag'].value == 'student');
/// assert(safeMap['tag12345'].value == null);

/// 连续取值,可以一直安全取值,只会返回SafeMap(null).
/// assert(safeMap['info']['name'].value == 'Jerry');
/// assert(safeMap['a']['b']['b']['b']['b']['b'].value == null);

/// 取出数组，也可以通过数组下标继续取值
/// assert(safeMap['class'].list.length == 2);
/// assert(safeMap['class'][0]['name'].value == 'class 1');

/// {},[],0,'',null 都会被判断为空
/// assert(safeMap['class'][0]['tag'].isEmpty());
/// assert(safeMap['class'][1].isEmpty());

/// 越界也会返回SafeMap(null)，判断isEmpty为true
/// assert(safeMap['class'][2].isEmpty());
///
class DxSafeMap {
  DxSafeMap(this.value);

  final dynamic value;

  DxSafeMap operator [](dynamic key) {
    if (value is Map) return DxSafeMap(value[key]);
    if (value is List) return DxSafeMap(value.asMap()[key]);
    return DxSafeMap(null);
  }

  dynamic get v => value;
  String? get string => value is String ? value as String? : null;
  num? get number => value is num ? value as num? : null;
  int? get intValue => number?.toInt();
  double? get doubleValue => number?.toDouble();

  Map? get map => value is Map ? value as Map? : null;
  List? get list => value is List ? value as List? : null;
  bool get boolean => value is bool ? value as bool : false;

  /// string or ''
  String get stringOrEmpty => string ?? '';

  /// int or 0
  int get intOrZero => intValue ?? 0;

  /// double or 0
  double get doubleOrZero => doubleValue ?? 0;

  /// Map or {}
  Map get mapOrBlank => map ?? {};

  /// List or []
  List get listOrBlank => list ?? [];

  num? get toNum {
    return number ?? (string == null ? null : num.tryParse(string!));
  }

  ///   "1.0" => null
  ///   122.0 => 122
  int? get toInt {
    return intValue ?? (string == null ? null : int.tryParse(string!));
  }

  int? get forceInt => toDouble?.toInt();

  double? get toDouble {
    return doubleValue ?? intValue?.toDouble() ?? (string == null ? null : double.tryParse(string!));
  }

  /// DateTime form String value.
  /// Use [DateTime.tryParse] Function.
  DateTime? get dateTime => DateTime.tryParse(string!);

  /// DateTime from [this.forceInt * 1000] value
  DateTime? get dateTimeFromSecond => forceInt != null ? DateTime.fromMillisecondsSinceEpoch(forceInt! * 1000) : null;

  /// DateTime from [this.forceInt] value as [millisecond]
  DateTime? get dateTimeFromMillisecond => forceInt != null ? DateTime.fromMillisecondsSinceEpoch(forceInt!) : null;

  /// DateTime from [this.forceInt] value as [microsecond]
  DateTime? get dateTimeFromMicrosecond => forceInt != null ? DateTime.fromMicrosecondsSinceEpoch(forceInt!) : null;

  bool isEmpty() {
    if (v == null) return true;
    if (string == '') return true;
    if (number == 0) return true;
    if (map?.keys.length == 0) return true;
    if (list?.length == 0) return true;
    if (boolean == false) return true;
    return false;
  }

  bool get hasValue => !isEmpty();

  @override
  String toString() => '<DxSafeMap:$value>';
}
