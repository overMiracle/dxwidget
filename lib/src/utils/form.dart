import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 主要用于各种输入值变化
typedef OnFormRadioValueChanged = void Function(String? oldStr, String? newStr);
typedef OnFormSwitchChanged = void Function(bool oldValue, bool newValue);
typedef OnFormValueChanged = void Function(int oldValue, int newValue);
typedef OnFormMultiChoiceValueChanged = void Function(List<String> oldValue, List<String> newValue);
typedef OnFormBtnSelectChanged = void Function(List<bool> oldValue, List<bool> newValue);

/// 表单UI配置相关
class DxFormUtil {
  DxFormUtil._();

  /// 必填和标题组件
  static Widget buildTitleWidget(bool isRequired, Widget? leading, String title) {
    if (isRequired) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          isRequired
              ? const Positioned(
                  left: -10,
                  top: 1,
                  child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.left),
                )
              : const SizedBox.shrink(),
          leading != null
              ? Padding(padding: EdgeInsets.only(left: isRequired ? 5 : 0, right: 10), child: leading)
              : const SizedBox.shrink(),
          Text(title, style: DxStyle.$404040$14$W500),
        ],
      );
    }
    return Row(
      children: [
        leading != null
            ? Padding(
                padding: const EdgeInsets.only(right: 10),
                child: leading,
              )
            : const SizedBox.shrink(),
        Text(title, style: DxStyle.$404040$14$W500),
      ],
    );
  }

  /// 辅助图标
  static Widget buildHelperWidget(
    IconData? helperIcon,
    Widget? helperWidget,
    String? helperString,
    VoidCallback? onHelper,
  ) {
    return Offstage(
      offstage: (helperIcon == null && helperWidget == null && helperString == ''),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onHelper?.call(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Offstage(
              offstage: helperIcon == null && helperWidget == null,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 1),
                child: helperWidget ?? Icon(helperIcon, size: 14, color: DxStyle.$999999),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: helperIcon == null && helperWidget == null ? 8 : 2),
              child: Text(helperString ?? '', style: DxStyle.$999999$12),
            ),
          ],
        ),
      ),
    );
  }

  /// 视觉同学要求修改右箭头图标
  static Widget buildRightArrowWidget() {
    return const Padding(
      padding: EdgeInsets.only(left: 2, top: 1),
      child: Icon(Icons.arrow_forward_ios, size: 14, color: DxStyle.$CCCCCC),
    );
  }

  /// 处理点击"按钮"动作
  static void notifyTap(BuildContext context, VoidCallback? onWidgetTap) {
    if (onWidgetTap != null) {
      onWidgetTap();
    }
  }

  /// 处理 输入状态 变化
  static void notifyInputChanged(ValueChanged<String>? onTextChanged, String newStr) {
    if (onTextChanged != null) {
      onTextChanged(/*oldStr, */ newStr);
    }
  }

  /// 处理 开关 变化
  static void notifySwitchChanged(OnFormSwitchChanged? onSwitchChanged, bool oldValue, bool newValue) {
    if (onSwitchChanged != null) {
      onSwitchChanged(oldValue, newValue);
    }
  }

  /// 处理 数字值 变化
  static void notifyValueChanged(OnFormValueChanged? onValueChanged, BuildContext context, int oldVal, int newVal) {
    if (onValueChanged != null) {
      onValueChanged(oldVal, newVal);
    }
  }

  /// 处理 单选选中状态变化
  static void notifyRadioStatusChanged(
      OnFormRadioValueChanged? onTextChanged, BuildContext context, Object? oldVal, Object? newVal) {
    if (onTextChanged != null) {
      onTextChanged(oldVal as String?, newVal as String?);
    }
  }

  /// 处理 多选选中状态变化
  static void notifyMultiChoiceStatusChanged(
    OnFormMultiChoiceValueChanged? onChoiceChanged,
    BuildContext context,
    List<String> oldVal,
    List<String> newVal,
  ) {
    if (onChoiceChanged != null) {
      onChoiceChanged(oldVal, newVal);
    }
  }

  /// 手机号码格式化输出
  static TextInputFormatter phoneInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text;
      //获取光标左边的文本
      final positionStr = (text.substring(0, newValue.selection.baseOffset)).replaceAll(RegExp(r"\s+\b|\b\s"), "");
      //计算格式化后的光标位置
      int length = positionStr.length;
      var position = 0;
      if (length <= 3) {
        position = length;
      } else if (length <= 7) {
        // 因为前面的字符串里面加了一个空格
        position = length + 1;
      } else if (length <= 11) {
        // 因为前面的字符串里面加了两个空格
        position = length + 2;
      } else {
        // 号码本身为 11 位数字，因多了两个空格，故为 13
        position = 13;
      }

      //这里格式化整个输入文本
      text = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
      var string = "";
      for (int i = 0; i < text.length; i++) {
        // 这里第 4 位，与第 8 位，我们用空格填充
        if (i == 3 || i == 7) {
          if (text[i] != " ") {
            string = "$string ";
          }
        }
        string += text[i];
      }

      return TextEditingValue(
        text: string,
        selection: TextSelection.fromPosition(TextPosition(offset: position, affinity: TextAffinity.upstream)),
      );
    });
  }
}
