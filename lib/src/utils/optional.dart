import 'dart:async';
import 'dart:collection';

/// A constant, absent Optional.
const Optional<dynamic> empty = _Absent<dynamic>();

/// A container object which may contain a non-null value.
///
/// Offers several methods which depend on the presence or absence of a contained value.
abstract class Optional<T> implements Iterable<T> {
  /// Creates a new Optional with the given non-null value.
  ///
  /// Throws [ArgumentError] if value is null.
  factory Optional.of(T value) {
    if (value == null) {
      throw ArgumentError('value must be non-null');
    } else {
      return _Present<T>(value);
    }
  }

  /// Creates a new Optional with the given value, if non-null.  Otherwise, returns an empty Optional.
  factory Optional.ofNullable(T? value) {
    if (value == null) {
      return empty.cast();
    } else {
      return _Present<T>(value);
    }
  }

  /// Creates an empty Optional.
  const factory Optional.empty() = _Absent<T>._internal;

  /// The value associated with this Optional, if any.
  ///
  /// Throws [NoValuePresentError] if no value is present.
  T get value;

  /// Whether the Optional has a value.
  bool get isPresent;

  /// Returns an Optional with this Optional's value, if there is a value present and it matches the predicate.  Otherwise, returns an empty Optional.
  Optional<T> filter(bool Function(T) predicate);

  /// Returns an Optional provided by applying the mapper to this Optional's value, if present.  Otherwise, returns an empty Optional.
  Optional<R> flatMap<R>(Optional<R> Function(T) mapper);

  /// Returns an Optional containing the result of applying the mapper to this Optional's value, if present.  Otherwise, returns an empty Optional.
  ///
  /// If the mapper returns a null value, returns an empty Optional.
  @override
  Optional<R> map<R>(R Function(T) mapper);

  /// Returns this Optional's value, if present.  Otherwise, returns other.
  T orElse(T other);

  /// Returns this Optional's value, if present, as nullable. Otherwise, returns other.
  T? orElseNullable(T? other);

  /// Returns this Optional's value, if present, as nullable.  Otherwise, returns null.
  T? get orElseNull;

  /// Returns this Optional's value, if present.  Otherwise, returns the result of calling supply().
  T orElseGet(T Function() supply);

  /// Returns this Optional's value, if present, as nullable.  Otherwise, returns the result of calling supply().
  T? orElseGetNullable(T? Function() supply);

  /// Returns this Optional's value, if present.  Otherwise, returns the result of calling supply() asynchronously.
  Future<T> orElseGetAsync(Future<T> Function() supply);

  /// Returns this Optional's value, if present, as nullable.  Otherwise, returns the result of calling supply() asynchronously.
  Future<T?> orElseGetNullableAsync(Future<T?> Function() supply);

  /// Returns this Optional's value, if present.  Otherwise, throws the result of calling supplyError().
  T orElseThrow(Object Function() supplyError);

  /// Invokes consume() with this Optional's value, if present.  Otherwise, if orElse is passed, invokes it, otherwise does nothing.
  void ifPresent(void Function(T) consume, {void Function() orElse});

  /// The hashCode of this Optional's value, if present.  Otherwise, 0.
  @override
  int get hashCode;

  @override
  bool operator ==(Object other);

  /// Returns a view of this Optional as an Optional with an [R] value
  @override
  Optional<R> cast<R>();
}

class _Absent<T> extends Iterable<T> implements Optional<T> {
  const _Absent();

  const _Absent._internal();

  @override
  T get value => throw NoValuePresentError();

  @override
  int get length => 0;

  @override
  bool get isPresent => false;

  @override
  Optional<T> filter(bool Function(T) predicate) => empty.cast();

  @override
  Optional<R> flatMap<R>(Optional<R> Function(T) mapper) => empty.cast();

  @override
  Optional<R> map<R>(R Function(T) mapper) => empty.cast();

  @override
  bool contains(Object? val) => false;

  @override
  T orElse(T other) => other;

  @override
  T? orElseNullable(T? other) => other;

  @override
  T? get orElseNull => null;

  @override
  T orElseGet(T Function() supply) => supply();

  @override
  T? orElseGetNullable(T? Function() supply) => supply();

  @override
  Future<T> orElseGetAsync(Future<T> Function() supply) => supply();

  @override
  Future<T?> orElseGetNullableAsync(Future<T?> Function() supply) async => supply();

  @override
  T orElseThrow(Object Function() supplyError) => throw supplyError();

  @override
  void ifPresent(void Function(T) consume, {void Function()? orElse}) => orElse == null ? null : orElse();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is _Absent;

  @override
  String toString() => 'Optional[empty]';

  @override
  Optional<R> cast<R>() => _Absent<R>();

  @override
  bool get isEmpty => true;

  @override
  bool get isNotEmpty => false;

  @override
  Iterator<T> get iterator => Iterable<T>.empty().iterator;
}

extension OptionalExtension<T extends Object> on T {
  /// Returns an Optional with `this` as its value
  Optional<T> get toOptional => Optional.of(this);
}

/// Extensions that apply to all iterables.
extension OptionalIterableExtension<T> on Iterable<T> {
  /// The first element satisfying [test], or `Optional.empty()` if there are none.
  Optional<T> firstWhereOptional(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return Optional.of(element);
    }
    return const Optional.empty();
  }

  /// The first element whose value and index satisfies [test].
  ///
  /// Returns `Optional.empty()` if there are no element and index satisfying [test].
  Optional<T> firstWhereIndexedOptional(bool Function(int index, T element) test) {
    var index = 0;
    for (var element in this) {
      if (test(index++, element)) return Optional.of(element);
    }
    return const Optional.empty();
  }

  /// The first element, or `Optional.empty()` if the iterable is empty.
  Optional<T> get firstOptional {
    var iterator = this.iterator;
    if (iterator.moveNext()) return Optional.of(iterator.current);
    return const Optional.empty();
  }

  /// The last element satisfying [test], or `Optional.empty()` if there are none.
  Optional<T> lastWhereOptional(bool Function(T element) test) {
    T? result;
    for (var element in this) {
      if (test(element)) result = element;
    }
    return Optional.ofNullable(result);
  }

  /// The last element whose index and value satisfies [test].
  ///
  /// Returns `Optional.empty()` if no element and index satisfies [test].
  Optional<T> lastWhereIndexedOptional(bool Function(int index, T element) test) {
    T? result;
    var index = 0;
    for (var element in this) {
      if (test(index++, element)) result = element;
    }
    return Optional.ofNullable(result);
  }

  /// The last element, or `Optional.empty()` if the iterable is empty.
  Optional<T> get lastOptional {
    if (isEmpty) return const Optional.empty();
    return Optional.of(last);
  }

  /// The single element satisfying [test].
  ///
  /// Returns `Optional.empty()` if there are either no elements
  /// or more than one element satisfying [test].
  ///
  /// **Notice**: This behavior differs from [Iterable.singleWhere]
  /// which always throws if there are more than one match,
  /// and only calls the `orElse` function on zero matches.
  Optional<T> singleWhereOptional(bool Function(T element) test) {
    T? result;
    var found = false;
    for (var element in this) {
      if (test(element)) {
        if (!found) {
          result = element;
          found = true;
        } else {
          return const Optional.empty();
        }
      }
    }
    return Optional.ofNullable(result);
  }

  /// The single element satisfying [test].
  ///
  /// Returns `Optional.empty()` if there are either none
  /// or more than one element and index satisfying [test].
  Optional<T> singleWhereIndexedOptional(bool Function(int index, T element) test) {
    T? result;
    var found = false;
    var index = 0;
    for (var element in this) {
      if (test(index++, element)) {
        if (!found) {
          result = element;
          found = true;
        } else {
          return const Optional.empty();
        }
      }
    }
    return Optional.ofNullable(result);
  }

  /// The single element of the iterable, or `Optional.empty()`.
  ///
  /// The value is `Optional.empty()` if the iterable is empty
  /// or it contains more than one element.
  Optional<T> get singleOptional {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var result = iterator.current;
      if (!iterator.moveNext()) {
        return Optional.of(result);
      }
    }
    return const Optional.empty();
  }
}

/// Error thrown when attempting to operate on an empty Optional's value.
class NoValuePresentError extends StateError {
  /// Creates a new NoValuePresentError with a message reading "no value present"
  NoValuePresentError() : super('no value present');
}

class _Present<T> extends Iterable<T> implements Optional<T> {
  const _Present(this._value);

  final T _value;

  @override
  T get value => _value;

  @override
  int get length => 1;

  @override
  bool get isPresent => true;

  @override
  Optional<T> filter(bool Function(T) predicate) {
    if (predicate(_value)) {
      return this;
    } else {
      return empty.cast();
    }
  }

  @override
  Optional<R> flatMap<R>(Optional<R> Function(T) mapper) => mapper(_value);

  @override
  Optional<R> map<R>(R Function(T) mapper) => Optional<R>.ofNullable(mapper(_value));

  @override
  bool contains(Object? val) => _value == val;

  @override
  T orElse(T other) => _value;

  @override
  T? orElseNullable(T? other) => _value;

  @override
  T? get orElseNull => _value;

  @override
  T orElseGet(T Function() supply) => _value;

  @override
  T? orElseGetNullable(T? Function() supply) => _value;

  @override
  Future<T> orElseGetAsync(Future<T> Function() supply) async => _value;

  @override
  Future<T?> orElseGetNullableAsync(Future<T?> Function() supply) async => _value;

  @override
  T orElseThrow(Object Function() supplyError) => _value;

  @override
  void ifPresent(void Function(T) consume, {void Function()? orElse}) => consume(_value);

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(Object other) => other is _Present && other._value == _value;

  @override
  String toString() => 'Optional[value: $_value]';

  @override
  Optional<R> cast<R>() => _Present(value as R);

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

  @override
  Iterator<T> get iterator => UnmodifiableSetView({_value}).iterator;
}
