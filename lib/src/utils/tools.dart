class DxTools {
  const DxTools._();

  /// 判空
  static bool isEmpty(Object? obj) {
    if (obj is String) {
      return obj.isEmpty;
    }
    if (obj is Iterable) {
      return obj.isEmpty;
    }
    if (obj is Map) {
      return obj.isEmpty;
    }
    return obj == null;
  }

  /// 移除数字后面所有的0
  static String removeZero(String? num) {
    if (num == null) return '';
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    String numStr = num.replaceAll(regex, '');
    return numStr != '' ? numStr : '0';
  }
}
