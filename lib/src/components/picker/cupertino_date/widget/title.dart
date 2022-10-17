import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

import '../../date_range/constants.dart';

/// DatePicker's title widget.
///
/// @author dylan wu
/// @since 2019-05-16
class DxCupertinoDatePickerTitleWidget extends StatelessWidget {
  const DxCupertinoDatePickerTitleWidget({
    Key? key,
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  final DateVoidCallback? onCancel, onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderCancelWidget(context),
          _renderConfirmWidget(context),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextButton(
        child: const Text('取消', style: TextStyle(color: DxStyle.gray6, fontSize: 14)),
        onPressed: () => onCancel?.call(),
      ),
    );
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextButton(
        child: Text('确定', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14)),
        onPressed: () => onConfirm?.call(),
      ),
    );
  }
}
