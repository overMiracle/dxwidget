import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 具备展开收起功能的文字面板
///
/// 布局规则：
///     在文本的右下角有更多或者收起按钮
///     当文本超过指定的[maxLines]时，剩余文本隐藏
///     点击更多，则显示全部文本
///
/// ```dart
///   DxExpandableText(
///      text: '在文本的右下角有更多或者收起按钮',
///   )
///
///   DxExpandableText(
///      text: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///      onExpanded: (value) {
///      },
///   )
///
///
/// ```
///
class DxExpandableText extends StatefulWidget {
  ///显示的文本
  final String text;

  ///显示的最多行数
  final int? maxLines;

  /// 文本的样式
  final TextStyle? textStyle;

  /// 展开或者收起的时候的回调
  final Function(bool value)? onExpanded;

  /// 更多按钮渐变色的初始色 默认白色
  final Color? color;

  const DxExpandableText({
    Key? key,
    required this.text,
    this.maxLines = 1000000,
    this.textStyle,
    this.onExpanded,
    this.color,
  }) : super(key: key);

  @override
  State<DxExpandableText> createState() => _DxExpandableTextState();
}

class _DxExpandableTextState extends State<DxExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = _defaultTextStyle();
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: style);
        final tp = TextPainter(
            text: span, maxLines: widget.maxLines, textDirection: TextDirection.ltr, ellipsis: 'EllipseText');
        tp.layout(maxWidth: size.maxWidth);
        if (tp.didExceedMaxLines) {
          if (_expanded) {
            return _expandedText(context, widget.text);
          } else {
            return _foldedText(context, widget.text);
          }
        } else {
          return Text(widget.text, style: style);
        }
      },
    );
  }

  Widget _foldedText(context, String text) {
    return Stack(
      children: <Widget>[
        Text(
          widget.text,
          style: _defaultTextStyle(),
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _clickExpandTextWidget(context),
        )
      ],
    );
  }

  Widget _clickExpandTextWidget(context) {
    Color btnColor = widget.color ?? Colors.white;

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(left: 22),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [btnColor.withAlpha(100), btnColor, btnColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: const Text('更多', style: DxStyle.$0984F9$14),
      ),
      onTap: () {
        setState(() {
          _expanded = true;
          widget.onExpanded?.call(_expanded);
        });
      },
    );
  }

  Widget _expandedText(context, String text) {
    return RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(text: text, style: _defaultTextStyle(), children: [
          _foldButtonSpan(context),
        ]));
  }

  TextStyle _defaultTextStyle() {
    TextStyle style = widget.textStyle ?? DxStyle.$222222$14$W500;
    return style;
  }

  InlineSpan _foldButtonSpan(context) {
    return TextSpan(
      text: ' 收起',
      style: DxStyle.$0984F9$14,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          setState(() {
            _expanded = false;
            widget.onExpanded?.call(_expanded);
          });
        },
    );
  }
}
