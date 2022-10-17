import 'dart:math';

/// Extension methods for any [List].
extension ListExtensions<E> on List<E> {
  // Common

  // Common - Get

  /// Returns a random element from the list.
  ///
  /// Throws a [StateError] if `this` is empty.
  E get random {
    if (isEmpty) {
      throw StateError('No element');
    }

    final rnd = Random();
    return this[rnd.nextInt(length)];
  }

  // Transformation

  // Transformation - List
  /// Copy current list with adding [element] at the end of new list.
  ///
  /// If current list is `null` - new list with [element] will be created.
  List<E> copyWith(E element) => List.from(this)..add(element);

  /// Copy current list with adding all [elements] at the end of new list.
  ///
  /// If current list is `null` - copy of list [elements] will be created.
  List<E> copyWithAll(List<E> elements) => List.from(this)..addAll(elements);

  /// Copy current list, replacing all [element] occurrences with [replacement].
  ///
  /// If [element] is not in the list than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<E> copyWithReplace(E element, E replacement) {
    return [for (final e in this) e == element ? replacement : e];
  }

  /// Copy current list with adding all [elements] at the position of new list.
  ///
  /// Error throwed due to a value being outside a valid range.
  List<E> copyWithInsertAll(int index, List<E> elements) => List.from(this)..insertAll(index, elements);

  // Modification

  // Modification - Element

  /// Replaces all [element] occurrences with [replacement].
  ///
  /// Returns `true` if element was replaced.
  /// If [element] is not in the list than will be no changes.
  /// If there are multiple [element] in list - all will be replaced.
  bool replace(E element, E replacement) {
    var found = false;
    final len = length;
    for (var i = 0; i < len; i++) {
      if (element == this[i]) {
        this[i] = replacement;
        found = true;
      }
    }

    return found;
  }

  /// Adds [value] to the end of this list
  /// only if it's not null.
  ///
  /// The list must be growable.
  bool addIfNotNull(E? value) {
    if (value != null) {
      add(value);
      return true;
    } else {
      return false;
    }
  }

  // Modification - Sorting

  /// Sorts the list in ascending order of the object's field value.
  void sortBy(Comparable Function(E e) getVal) => sort((a, b) => getVal(a).compareTo(getVal(b)));

  /// Sorts the list in descending order of the object's field value.
  void sortByDescending(Comparable Function(E e) getVal) => sort((a, b) => getVal(b).compareTo(getVal(a)));
}

extension NullableListExtensions<E> on List<E>? {
  // Transformation

  // Transformation - List

  /// Copy current list with adding [element] at the end of new list.
  ///
  /// If current list is `null` - new list with [element] will be created.
  List<E> copyWith(E element) => this?.copyWith(element) ?? [element];

  /// Copy current list with adding all [elements] at the end of new list.
  ///
  /// If current list is `null` - copy of list [elements] will be created.
  List<E> copyWithAll(List<E> elements) => this?.copyWithAll(elements) ?? List.from(elements);

  /// Copy current list with adding all [elements] at the position of new list.
  ///
  /// If current list is `null` - copy of list [elements] will be created.
  /// Error throwed due to a value being outside a valid range.
  List<E> copyWithInsertAll(int index, List<E> elements) =>
      this?.copyWithInsertAll(index, elements) ?? List.from(elements);

  /// Copy current list, replacing all [element] occurrences with [replacement].
  ///
  /// If [element] is not in the list than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<E> copyWithReplace(E element, E replacement) {
    return this?.copyWithReplace(element, replacement) ?? const [];
  }
}

/// Extension methods for any [Iterable].
extension IterableExtensions<E> on Iterable<E> {
  /// Returns `true` if the collection contains all elements from the [elements].
  ///
  /// Order of elements does not matter.
  ///
  /// See [contains].
  bool containsAll(Iterable<E> elements) {
    for (final e in elements) {
      if (!contains(e)) return false;
    }

    return true;
  }

  // Common - Safe elements access

  /// Returns the first element or `null` if `this` is empty.
  E? get firstOrNull => isEmpty ? null : first;

  /// Returns the element at the [index] if exists
  /// or [orElse] if it is out of range.
  E? elementAtOrNull(int index) {
    try {
      return elementAt(index);
    } catch (e) {
      return null;
    }
  }

  /// Returns the element at the [index] if exists
  /// or [orElse] if it is out of range.
  E? tryElementAt(int index, {E? orElse}) {
    try {
      return elementAt(index);
    } catch (e) {
      return orElse;
    }
  }
}
