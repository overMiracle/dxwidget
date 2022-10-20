/// [takeUnless] returns the current value if the given block is not satisfied,
/// will return `null` if it is.
///
/// [takeUnless] is a filtering function for a single object.
///
/// ```dart
/// final number = Random().nextInt(10);
/// final oddOrNull = number.takeUnless((it) => it % 2 == 0);
/// print('odd: $oddOrNull');
/// ```
///
/// When chaining other functions after [takeUnless], don't forget to use the
/// `?.` safe call or perform a null check.
extension TakeUnless<T> on T? {
  /// Return the current value if the given block is not satisfied, will return
  /// `null` if it is.
  T? takeUnless(bool Function(T it) block) {
    if (this != null && !block(this as T)) {
      return this;
    }
    return null;
  }
}
