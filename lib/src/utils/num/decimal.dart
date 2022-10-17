import 'package:dxwidget/src/utils/num/rational.dart';

/// github地址：https://github.com/a14n/dart-decimal
final _i0 = BigInt.zero;
final _i1 = BigInt.one;
final _i2 = BigInt.two;
final _i5 = BigInt.from(5);
final _r10 = DxRational.fromInt(10);

/// A number that can be exactly written with a finite number of digits in the
/// decimal system.
class DxDecimal implements Comparable<DxDecimal> {
  /// Create a new decimal from its rational value.
  DxDecimal._(this._rational) : assert(_rational.hasFinitePrecision);

  /// Create a new [DxDecimal] from a [BigInt].
  factory DxDecimal.fromBigInt(BigInt value) => value.toRational().toDecimal();

  /// Create a new [DxDecimal] from an [int].
  factory DxDecimal.fromInt(int value) => DxDecimal.fromBigInt(BigInt.from(value));

  /// Create a new [DxDecimal] from its [String] representation.
  factory DxDecimal.fromJson(String value) => DxDecimal.parse(value);

  final DxRational _rational;

  /// Parses [source] as a decimal literal and returns its value as [DxDecimal].
  static DxDecimal parse(String source) => DxRational.parse(source).toDecimal();

  /// Parses [source] as a decimal literal and returns its value as [DxDecimal].
  static DxDecimal? tryParse(String source) {
    try {
      return DxDecimal.parse(source);
    } on FormatException {
      return null;
    }
  }

  /// The [DxDecimal] corresponding to `0`.
  static DxDecimal zero = DxDecimal.fromInt(0);

  /// The [DxDecimal] corresponding to `1`.
  static DxDecimal one = DxDecimal.fromInt(1);

  /// The [DxDecimal] corresponding to `10`.
  static DxDecimal ten = DxDecimal.fromInt(10);

  /// The [DxRational] corresponding to `this`.
  DxRational toRational() => _rational;

  /// Returns `true` if `this` is an integer.
  bool get isInteger => _rational.isInteger;

  /// Returns a [DxRational] corresponding to `1/this`.
  DxRational get inverse => _rational.inverse;

  @override
  bool operator ==(Object other) => other is DxDecimal && _rational == other._rational;

  @override
  int get hashCode => _rational.hashCode;

  /// Returns a [String] representation of `this`.
  @override
  String toString() {
    if (_rational.isInteger) return _rational.toString();
    var value = toStringAsFixed(scale);
    while (value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  /// Converts `this` to [String] by using [toString].
  String toJson() => toString();

  @override
  int compareTo(DxDecimal other) => _rational.compareTo(other._rational);

  /// Addition operator.
  DxDecimal operator +(DxDecimal other) => (_rational + other._rational).toDecimal();

  /// Subtraction operator.
  DxDecimal operator -(DxDecimal other) => (_rational - other._rational).toDecimal();

  /// Multiplication operator.
  DxDecimal operator *(DxDecimal other) => (_rational * other._rational).toDecimal();

  /// Euclidean modulo operator.
  ///
  /// See [num.operator%].
  DxDecimal operator %(DxDecimal other) => (_rational % other._rational).toDecimal();

  /// Division operator.
  DxRational operator /(DxDecimal other) => _rational / other._rational;

  /// Truncating division operator.
  ///
  /// See [num.operator~/].
  BigInt operator ~/(DxDecimal other) => _rational ~/ other._rational;

  /// Returns the negative value of this rational.
  DxDecimal operator -() => (-_rational).toDecimal();

  /// Return the remainder from dividing this [DxDecimal] by [other].
  DxDecimal remainder(DxDecimal other) => (_rational.remainder(other._rational)).toDecimal();

  /// Whether this number is numerically smaller than [other].
  bool operator <(DxDecimal other) => _rational < other._rational;

  /// Whether this number is numerically smaller than or equal to [other].
  bool operator <=(DxDecimal other) => _rational <= other._rational;

  /// Whether this number is numerically greater than [other].
  bool operator >(DxDecimal other) => _rational > other._rational;

  /// Whether this number is numerically greater than or equal to [other].
  bool operator >=(DxDecimal other) => _rational >= other._rational;

  /// Returns the absolute value of `this`.
  DxDecimal abs() => _rational.abs().toDecimal();

  /// The signum function value of `this`.
  ///
  /// E.e. -1, 0 or 1 as the value of this [DxDecimal] is negative, zero or positive.
  int get signum => _rational.signum;

  /// Returns the greatest [DxDecimal] value no greater than this [DxRational].
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = DxDecimal.parse('123.4567');
  /// x.floor(); // 123
  /// x.floor(scale: 1); // 123.4
  /// x.floor(scale: 2); // 123.45
  /// x.floor(scale: -1); // 120
  /// ```
  DxDecimal floor({int scale = 0}) => _scaleAndApply(scale, (e) => e.floor());

  /// Returns the least [DxDecimal] value that is no smaller than this [DxRational].
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = DxDecimal.parse('123.4567');
  /// x.ceil(); // 124
  /// x.ceil(scale: 1); // 123.5
  /// x.ceil(scale: 2); // 123.46
  /// x.ceil(scale: -1); // 130
  /// ```
  DxDecimal ceil({int scale = 0}) => _scaleAndApply(scale, (e) => e.ceil());

  /// Returns the [DxDecimal] value closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  /// `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = DxDecimal.parse('123.4567');
  /// x.round(); // 123
  /// x.round(scale: 1); // 123.5
  /// x.round(scale: 2); // 123.46
  /// x.round(scale: -1); // 120
  /// ```
  DxDecimal round({int scale = 0}) => _scaleAndApply(scale, (e) => e.round());

  DxDecimal _scaleAndApply(int scale, BigInt Function(DxRational) f) {
    final scaleFactor = ten.pow(scale);
    return (f(_rational * scaleFactor).toRational() / scaleFactor).toDecimal();
  }

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  DxDecimal truncate({int scale = 0}) => _scaleAndApply(scale, (e) => e.truncate());

  /// Shift the decimal point on the right for positive [value] or on the left
  /// for negative one.
  ///
  /// ```dart
  /// var x = DxDecimal.parse('123.4567');
  /// x.shift(1); // 1234.567
  /// x.shift(-1); // 12.34567
  /// ```
  DxDecimal shift(int value) => this * ten.pow(value).toDecimal();

  /// Clamps `this` to be in the range [lowerLimit]-[upperLimit].
  DxDecimal clamp(DxDecimal lowerLimit, DxDecimal upperLimit) =>
      _rational.clamp(lowerLimit._rational, upperLimit._rational).toDecimal();

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  BigInt toBigInt() => _rational.toBigInt();

  /// Returns `this` as a [double].
  ///
  /// If the number is not representable as a [double], an approximation is
  /// returned. For numerically large integers, the approximation may be
  /// infinite.
  double toDouble() => _rational.toDouble();

  /// The precision of this [DxDecimal].
  ///
  /// The precision is the number of digits in the unscaled value.
  ///
  /// ```dart
  /// DxDecimal.parse('0').precision; // => 1
  /// DxDecimal.parse('1').precision; // => 1
  /// DxDecimal.parse('1.5').precision; // => 2
  /// DxDecimal.parse('0.5').precision; // => 2
  /// ```
  int get precision {
    final value = abs();
    return value.scale + value.toBigInt().toString().length;
  }

  /// The scale of this [DxDecimal].
  ///
  /// The scale is the number of digits after the decimal point.
  ///
  /// ```dart
  /// DxDecimal.parse('1.5').scale; // => 1
  /// DxDecimal.parse('1').scale; // => 0
  /// ```
  int get scale {
    var i = 0;
    var x = _rational;
    while (!x.isInteger) {
      i++;
      x *= _r10;
    }
    return i;
  }

  /// A decimal-point string-representation of this number with [fractionDigits]
  /// digits after the decimal point.
  String toStringAsFixed(int fractionDigits) {
    assert(fractionDigits >= 0);
    if (fractionDigits == 0) return round().toBigInt().toString();
    final value = round(scale: fractionDigits);
    final intPart = value.toBigInt().abs();
    final decimalPart = (one + value.abs() - intPart.toDecimal()).shift(fractionDigits);
    return '${value < zero ? '-' : ''}$intPart.${decimalPart.toString().substring(1)}';
  }

  /// An exponential string-representation of this number with [fractionDigits]
  /// digits after the decimal point.
  String toStringAsExponential([int fractionDigits = 0]) {
    assert(fractionDigits >= 0);

    final negative = this < zero;
    var value = abs();
    var eValue = 0;
    while (value < one && value > zero) {
      value *= ten;
      eValue--;
    }
    while (value >= ten) {
      value = (value / ten).toDecimal();
      eValue++;
    }
    value = value.round(scale: fractionDigits);
    // If the rounded value is 10, then divide it once more to make it follow
    // the normalized scientific notation. See https://github.com/a14n/dart-decimal/issues/74
    if (value == ten) {
      value = (value / ten).toDecimal();
      eValue++;
    }

    return <String>[
      if (negative) '-',
      value.toStringAsFixed(fractionDigits),
      'e',
      if (eValue >= 0) '+',
      '$eValue',
    ].join();
  }

  /// A string representation with [precision] significant digits.
  String toStringAsPrecision(int precision) {
    assert(precision > 0);

    if (this == zero) {
      return <String>[
        '0',
        if (precision > 1) '.',
        for (var i = 1; i < precision; i++) '0',
      ].join();
    }

    final limit = ten.pow(precision).toDecimal();

    var shift = one;
    final absValue = abs();
    var pad = 0;
    while (absValue * shift < limit) {
      pad++;
      shift *= ten;
    }
    while (absValue * shift >= limit) {
      pad--;
      shift = (shift / ten).toDecimal();
    }
    final value = ((this * shift).round() / shift).toDecimal();
    return pad <= 0 ? value.toString() : value.toStringAsFixed(pad);
  }

  /// Returns `this` to the power of [exponent].
  ///
  /// Returns [DxRational.one] if the [exponent] equals `0`.
  DxRational pow(int exponent) => _rational.pow(exponent);
}

/// Extensions on [DxRational].
extension RationalExt on DxRational {
  /// Returns a [DxDecimal] corresponding to `this`.
  ///
  /// Some rational like `1/3` can not be converted to decimal because they need
  /// an infinite number of digits. For those cases (where [hasFinitePrecision]
  /// is `false`) a [scaleOnInfinitePrecision] and a [toBigInt] can be provided
  /// to convert `this` to a [DxDecimal] representation. By default [toBigInt]
  /// use [DxRational.truncate] to limit the number of digit.
  ///
  /// Note that the returned decimal will not be exactly equal to `this`.
  DxDecimal toDecimal({
    int? scaleOnInfinitePrecision,
    BigInt Function(DxRational)? toBigInt,
  }) {
    if (scaleOnInfinitePrecision == null || hasFinitePrecision) {
      return DxDecimal._(this);
    }
    final scaleFactor = _r10.pow(scaleOnInfinitePrecision);
    toBigInt ??= (value) => value.truncate();
    return DxDecimal._(toBigInt(this * scaleFactor).toRational() / scaleFactor);
  }

  /// Returns `true` if this [DxRational] has a finite precision.
  ///
  /// Having a finite precision means that the number can be exactly represented
  /// as decimal with a finite number of fractional digits.
  bool get hasFinitePrecision {
    // the denominator should only be a product of powers of 2 and 5
    var den = denominator;
    while (den % _i5 == _i0) {
      den = den ~/ _i5;
    }
    while (den % _i2 == _i0) {
      den = den ~/ _i2;
    }
    return den == _i1;
  }
}

/// Extensions on [BigInt].
extension BigIntExt on BigInt {
  /// This [BigInt] as a [DxDecimal].
  DxDecimal toDecimal() => DxDecimal.fromBigInt(this);
}

/// Extensions on [int].
extension IntExt on int {
  /// This [int] as a [DxDecimal].
  DxDecimal toDecimal() => DxDecimal.fromInt(this);
}
