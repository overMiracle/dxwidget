class On<T> {
  final dynamic Function(T err) executor;

  const On(this.executor);

  bool matches(dynamic value) => value is T;
}

/// The [tryy] method can be used as a normal try-catch block, or as an
/// expression, i.e. it returns a value.
///
/// The [tryy] allows for assignable try-catch blocks:
///
/// ```dart
/// final value = tryy(() {
///   return someMethodThatCouldFail();
/// }, catches: [
///   On<SomeException>((err) {
///     return 1;
///   })
/// ]);
/// ```
///
/// The [tryy] can be used in combination with the [OrElse] method:
///
/// ```dart
/// final value = tryy(() {
///   return someMethodThatCouldFail();
/// }, catches: [
///   On<SomeException>((err) {
///     return 1;
///   })
/// ].orElse(() {
///   return 1337;
/// });
/// ```
T? tryy<T>(
  T Function() branch, {
  List<On> catches = const [],
}) {
  try {
    return branch();
  } catch (err) {
    for (final catcher in catches) {
      if (catcher.matches(err)) {
        final value = (catcher as dynamic).executor(err);
        assert(value is T);
        return value;
      }
    }
    return null;
  }
}
