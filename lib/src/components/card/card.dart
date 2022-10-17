import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

const SizedBox _sizedBoxShrink = SizedBox.shrink();

/// 卡片面板
class DxCard extends StatelessWidget {
  final EdgeInsets? margin;
  final Decoration? decoration;
  final double borderRadius;

  /// 内容padding，不会影响header和footer
  final EdgeInsets contentPadding;

  /// 底部padding
  final EdgeInsets footerPadding;

  /// 头部文本
  final String? headerString;

  /// 头部圆角
  final double headerBorderRadius;

  /// 卡片头部,一般使用DxListTile
  final Widget? header;

  /// 卡片底部，一般使用DxListTile
  final Widget? footer;

  /// 卡片内容
  final Widget? child;

  /// 点击事件
  final VoidCallback? onClick;

  const DxCard({
    Key? key,
    this.margin,
    this.decoration,
    this.borderRadius = 8,
    this.contentPadding = EdgeInsets.zero,
    this.footerPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    this.headerString,
    this.headerBorderRadius = 4.0,
    this.header,
    this.footer,
    this.child,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasHeader = header != null;
    bool hasFooter = footer != null;
    return GestureDetector(
      onTap: () => onClick?.call(),
      child: Container(
        width: double.infinity,
        margin: margin ?? EdgeInsets.zero,
        decoration: decoration ??
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            header ??
                (headerString != null
                    ? DxCell(
                        title: headerString!,
                        titleStyle: DxStyle.$333333$15$W500,
                        borderRadius: headerBorderRadius,
                      )
                    : _sizedBoxShrink),
            hasHeader ? const Divider(height: 0.5, color: DxStyle.$F5F5F5) : _sizedBoxShrink,
            child != null
                ? Padding(
                    padding: contentPadding,
                    child: child,
                  )
                : _sizedBoxShrink,
            hasFooter ? const Divider(height: 0.5, color: DxStyle.$F5F5F5) : _sizedBoxShrink,
            hasFooter ? Padding(padding: footerPadding, child: footer) : _sizedBoxShrink,
          ],
        ),
      ),
    );
  }
}
