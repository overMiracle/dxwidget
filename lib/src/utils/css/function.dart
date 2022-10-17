import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml_events.dart' as xml;

/// 超链接的点击回调
typedef DxLinkCallback = void Function(String text, String? url);

class TagItem {
  String? name;
  TextStyle? style;
  String? linkUrl;
  bool isLink = false;
}

/// 用于将标签转为 style
class DxCssConvert {
  DxCssConvert(
    String cssContent, {
    DxLinkCallback? linkCallBack,
    TextStyle? defaultStyle,
  }) {
    _eventList = xml.parseEvents(cssContent);
    _linkCallBack = linkCallBack;
    _defaultStyle = defaultStyle;
  }

  /// 超链接的点击回调
  DxLinkCallback? _linkCallBack;

  /// 外部传入的默认文本样式
  TextStyle? _defaultStyle;

  /// 标签的集合
  Iterable<xml.XmlEvent> _eventList = [];

  /// 标签对应的style
  List<TagItem> stack = [];

  /// 转换的思路：将 开始标签 的属性转为 合适的style, 并将其存入集合中
  ///             a开始标签支持的属性：href
  ///           文本标签 去获取style集合的最后一个元素 并应用style样式
  ///           结束标签 则将集合的最后一个元素删除
  List<TextSpan> convert() {
    // 优先使用外部提供的样式
    final TextStyle style = _defaultStyle ??
        const TextStyle(
          fontSize: 14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
          color: DxStyle.$666666,
        );

    final List<TextSpan> spans = [];
    for (var xmlEvent in _eventList) {
      if (xmlEvent is xml.XmlStartElementEvent) {
        if (!xmlEvent.isSelfClosing) {
          final TagItem tag = TagItem();
          TextStyle textStyle = style.copyWith();
          if (xmlEvent.name == 'font') {
            for (var attr in xmlEvent.attributes) {
              switch (attr.name) {
                case 'color':
                  textStyle = textStyle.apply(
                    color: _generateColorByString(attr.value),
                  );
                  break;
                case 'weight':
                  FontWeight fontWeight = _generateFontWidgetByString(attr.value);
                  textStyle = textStyle.apply(
                    fontWeightDelta: fontWeight.index - FontWeight.normal.index,
                  );
                  break;
                case 'size':
                  textStyle = textStyle.apply(
                    fontSizeDelta: _generateFontSize(attr.value) - 13,
                  );
                  break;
              }
            }
            tag.isLink = false;
          }

          if (xmlEvent.name == 'strong') {
            tag.isLink = false;
            textStyle = textStyle.apply(fontWeightDelta: 2);
          }

          if (xmlEvent.name == 'a') {
            tag.isLink = true;
            for (var attr in xmlEvent.attributes) {
              switch (attr.name) {
                case 'href':
                  textStyle = textStyle.apply(color: DxStyle.$0984F9);
                  tag.linkUrl = attr.value;
                  break;
              }
            }
          }
          tag.name = xmlEvent.name;
          tag.style = textStyle;
          stack.add(tag);
        } else {
          if (xmlEvent.name == 'br') {
            spans.add(const TextSpan(text: '\n'));
          }
        }
      }

      if (xmlEvent is xml.XmlTextEvent) {
        TagItem tag = TagItem();
        tag.style = style.copyWith();
        if (stack.isNotEmpty) {
          tag = stack.last;
        }
        TextSpan textSpan = _createTextSpan(xmlEvent.text, tag);
        spans.add(textSpan);
      }

      if (xmlEvent is xml.XmlEndElementEvent) {
        TagItem top = stack.removeLast();
        if (top.name != xmlEvent.name) {
          debugPrint('Error format HTML');
          continue;
        }
      }
    }

    return spans;
  }

  TextSpan _createTextSpan(String text, TagItem tag) {
    if (text.isEmpty) return const TextSpan(text: '');
    final TapGestureRecognizer recognizer = TapGestureRecognizer()
      ..onTap = () => _linkCallBack?.call(text, tag.linkUrl);
    return TextSpan(
      style: tag.style,
      text: text,
      recognizer: tag.isLink ? recognizer : null,
    );
  }

  /// 将标签 color 转为 颜色
  static Color? _generateColorByString(
    String hexColor, {
    Color defaultColor = const Color(0xffffffff),
  }) {
    Color? color = DxStyle.$0984F9;
    if (hexColor.isEmpty) return color;
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    hexColor = hexColor.replaceAll('0X', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    try {
      color = Color(int.parse(hexColor, radix: 16));
    } catch (_) {}
    return color ?? defaultColor;
  }

  /// 将标签字体转为合适的字体
  static FontWeight _generateFontWidgetByString(String fontWeight) {
    FontWeight defaultWeight = FontWeight.normal;
    switch (fontWeight) {
      case 'Bold':
        defaultWeight = FontWeight.w600;
        break;
      case 'Medium':
        defaultWeight = FontWeight.w500;
        break;
      case 'Light':
        defaultWeight = FontWeight.w300;
        break;
    }
    return defaultWeight;
  }

  /// 将标签字体大小转为合适大小的字体
  static double _generateFontSize(String size) {
    double defaultSize = 13;
    try {
      defaultSize = double.parse(size);
    } catch (_) {}
    return defaultSize;
  }
}
