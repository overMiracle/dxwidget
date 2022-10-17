import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 底部的重置+确定
class DxSelectionMoreBottomWidget extends StatelessWidget {
  final DxSelectionItem item;
  final VoidCallback? clearCallback;
  final Function(DxSelectionItem)? conformCallback;
  final DxSelectionThemeData themeData;

  const DxSelectionMoreBottomWidget({
    Key? key,
    required this.item,
    this.clearCallback,
    this.conformCallback,
    required this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DxButton(
              block: true,
              title: '重置',
              plain: true,
              square: true,
              onClick: () => clearCallback?.call(),
            ),
          ),
          Expanded(
            child: DxButton(
              block: true,
              square: true,
              title: '确定',
              onClick: () => conformCallback?.call(item),
            ),
          ),
        ],
      ),
    );
  }
}
