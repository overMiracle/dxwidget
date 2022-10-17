import 'package:flutter/services.dart';

/// 输入框验证输入金钱
/// 涉及金钱使用：
/// 只能录入数字，并且录入的数字最多保留二位小数。不会以0开头，自动转为0.。
/// 小数点只能输入一个且之后只能输入两位数字
///  不能输入除.和数字外的其他字符
///  示例
///  TextField(
///     ...
///          controller: myController
///          //由于某些机型键盘并不能做到强制故再条件上加上FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')
///          keyboardType: TextInputType.numberWithOptions(decimal: true),
///          inputFormatters: [
///                    PrecisionLimitFormatter(2)，
///                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
/// ],
/// )
class DxMoneyLimitFormatter extends TextInputFormatter {
  final int _scale;

  DxMoneyLimitFormatter(this._scale);

  RegExp exp = RegExp(r"[0-9]");
  static const String pointer = ".";
  static const String doubleZero = "00";
  static const String zero = "0";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith('.')) {
      return const TextEditingValue(text: '0.', selection: TextSelection.collapsed(offset: 2));
    }

    ///输入完全删除
    if (newValue.text.isEmpty) {
      return const TextEditingValue();
    }

    ///只允许输入小数
    if (!exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    if (newValue.text.startsWith(zero) && newValue.text.split("0")[1].startsWith(RegExp(r'[0-9]'))) {
      return const TextEditingValue(text: '0', selection: TextSelection.collapsed(offset: 1));

      // return newValue;
    }

    ///包含小数点的情况
    if (newValue.text.contains(pointer)) {
      ///包含多个小数
      if (newValue.text.indexOf(pointer) != newValue.text.lastIndexOf(pointer)) {
        return oldValue;
      }
      String input = newValue.text;
      int index = input.indexOf(pointer);

      ///小数点后位数
      int lengthAfterPointer = input.substring(index, input.length).length - 1;

      ///小数位大于精度
      if (lengthAfterPointer > _scale) {
        return oldValue;
      }
    } else if (newValue.text.startsWith(pointer) || newValue.text.startsWith(doubleZero)) {
      ///不包含小数点,不能以“00”开头
      return oldValue;
    }
    return newValue;
  }
}
