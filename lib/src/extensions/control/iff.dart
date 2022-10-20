/// The [iff] method can be used as a normal if statement, or as an expression,
/// i.e. it returns a value.
///
/// The [iff] method can replace complex ternary operators so your code becomes
/// more readable:
/// ```dart
/// // Traditional usage
/// final x = a < b ? a : a == b ? 0 : b;
///
/// // iff usage
/// final x = iff(a < b, () {
///   return a;
/// }).elseIf(a == b, () {
///   return 0;
/// }).orElse(() {
///   return b;
/// });
/// ```
///
/// If you are using the [iff] method as an expression (returning its value or
/// assigning it to a variable), then the expression is required to make use of
/// the `[OrElse] method.
///
/// **Note**: If a `null` is returned, it will assume it has to call the
/// [ElseIf] or [OrElse].
T? iff<T>(bool statement, T Function() branch) {
  if (statement) {
    return branch();
  }
  return null;
}

extension ElseIf<T> on T? {
  T? elseIf(bool statement, T Function() branch) {
    return this ?? iff(statement, branch);
  }
}

extension OrElse<T> on T? {
  T orElse(T Function() branch) {
    return this ?? branch();
  }
}
