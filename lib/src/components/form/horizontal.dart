import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

/// 横向表单单元格
/// 文本输入型录入项
/// 包括"标题"、"副标题"、"必填项提示"\"文本输入框"等元素
///
class DxHorizontalFormItem extends StatefulWidget {
  /// 边框
  final BoxBorder? border;

  /// 录入项是否为必填项（展示*图标） 默认为 false 不必填
  final bool isRequire;

  /// 前缀组件,比方一些图标等
  final Widget? leading;

  /// 录入项标题
  final String title;

  /// 辅助组件
  final Widget? helperWidget;

  /// 辅助图标
  final IconData? helperIcon;

  /// 辅助文本
  final String? helperString;

  /// 点击辅助图标回调
  final VoidCallback? onHelper;

  /// 右侧操作widget
  final Widget? child;

  const DxHorizontalFormItem({
    Key? key,
    this.border,
    this.isRequire = false,
    this.leading,
    this.title = '',
    this.helperIcon,
    this.helperWidget,
    this.helperString = '',
    this.onHelper,
    this.child,
  }) : super(key: key);

  @override
  State<DxHorizontalFormItem> createState() => _DxHorizontalFormItemState();
}

class _DxHorizontalFormItemState extends State<DxHorizontalFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// 标题
          DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),

          /// 辅助系列
          DxFormUtil.buildHelperWidget(widget.helperIcon, widget.helperWidget, widget.helperString, widget.onHelper),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: widget.child ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
