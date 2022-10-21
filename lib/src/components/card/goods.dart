import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 商品卡片
/// 用于展示商品的图片、价格、优惠等信息
class DxGoodsCard extends StatelessWidget {
  /// 是否禁用
  final bool isDisabled;

  /// 外边距
  final EdgeInsets margin;

  /// 内边距
  final EdgeInsets? padding;

  /// 圆角
  final double borderRadius;

  /// 左侧图片
  final String? image;

  final double imageSize;

  /// 标题
  final String? title;

  /// 标题样式
  final TextStyle titleStyle;

  /// 描述
  final String? subTitle;

  /// 标题样式
  final TextStyle? subTitleStyle;

  /// 图片角标
  final String? badge;

  /// 商品数量
  final String? num;

  /// 商品价格
  final double? price;

  /// 商品划线原价
  final double? originPrice;

  /// 货币符号
  final String currency;

  /// 自定义左侧图片
  final Widget? leading;

  /// 自定义标题内容
  final Widget? titleWidget;

  /// 自定义描述
  final Widget? subTitleWidget;

  /// 自定义数量
  final Widget? numWidget;

  /// 自定义价格
  final Widget? priceWidget;

  /// 扩展组件
  final Widget? extraWidget;

  /// 自定义商品原价
  final Widget? originPriceWidget;

  /// 自定义图片角标
  final Widget? badgeWidget;

  /// 自定义描述下方标签区域
  final Widget? tagsWidget;

  /// 自定义 footer
  final Widget? footerWidget;

  final double slidablePadding;

  /// 滑动长度比例，Must be between 0 (excluded) and 1.
  final double slidableExtentRatio;

  /// 滑动事件
  final List<DxSlidableAction>? slidableActionList;

  /// 点击时触发
  final VoidCallback? onClick;

  final Widget _sizedBoxShrink = const SizedBox.shrink();

  const DxGoodsCard({
    Key? key,
    this.isDisabled = false,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.borderRadius = 0,
    this.image,
    this.imageSize = DxStyle.cardThumbSize,
    this.title,
    this.titleStyle = DxStyle.$404040$15$W500,
    this.subTitle,
    this.subTitleStyle = const TextStyle(fontSize: DxStyle.cardFontSize, color: DxStyle.cardDescColor),
    this.badge,
    this.num,
    this.price,
    this.originPrice,
    this.currency = '¥',
    this.leading,
    this.titleWidget,
    this.subTitleWidget,
    this.badgeWidget,
    this.tagsWidget,
    this.priceWidget,
    this.originPriceWidget,
    this.numWidget,
    this.extraWidget,
    this.footerWidget,
    this.slidablePadding = 0,
    this.slidableActionList,
    this.slidableExtentRatio = 0.5,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isDisabled ? null : onClick?.call(),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (slidableActionList == null) return _buildWithoutSlidableActionContent();
    return DxSlidable(
      groupTag: '0',
      padding: slidablePadding,
      endActionPane: DxActionPane(
        extentRatio: slidableExtentRatio,
        motion: const DxScrollMotion(),
        children: slidableActionList!,
      ),
      child: _buildWithoutSlidableActionContent(),
    );
  }

  Widget _buildWithoutSlidableActionContent() {
    Widget $widget = Container(
      margin: margin,
      padding: padding ?? DxStyle.cardPadding,
      decoration: BoxDecoration(
        color: DxStyle.cardBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildThumb(),
              const SizedBox(width: DxStyle.intervalLg),
              _buildRightContent(),
            ],
          ),
          footerWidget ?? _sizedBoxShrink,
        ],
      ),
    );
    return isDisabled ? Opacity(opacity: 0.5, child: $widget) : $widget;
  }

  /// 左侧图片
  Widget _buildThumb() {
    return Stack(
      children: <Widget>[
        leading ?? DxImage(src: image, width: imageSize, height: imageSize, fit: BoxFit.fill, radius: 5),
        badgeWidget ??
            (badge != null
                ? Positioned(left: 0, top: 0, child: DxTag.danger(mark: true, text: badge!))
                : _sizedBoxShrink)
      ],
    );
  }

  /// 右侧内容
  Widget _buildRightContent() {
    bool hasPrice = priceWidget != null || price != null;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleWidget ?? Text(title ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: titleStyle),
          const SizedBox(height: DxStyle.intervalSm),
          subTitleWidget ??
              (subTitle != null
                  ? Text(subTitle!, maxLines: 1, overflow: TextOverflow.ellipsis, style: subTitleStyle)
                  : _sizedBoxShrink),
          const SizedBox(height: DxStyle.intervalMd),
          tagsWidget != null
              ? Padding(padding: const EdgeInsets.only(bottom: DxStyle.intervalMd), child: tagsWidget)
              : _sizedBoxShrink,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  priceWidget ?? (hasPrice ? DxPrice(value: price, currency: currency) : _sizedBoxShrink),
                  originPriceWidget ??
                      (originPrice != null
                          ? Text("/$currency${DxTools.removeZero(originPrice!.toStringAsFixed(2))}",
                              style: const TextStyle(
                                  color: DxStyle.cardOriginPriceColor,
                                  fontSize: DxStyle.cardOriginPriceFontSize,
                                  decoration: TextDecoration.lineThrough))
                          : _sizedBoxShrink)
                ],
              ),
              numWidget ??
                  (num != null
                      ? Text(
                          "x$num",
                          style: const TextStyle(fontSize: DxStyle.cardFontSize, color: DxStyle.cardNumColor),
                        )
                      : _sizedBoxShrink),
            ],
          ),
          extraWidget != null
              ? Padding(padding: const EdgeInsets.only(top: DxStyle.intervalMd), child: extraWidget)
              : _sizedBoxShrink,
        ],
      ),
    );
  }
}
