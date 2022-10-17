import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 提交订单栏
/// 用于展示订单金额与提交订单
class DxSubmitBar extends StatelessWidget {
  /// 价格（单位分）
  final int? price;

  /// 价格小数点位数
  final int decimalLength;

  /// 价格左侧文案
  final String label;

  /// 价格右侧文案
  final String? suffixLabel;

  /// 价格文案对齐方向，可选值为 `left` `right`
  final TextAlign textAlign;

  /// 按钮文字
  final String buttonText;

  /// 按钮类型
  final DxButtonType buttonType;

  /// 自定义按钮颜色
  final Color? buttonColor;

  /// 在订单栏上方的提示文案
  final String tip;

  /// 提示文案左侧的图标名称
  final IconData? tipIconName;

  /// 提示文案左侧的图标链接
  final String? tipIconUrl;

  /// 货币符号
  final String currency;

  /// 是否禁用按钮
  final bool disabled;

  /// 是否显示将按钮显示为加载中状态
  final bool loading;

  /// 是否开启底部安全区适配
  final bool safeAreaInsetBottom;

  /// 按钮点击事件回调
  final VoidCallback? onSubmit;

  /// 自定义订单栏左侧内容
  final Widget? child;

  /// 自定义按钮
  final Widget? buttonSlot;

  /// 自定义订单栏上方内容
  final Widget? topSlot;

  /// 提示文案中的额外内容
  final InlineSpan? tipSlot;

  const DxSubmitBar({
    Key? key,
    this.price,
    this.decimalLength = 2,
    this.label = '',
    this.suffixLabel,
    this.textAlign = TextAlign.right,
    this.buttonText = '',
    this.buttonType = DxButtonType.danger,
    this.buttonColor,
    this.tip = '',
    this.tipIconName,
    this.tipIconUrl,
    this.currency = '¥',
    this.disabled = false,
    this.loading = false,
    this.safeAreaInsetBottom = false,
    this.child,
    this.onSubmit,
    this.buttonSlot,
    this.topSlot,
    this.tipSlot,
  })  : assert(decimalLength >= 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxSubmitBarThemeData themeData = DxSubmitBarTheme.of(context);

    return Container(
      color: themeData.backgroundColor,
      child: SafeArea(
        bottom: safeAreaInsetBottom,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            topSlot ?? const SizedBox.shrink(),
            _buildTip(themeData),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: themeData.textFontSize,
              ),
              child: Container(
                height: themeData.height,
                padding: themeData.padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    child ?? const SizedBox.shrink(),
                    _buildText(context, themeData),
                    _buildButton(themeData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(DxSubmitBarThemeData themeData) {
    if (tipSlot != null || tip.isNotEmpty) {
      return Container(
        width: double.infinity,
        color: themeData.tipBackgroundColor,
        padding: themeData.tipPadding,
        child: DefaultTextStyle(
          style: TextStyle(
            color: themeData.tipColor,
            fontSize: themeData.tipFontSize,
            height: themeData.tipLineHeight,
          ),
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                if (tipIconName != null || tipIconUrl != null)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: themeData.tipIconSize * 1.5,
                      ),
                      child: DxIcon(
                        iconName: tipIconName,
                        size: themeData.tipIconSize,
                        color: themeData.tipColor,
                      ),
                    ),
                  ),
                TextSpan(text: tip),
                tipSlot ?? const TextSpan(),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildButton(DxSubmitBarThemeData themeData) {
    if (buttonSlot != null) {
      return buttonSlot!;
    }

    return SizedBox(
      width: themeData.buttonWidth,
      height: themeData.buttonHeight,
      child: DxButton(
        round: true,
        type: buttonType,
        color: buttonColor,
        loading: loading,
        disabled: disabled,
        gradient: buttonType == DxButtonType.danger ? DxStyle.gradientRed : null,
        onClick: () => onSubmit?.call(),
        child: Text(
          buttonText,
          style: const TextStyle(fontWeight: DxStyle.fontWeightBold),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, DxSubmitBarThemeData themeData) {
    if (price != null) {
      final List<String> pricePair = (price! / 100).toStringAsFixed(decimalLength).split('.');
      final String decimal = decimalLength > 0 ? '.${pricePair[1]}' : '';

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: DxStyle.paddingSm),
          child: Text.rich(
            TextSpan(
              text: label.isNotEmpty ? label : '合计：',
              style: TextStyle(color: themeData.textColor),
              children: <InlineSpan>[
                TextSpan(
                  style: TextStyle(
                    color: themeData.priceColor,
                    fontWeight: DxStyle.fontWeightBold,
                    fontSize: themeData.priceFontSize,
                  ),
                  children: <InlineSpan>[
                    TextSpan(text: currency),
                    TextSpan(
                      text: pricePair[0],
                      style: TextStyle(fontSize: themeData.priceIntegerFontSize),
                    ),
                    TextSpan(text: decimal),
                  ],
                ),
                TextSpan(text: suffixLabel),
              ],
            ),
            textAlign: textAlign,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
