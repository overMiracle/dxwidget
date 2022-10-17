import 'package:dxwidget/src/utils/num/decimal.dart';
import 'package:dxwidget/src/utils/num/rational.dart';

/// 保留x位小数, 精确加、减、乘、除, 防止精度丢失
/// @GitHub: https://github.com/Sky24n
/// @Description: Num Util.
/// @Date: 2018/9/18

class DxNumUtil {
  DxNumUtil._();

  /// 字符串格式的数字去0
  static String trim0ByStr(String? valueStr) {
    if (valueStr == null) return '0';
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    String numStr = valueStr.replaceAll(regex, '');
    return numStr != '' ? numStr : '0';
  }

  /// 数值型的数字去0
  static String trim0ByNum(num? n) {
    if (n == null) return '';
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  /// 字符串转数字，fractionDigits指定小数长度
  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueStr(String valueStr, {int? fractionDigits}) {
    double? value = double.tryParse(valueStr);
    return fractionDigits == null ? value : getNumByValueDouble(value, fractionDigits);
  }

  /// double转数字，fractionDigits指定小数长度
  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num? getNumByValueDouble(double? value, int fractionDigits) {
    if (value == null) return null;
    String valueStr = value.toStringAsFixed(fractionDigits);
    return fractionDigits == 0 ? int.tryParse(valueStr) : double.tryParse(valueStr);
  }

  /// 字符串装整形，如果为null返回默认值defValue
  static int? getIntByValueStr(String valueStr, {int? defValue = 0}) {
    return int.tryParse(valueStr) ?? defValue;
  }

  /// 字符串返回浮点型，如果为null返回默认值defValue
  static double? getDoubleByValueStr(String valueStr, {double? defValue = 0}) {
    return double.tryParse(valueStr) ?? defValue;
  }

  /// 数值是否是0
  static bool isZero(num? value) {
    return value == null || value == 0;
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static double add(num a, num b) {
    return addDec(a, b).toDouble();
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static double subtract(num a, num b) {
    return subtractDec(a, b).toDouble();
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static double multiply(num a, num b) {
    return multiplyDec(a, b).toDouble();
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static double divide(num a, num b) {
    return divideDec(a, b).toDouble();
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static DxDecimal addDec(num a, num b) {
    return addDecStr(a.toString(), b.toString());
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static DxDecimal subtractDec(num a, num b) {
    return subtractDecStr(a.toString(), b.toString());
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static DxDecimal multiplyDec(num a, num b) {
    return multiplyDecStr(a.toString(), b.toString());
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static DxDecimal divideDec(num a, num b) {
    return divideDecStr(a.toString(), b.toString());
  }

  /// 余数
  static DxDecimal remainder(num a, num b) {
    return remainderDecStr(a.toString(), b.toString());
  }

  /// Relational less than operator.
  static bool lessThan(num a, num b) {
    return lessThanDecStr(a.toString(), b.toString());
  }

  /// Relational less than or equal operator.
  static bool thanOrEqual(num a, num b) {
    return thanOrEqualDecStr(a.toString(), b.toString());
  }

  /// Relational greater than operator.
  static bool greaterThan(num a, num b) {
    return greaterThanDecStr(a.toString(), b.toString());
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqual(num a, num b) {
    return greaterOrEqualDecStr(a.toString(), b.toString());
  }

  /// 加
  static DxDecimal addDecStr(String a, String b) {
    return DxDecimal.parse(a) + DxDecimal.parse(b);
  }

  /// 减
  static DxDecimal subtractDecStr(String a, String b) {
    return DxDecimal.parse(a) - DxDecimal.parse(b);
  }

  /// 乘
  static DxDecimal multiplyDecStr(String a, String b) {
    return DxDecimal.parse(a) * DxDecimal.parse(b);
  }

  /// 除
  static DxDecimal divideDecStr(String a, String b) {
    DxRational value = DxDecimal.parse(a) / DxDecimal.parse(b);
    return value.toDecimal();
  }

  /// 余数
  static DxDecimal remainderDecStr(String a, String b) {
    return DxDecimal.parse(a) % DxDecimal.parse(b);
  }

  /// Relational less than operator.
  static bool lessThanDecStr(String a, String b) {
    return DxDecimal.parse(a) < DxDecimal.parse(b);
  }

  /// Relational less than or equal operator.
  static bool thanOrEqualDecStr(String a, String b) {
    return DxDecimal.parse(a) <= DxDecimal.parse(b);
  }

  /// Relational greater than operator.
  static bool greaterThanDecStr(String a, String b) {
    return DxDecimal.parse(a) > DxDecimal.parse(b);
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqualDecStr(String a, String b) {
    return DxDecimal.parse(a) >= DxDecimal.parse(b);
  }
}
