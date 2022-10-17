import 'package:dxwidget/src/components/toast/toast.dart';
import 'package:flutter/services.dart';

/// 剪贴板组件
/// 来自开源项目：https://github.com/samuelezedi/flutter_clipboard.git
class DxClipboard {
  /// copy receives a string text and saves to Clipboard
  /// returns void
  static Future<void> copy(String? text) async {
    if (text == null || text == '') {
      DxToast.show('复制失败：内容为空');
      return;
    }
    Clipboard.setData(ClipboardData(text: text));
    DxToast.show('复制成功');
  }

  /// Paste retrieves the data from clipboard.
  static Future<String> paste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data?.text?.toString() ?? "";
  }

  /// controlC receives a string text and saves to Clipboard
  /// returns boolean value
  static Future<bool> controlC(String text) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } else {
      return false;
    }
  }

  /// controlV retrieves the data from clipboard.
  /// same as paste
  /// But returns dynamic data
  static Future<dynamic> controlV() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data;
  }
}
