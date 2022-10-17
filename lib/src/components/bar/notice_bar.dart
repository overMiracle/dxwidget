import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 描述: 通知，默认最小高度36
/// 参考网址：https://bruno.ke.com/page/v2.2.0/widgets/brn-notice-bar
/// 1. 支持十种默认样式
/// 2. 支持设置或者隐藏左右图标
/// 3. 支持跑马灯
class DxNoticeBar extends StatelessWidget {
  /// 最小高度。leftWidget、rightWidget 都为空时，限制的最小高度。
  /// 可以通过该属性控制组件高度，内容会自动垂直居中。
  /// 默认值 36。
  final double minHeight;

  final EdgeInsets margin;

  /// 内容的内边距
  final EdgeInsets? padding;

  /// 背景颜色
  final Color? backgroundColor;

  /// 圆角
  final double borderRadius;

  /// 是否跑马灯
  /// 默认值false
  final bool marquee;

  /// 自定义左边的图标
  final Widget? leftWidget;

  /// 是否显示左边的图标
  final bool showLeftIcon;

  /// 通知的内容
  final String content;

  /// 内容组件
  final Widget? contentWidget;

  /// 通知的文字颜色
  final Color? textColor;

  /// 右边的图标
  final Widget? rightWidget;

  /// 是否显示右边的图标
  /// 默认值true
  final bool showRightIcon;

  /// 默认样式，取[DxNoticeStyle]里面的值
  final DxNoticeStyle? noticeStyle;

  /// 通知钮点击的回调
  final VoidCallback? onNoticeTap;

  /// 右侧图标点击的回调
  final VoidCallback? onRightIconTap;

  const DxNoticeBar({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.minHeight = 36,
    this.backgroundColor,
    this.borderRadius = 0,
    this.marquee = false,
    this.leftWidget,
    this.showLeftIcon = true,
    this.content = '',
    this.contentWidget,
    this.textColor,
    this.rightWidget,
    this.showRightIcon = true,
    this.noticeStyle,
    this.onNoticeTap,
    this.onRightIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DxNoticeStyle defaultStyle = DxNoticeStyleList.runningWithArrow;
    Widget tempRightWidget = rightWidget ?? (noticeStyle?.rightIcon ?? defaultStyle.leftIcon!);
    if (onRightIconTap != null) {
      tempRightWidget = GestureDetector(
        child: tempRightWidget,
        onTap: () => onRightIconTap!(),
      );
    }
    Widget contentSlot;

    if (contentWidget != null) {
      contentSlot = contentWidget!;
    } else {
      if (marquee) {
        contentSlot = DxMarqueeText(
          height: 36,
          text: content,
          textStyle: TextStyle(color: textColor ?? (noticeStyle?.textColor ?? defaultStyle.textColor), fontSize: 14),
        );
      } else {
        contentSlot = Text(
          content,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor ?? (noticeStyle?.textColor ?? defaultStyle.textColor),
            fontSize: 14,
          ),
        );
      }
    }

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: backgroundColor ?? (noticeStyle?.backgroundColor ?? defaultStyle.backgroundColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: GestureDetector(
        onTap: () => onNoticeTap?.call(),
        child: Row(
          children: <Widget>[
            Offstage(
              offstage: !showLeftIcon,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: leftWidget ?? (noticeStyle?.leftIcon ?? defaultStyle.leftIcon),
              ),
            ),
            Expanded(child: Transform.translate(offset: const Offset(0, -1.2), child: contentSlot)),
            Offstage(
              offstage: !showRightIcon,
              child: Padding(padding: const EdgeInsets.only(left: 8), child: tempRightWidget),
            ),
          ],
        ),
      ),
    );
  }
}

/// 默认通知样式集合，共十种
class DxNoticeStyleList {
  ///红色+失败+箭头
  static DxNoticeStyle failWithArrow = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeFail, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$FA3F3F,
    backgroundColor: DxStyle.$FEEDED,
    rightIcon: Image.asset(DxAsset.noticeArrowRed, package: 'dxwidget', scale: 3.0),
  );

  ///红色+失败+关闭
  static DxNoticeStyle failWithClose = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeFail, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$FA3F3F,
    backgroundColor: DxStyle.$FEEDED,
    rightIcon: Image.asset(DxAsset.noticeCloseRed, package: 'dxwidget', scale: 3.0),
  );

  ///蓝色+进行中+箭头
  static DxNoticeStyle runningWithArrow = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeRunning, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$0984F9,
    backgroundColor: DxStyle.$E0EDFF,
    rightIcon: Image.asset(DxAsset.noticeArrowBlue, package: 'dxwidget', scale: 3.0),
  );

  ///蓝色+进行中+关闭
  static DxNoticeStyle runningWithClose = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeRunning, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$0984F9,
    backgroundColor: DxStyle.$E0EDFF,
    rightIcon: Image.asset(DxAsset.noticeCloseBlue, package: 'dxwidget', scale: 3.0),
  );

  ///绿色+完成+箭头
  static DxNoticeStyle succeedWithArrow = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeSucceed, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$00AE66,
    backgroundColor: DxStyle.$EBFFF7,
    rightIcon: Image.asset(DxAsset.noticeArrowGreen, package: 'dxwidget', scale: 3.0),
  );

  ///绿色+完成+关闭
  static DxNoticeStyle succeedWithClose = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeSucceed, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$00AE66,
    backgroundColor: DxStyle.$EBFFF7,
    rightIcon: Image.asset(DxAsset.noticeCloseGreen, package: 'dxwidget', scale: 3.0),
  );

  ///橘色+警告+箭头
  static DxNoticeStyle warningWithArrow = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeWarning, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$FAAD14,
    backgroundColor: DxStyle.$FDFCEC,
    rightIcon: Image.asset(DxAsset.noticeArrowOrange, package: 'dxwidget', scale: 3.0),
  );

  ///橘色+警告+关闭
  static DxNoticeStyle warningWithClose = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.noticeWarning, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$FAAD14,
    backgroundColor: DxStyle.$FDFCEC,
    rightIcon: Image.asset(DxAsset.noticeCloseOrange, package: 'dxwidget', scale: 3.0),
  );

  ///橘色+通知+箭头
  static DxNoticeStyle normalNoticeWithArrow = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.notice, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$FAAD14,
    backgroundColor: DxStyle.$FDFCEC,
    rightIcon: Image.asset(DxAsset.noticeArrowOrange, package: 'dxwidget', scale: 3.0),
  );

  ///橘色+通知+关闭
  static DxNoticeStyle normalNoticeWithClose = DxNoticeStyle(
    leftIcon: Image.asset(DxAsset.notice, package: 'dxwidget', scale: 3.0),
    textColor: DxStyle.$FAAD14,
    backgroundColor: DxStyle.$FDFCEC,
    rightIcon: Image.asset(DxAsset.noticeCloseOrange, package: 'dxwidget', scale: 3.0),
  );
}

/// 通知样式
class DxNoticeStyle {
  ///左边的图标
  final Widget? leftIcon;

  ///通知的文字颜色
  final Color? textColor;

  ///背景颜色
  final Color? backgroundColor;

  ///右边的图标
  final Widget? rightIcon;

  DxNoticeStyle({
    this.leftIcon,
    this.textColor,
    this.backgroundColor,
    this.rightIcon,
  });
}
