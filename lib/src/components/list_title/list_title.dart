import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 边框位置
enum DxListTileBorderPosition {
  none,
  top,
  bottom,
}

/// 因为DxListTile有可能需要嵌套到DxCard中，DxCard有borderRadius了，所有这里设置默认的borderRadius = 0
class DxListTile extends StatelessWidget {
  /// 外层的container装饰
  final Decoration? decoration;

  ///banner装饰器
  final DxCornerDecoration? cornerDecoration;

  /// 圆角
  final double borderRadius;

  /// defines the margin of DxListTile
  final EdgeInsets margin;

  /// defines the padding of DxListTile
  final EdgeInsets padding;

  /// 边框位置
  final DxListTileBorderPosition borderPosition;

  /// type of [String] used to pass text, alternative to title property and gets higher priority than title
  final String title;

  /// type of [String] used to pass text, alternative to subTitle property and gets higher priority than subTitle
  final String subTitle;

  /// The DxListTile's background color. Can be given [Color] or [DxColors]
  final Color? color;

  /// type of [Widget] or [DxAvatar] used to create rounded user profile
  final Widget? leading;

  /// The title to display inside the [DxListTile]. see [Text]
  final Widget? titleWidget;

  /// The subTitle to display inside the [DxListTile]. see [Text]
  final Widget? subTitleWidget;

  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  /// leading和title之间的距离，默认10
  final double horizontalTitleGap;

  /// title 和 subTitle之间的间距，默认4
  final double minVerticalPadding;

  /// The description to display inside the [DxListTile]. see [Text]
  final Widget? description;

  /// The icon to display inside the [DxListTile]. see [Icon]
  final Widget? trailing;

  /// 右侧箭头
  final bool trailingLink;

  /// 右侧箭头大小,默认14
  final double trailingLinkSize;

  /// 右侧箭头颜色
  final Color trailingLinkColor;

  /// 纵轴方向是否居中对齐
  final bool isCenter;

  final double slidablePadding;

  /// 滑动长度比例，Must be between 0 (excluded) and 1.
  final double slidableExtentRatio;

  /// 滑动事件
  final List<DxSlidableAction>? slidableActionList;

  /// Called when the user taps this list tile.
  final VoidCallback? onClick;

  final Widget _sizedBoxShrink = const SizedBox.shrink();

  /// Creates ListTile with leading, title, trailing, image widget for almost every type of ListTile design.
  const DxListTile({
    Key? key,
    this.decoration,
    this.cornerDecoration,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 4.0,
    this.borderPosition = DxListTileBorderPosition.none,
    this.color,
    this.leading,
    this.title = '',
    this.subTitle = '',
    this.titleWidget,
    this.subTitleWidget,
    this.titleStyle = DxStyle.$404040$15$W500,
    this.subTitleStyle = DxStyle.$GRAY6$12,
    this.horizontalTitleGap = 10,
    this.minVerticalPadding = 4,
    this.description,
    this.trailing,
    this.trailingLink = false,
    this.trailingLinkSize = 14,
    this.trailingLinkColor = DxStyle.gray6,
    this.isCenter = true,
    this.slidablePadding = 0,
    this.slidableActionList,
    this.slidableExtentRatio = 0.5,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onClick?.call(),
        child: _buildContent(),
      );

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
    bool hasSubTile = subTitleWidget != null || title != '';

    /// 为了避免没有边框的时候borderRadius报错，可以用 ClipRRect 组件嵌套在 Container 盒子外层
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: padding,
        margin: margin,
        alignment: Alignment.center,
        decoration: decoration ??
            BoxDecoration(
              color: color ?? Colors.white,
              border: Border(
                top: borderPosition == DxListTileBorderPosition.top
                    ? const BorderSide(color: DxStyle.$F5F5F5, width: 0.5)
                    : BorderSide.none,
                bottom: borderPosition == DxListTileBorderPosition.bottom
                    ? const BorderSide(color: DxStyle.$F5F5F5, width: 0.5)
                    : BorderSide.none,
              ),
            ),
        foregroundDecoration: cornerDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            leading != null
                ? Padding(padding: EdgeInsets.only(right: horizontalTitleGap), child: leading)
                : _sizedBoxShrink,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleWidget ?? (title != '' ? Text(title, style: titleStyle) : _sizedBoxShrink),
                  hasSubTile ? SizedBox(height: minVerticalPadding) : _sizedBoxShrink,
                  subTitleWidget ?? (subTitle != '' ? Text(subTitle, style: subTitleStyle) : _sizedBoxShrink),
                  description ?? _sizedBoxShrink
                ],
              ),
            ),
            trailing ?? _sizedBoxShrink,
            trailingLink
                ? Padding(
                    padding: const EdgeInsets.only(left: 5, top: 2),
                    child: Icon(Icons.arrow_forward_ios, size: trailingLinkSize, color: trailingLinkColor),
                  )
                : _sizedBoxShrink,
          ],
        ),
      ),
    );
  }
}
