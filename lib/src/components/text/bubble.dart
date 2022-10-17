import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 具备展开收起功能的气泡背景文字面板
/// 气泡：背景色为Color(0xFFF8F8F8)的灰色Container，右上角为不规则小三角
///
/// 布局规则：组件的背景是气泡背景，包装了[DxExpandableText]组件，具备了展开收起的能力
///
/// ```dart
///   DxBubbleText(
///      text: '在文本的右下角有更多或者收起按钮',
///   )
///
///   DxBubbleText(
///      text: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///   )
///
/// ```
///
class DxBubbleText extends StatelessWidget {
  /// 显示的文本
  final String text;

  ///最多显示的行数
  final int? maxLines;

  ///展开收起回调
  final Function(bool value)? onExpanded;

  /// 气泡的圆角 默认是4
  final double radius;

  /// 气泡背景色  默认是 Color(0xFFF8F8F8)
  final Color bgColor;

  /// 内容文本样式
  final TextStyle? textStyle;

  const DxBubbleText(
      {Key? key,
      this.text = '',
      this.maxLines,
      this.onExpanded,
      this.radius = 4,
      this.bgColor = const Color(0xFFF8F8F8),
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bubbleText = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset(DxAsset.rightTopPointer, package: 'dxwidget'),
        _buildExpandedWidget(),
      ],
    );
    return bubbleText;
  }

  Widget _buildExpandedWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
            ),
            child: DxExpandableText(
              text: text,
              maxLines: maxLines,
              color: bgColor,
              onExpanded: onExpanded,
              textStyle: textStyle ?? DxStyle.$222222$14$W500,
            ),
          ),
        )
      ],
    );
  }
}
