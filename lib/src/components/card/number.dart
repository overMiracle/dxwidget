import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

///可扩展
enum DxNumberIcon { arrow, question }

/// 强化数字展示的组件
///
/// 使用场景：强化数字、字母部分。比如 成交量\30\. 其中30是重点展示的信息，字体是特殊的字体。
/// 该组件会将上述的单个组件，以流式的方式 流下来。
///
/// 该组件可以通过[rowCount]属性来控制，每一行具体的显示几个。
///
/// 该组件需要配合[DxNumberInfoItemModel]使用，DxNumberInfoItemModel是每个元素的单独模型。
///
/// 布局规则
///     1：每一行展示指定个数的Item，其中多余指定个数 则换行。
///        如果行中Item的个数多于一个 则平分屏幕
///     2：item的左右间距是[leftPadding][rightPadding]，默认是20。
///       行与行之间的间距是[runningSpace],默认是16
///     3：item的上下两部分的间距是[itemRunningSpace],默认是8。
///     4：在强化的数字信息前后分别可以设置 辅助信息
///
///
/// DxNumberCard(
///     rowCount: 2,
///     children: [
///         DxNumberItem(
///            title: '数字信息数字信息数字信息数字信息数字信息数字信息',
///            number: '3',
///            preDesc: '前',
///            lastDesc: '后',
///         ),
///         DxNumberItem(
///            title: '数字信息',
///            number: '3',
///            preDesc: '前',
///            lastDesc: '后',
///            iconTapCallBack: (data) {}),
///         DxNumberItem(
///            title: '数字信息',
///            number: '3',
///            preDesc: '前',
///            lastDesc: '后',
///         ),
///         DxNumberItem(
///            title: '数字信息',
///            number: '3',
///            preDesc: '前',
///            lastDesc: '后',
///         ),
///    ],
///),
///
///
class DxNumberCard extends StatelessWidget {
  /// 外边距,默认0
  final EdgeInsets margin;

  ///左侧的间距 默认20
  final EdgeInsets padding;

  /// 装饰
  final Decoration? decoration;

  /// 渐变色，优先级高于背景颜色
  final Gradient? gradient;

  ///背景色 默认为白色
  final Color backgroundColor;

  /// 边框
  final BoxBorder? border;

  /// 圆角
  final double borderRadius;

  ///如果超过一行，行间距则 默认为16
  final double? runningSpace;

  ///Item的上半部分和下半部分的间距 默认为8
  final double? itemRunningSpace;

  ///每一行显示的数量 默认为3
  final int rowCount;

  /// 单元对其方式
  final TextAlign itemTextAlign;

  /// 数字大小
  final double? itemNumberSize;

  /// 数字演示
  final Color? itemNumberColor;

  /// 描述文本样式
  final TextStyle? itemTitleStyle;

  /// 分割线颜色
  final Color dividerColor;

  /// 数字与描述之间的横向距离
  final double numberAndDescMargin;

  final List<DxNumberItem>? children;

  const DxNumberCard({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.decoration,
    this.gradient,
    this.backgroundColor = Colors.white,
    this.border,
    this.borderRadius = 8.0,
    this.rowCount = 3,
    this.runningSpace,
    this.itemRunningSpace,
    this.itemTextAlign = TextAlign.center,
    this.itemNumberSize = 22,
    this.itemNumberColor = Colors.white,
    this.itemTitleStyle,
    this.dividerColor = Colors.white24,
    this.numberAndDescMargin = 2.0,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (children == null || children!.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget contentWidget = const SizedBox.shrink();
        // 容错显示的行数 显示三行
        int count = rowCount;
        if (rowCount <= 0 || rowCount > children!.length) {
          count = 3;
        }
        double width = constraints.maxWidth;
        double singleWidth = (width - padding.left - padding.right) / count;

        if (children!.length > 1) {
          // 平铺下来
          contentWidget = Wrap(
            runSpacing: runningSpace ?? 16.0,
            spacing: 0.0,
            children: children!.map((data) {
              //每行的最后一个  不显示分割线
              //最后一个元素 不显示分割线
              bool condition1 = (children!.indexOf(data) + 1) % count == 0;
              bool condition2 = children!.last == data;
              bool allCondition = condition1 || condition2;

              bool isFirst = (children!.indexOf(data) + 1) % count == 1;
              return SizedBox(
                width: singleWidth,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // 每行的第一个 的左边距是0，使用的是leftPadding的功能
                    // 每行的最后一个的右边距，使用的是rightPadding的功能
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: isFirst ? 0 : 10, right: condition1 ? 0 : 10),
                        child: _buildItemWidget(data, width: singleWidth),
                      ),
                    ),
                    //分割线的显示规则是：固定高度47，item之间显示，最后一个不显示
                    Visibility(
                      visible: !allCondition,
                      child: Container(height: 47, width: 0.5, color: dividerColor),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          contentWidget = _buildItemWidget(children![0]);
        }

        return Container(
          margin: margin,
          padding: padding,
          decoration: decoration ??
              BoxDecoration(
                color: backgroundColor,
                gradient: gradient,
                borderRadius: BorderRadius.circular(borderRadius),
                border: border,
              ),
          child: contentWidget,
        );
      },
    );
  }

  Widget _buildItemWidget(DxNumberItem item, {double? width}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildTopWidget(item, width: width),
        SizedBox(height: itemRunningSpace),
        _buildBottomWidget(item, width: width)
      ],
    );
  }

  Widget _buildTopWidget(DxNumberItem item, {double? width}) {
    if (item.topWidget != null) {
      return item.topWidget!;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        _getPreWidget(item),
        Transform.translate(
          offset: const Offset(0, 1.5),
          child: Text(
            item.number!,
            style: TextStyle(
              height: 1.0,
              overflow: TextOverflow.ellipsis,
              textBaseline: TextBaseline.ideographic,
              color: itemNumberColor ?? item.numberColor,
              fontWeight: FontWeight.w500,
              fontSize: itemNumberSize ?? item.numberSize,
            ),
          ),
        ),
        _getLastWidget(item),
      ],
    );
  }

  Widget _buildBottomWidget(DxNumberItem item, {double? width}) {
    if (item.bottomWidget != null) {
      return item.bottomWidget!;
    }
    TextSpan span = TextSpan(text: item.title ?? "", style: DxStyle.$999999$12);
    TextPainter tp = TextPainter(
      text: span,
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: width ?? double.infinity);
    Widget text = Text(
      item.title ?? '',
      textAlign: itemTextAlign,
      maxLines: 2,
      style: itemTitleStyle ?? DxStyle.$999999$12,
      overflow: TextOverflow.ellipsis,
    );
    if (item.iconTapCallBack != null) {
      Widget icon = Image.asset(DxAsset.question, package: 'dxwidget', width: 14, height: 14);

      if (item.numberIcon == DxNumberIcon.arrow) {
        icon = Image.asset(DxAsset.arrowRight, package: 'dxwidget', width: 14, height: 14);
      }
      text = Row(
        mainAxisAlignment: itemTextAlign == TextAlign.center
            ? MainAxisAlignment.center
            : (itemTextAlign == TextAlign.right ? MainAxisAlignment.end : MainAxisAlignment.start),
        crossAxisAlignment: tp.height > 22 ? CrossAxisAlignment.end : CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(child: text),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => item.iconTapCallBack!(item),
            child: icon,
          )
        ],
      );
    }
    return text;
  }

  Widget _getPreWidget(DxNumberItem item) {
    if (item.preDesc == null || item.preDesc!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(left: numberAndDescMargin),
      child: Text(
        item.preDesc!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(textBaseline: TextBaseline.ideographic, color: item.descColor, fontSize: item.descSize),
      ),
    );
  }

  Widget _getLastWidget(DxNumberItem item) {
    if (item.lastDesc == null || item.lastDesc!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(left: numberAndDescMargin),
      child: Text(
        item.lastDesc!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: item.descColor, fontSize: item.descSize),
      ),
    );
  }
}

/// 用来显示强化数据的条目
class DxNumberItem {
  /// number必须是非中文，否则会展示异常，如果有中文信息 则设置pre和last字段
  final String? number;
  final double numberSize;
  final Color numberColor;

  ///下半部分的辅助信息
  final String? title;

  ///强化信息的前面展示字段
  final String? preDesc;

  ///强化信息的后面展示字段
  final String? lastDesc;

  final double descSize;
  final Color descColor;

  ///icon的事件
  final Function(DxNumberItem)? iconTapCallBack;

  ///icon的样式 可枚举 , 默认为问号
  final DxNumberIcon numberIcon;

  ///上半部分的自定义内容 如果设置了优先级则高于 number、preDesc和lastDesc
  final Widget? topWidget;

  ///下半部分的自定义内容 如果设置了优先级则高于 title
  final Widget? bottomWidget;

  ///上部分的：（number、preDesc、lastDesc）和topWidget 必须设置一个
  ///下部分的：title和title 必须设置一个
  DxNumberItem({
    this.number,
    this.numberSize = 28,
    this.numberColor = Colors.white,
    this.title,
    this.numberIcon = DxNumberIcon.question,
    this.iconTapCallBack,
    this.preDesc,
    this.lastDesc,
    this.descSize = 12,
    this.descColor = Colors.white70,
    this.bottomWidget,
    this.topWidget,
  });
}
