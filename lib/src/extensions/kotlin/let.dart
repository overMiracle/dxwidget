/// [let] can be used to invoke one or more functions on results of call chains.
///
/// For example, the following code prints the results of two operations on a
/// collection:
///
/// ```dart
/// final numbers = ['one', 'two', 'three', 'four', 'five'];
/// final resultList = numbers.map((it) => it.length).where((it) => it > 3);
/// print(resultList);
/// ```
///
/// With [let] that code can be rewriten:
///
/// ```dart
/// final numbers = ['one', 'two', 'three', 'four', 'five'];
///
/// numbers.map((it) => it.length).where((it) => it > 3).let((it) {
///   print(it);
///   // And more function calls if needed.
/// });
/// ```
///
/// [let] is often used for executing a code block only with non-null values.
/// To perform actions on a non-null object, use the
/// [null aware operator](https://dart.dev/null-safety/understanding-null-safety#smarter-null-aware-methods)
/// `?.` on it and call `let` with the actions in its block:
///
/// ```dart
/// final String? str = 'Hello';
///
/// final length = str?.let((it) {
///   print('let() called on $it');
///   assert(it != null); // 'it' is not null inside '?.let()'
///   return it.length;
/// });
/// ```
///
/// Another case for using [let] is introducing local variables with a limited
/// scope for improving code readability.
///
/// [let] expects a function with a single argument, normally called `it`.
/// And this argument can be rename to anything:
///
/// ```dart
/// final String? str = 'Hello';
/// final numbers = ['one', 'two', 'three', 'four'];
/// final modifiedFirstItem = numbers.first.let((firstItem) {
///   print('The first item of the list is "$firstItem"');
///   return iff(firstItem.length >= 5, () {
///     return firstItem;
///   }).orElse(() {
///     return '!$firstItem!';
///   });
/// }).toUpperCase();
///
/// print('First item after modifications: "$modifiedFirstItem"');
/// ```
extension Let<T> on T {
  /// Calls the specified `block` with the current value as its argument.
  R let<R>(R Function(T it) block) {
    return block(this);
  }
}
