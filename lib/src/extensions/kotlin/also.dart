/// [also] can be used for performing actions that need the current value as an
/// argument. It returns the current value.
///
/// When you see [also] in the code, you can read it as "and also do the
/// following with the object."
///
/// ```dart
/// final numbers = ['one', 'two', 'three', 'four', 'five'];
/// numbers.also((it) => print('The list elements before add: $it')).add('six');
/// ```
extension Also<T> on T {
  /// Calls the specified `block` with the current value as its argument.
  ///
  /// It also returns the current value.
  T also(dynamic Function(T it) block) {
    block(this);
    return this;
  }
}
