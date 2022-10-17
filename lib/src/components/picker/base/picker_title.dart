import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// DatePicker's title widget.
// ignore: must_be_immutable
class DxPickerTitle extends StatelessWidget {
  final DxPickerTitleConfig pickerTitleConfig;
  final DateVoidCallback onCancel, onConfirm;
  final DxPickerThemeData? themeData;

  const DxPickerTitle({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context).merge(this.themeData);
    if (pickerTitleConfig.title != null) {
      return pickerTitleConfig.title!;
    }
    return Container(
      height: themeData.titleHeight,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: themeData.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(themeData.cornerRadius),
            topRight: Radius.circular(themeData.cornerRadius),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: themeData.titleHeight - 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: _renderCancelWidget(context, themeData),
                  onTap: () => onCancel(),
                ),
                Text(pickerTitleConfig.titleText, style: themeData.titleTextStyle),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: _renderConfirmWidget(context, themeData),
                  onTap: () => onConfirm(),
                ),
              ],
            ),
          ),
          Divider(color: themeData.dividerColor, indent: 0.0, height: 0.5),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context, DxPickerThemeData themeData) {
    Widget? cancelWidget = pickerTitleConfig.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = themeData.cancelTextStyle;
      cancelWidget = Text('取消', style: textStyle, textAlign: TextAlign.left);
    }

    /// 这里为了增大点击面积
    return Container(
      constraints: BoxConstraints(minWidth: themeData.titleHeight),
      padding: const EdgeInsets.only(left: 20),
      height: themeData.titleHeight,
      alignment: Alignment.centerLeft,
      child: cancelWidget,
    );
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context, DxPickerThemeData themeData) {
    Widget? confirmWidget = pickerTitleConfig.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = themeData.confirmTextStyle;
      confirmWidget = Text('确定', style: textStyle, textAlign: TextAlign.right);
    }

    /// 这里为了增大点击面积
    return Container(
      constraints: BoxConstraints(minWidth: themeData.titleHeight),
      padding: const EdgeInsets.only(right: 20),
      height: themeData.titleHeight,
      alignment: Alignment.centerRight,
      child: confirmWidget,
    );
  }
}
