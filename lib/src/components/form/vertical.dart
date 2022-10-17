import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

/// 竖直排列表单项
/// 可组合title类型录入项，上下结构，自定义内容在下面，一般用于图片上传等
/// 包括"标题"、"副标题"、"必填项提示"、"消息提示"、
///
class DxVerticalFormItem extends StatefulWidget {
  /// 边框
  final BoxBorder? border;

  /// 是否必填项
  final bool isRequire;

  /// 前缀组件,比方一些图标等
  final Widget? leading;

  /// 标题
  final String title;

  /// 辅助组件，优先
  final Widget? helperWidget;

  /// 辅助图标
  final IconData? helperIcon;

  /// 辅助文本
  final String? helperString;

  /// 点击辅助图标回调
  final VoidCallback? onHelper;

  /// 下面自定义操作区
  final Widget? child;

  const DxVerticalFormItem({
    Key? key,
    this.border,
    this.isRequire = false,
    this.leading,
    this.title = '',
    this.helperWidget,
    this.helperIcon,
    this.helperString,
    this.onHelper,
    this.child,
  }) : super(key: key);

  @override
  State<DxVerticalFormItem> createState() => _DxVerticalFormItemState();
}

class _DxVerticalFormItemState extends State<DxVerticalFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 标题
              DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),
              // 辅助
              DxFormUtil.buildHelperWidget(
                  widget.helperIcon, widget.helperWidget, widget.helperString, widget.onHelper),
            ],
          ),
          const SizedBox(height: 18),
          // 自定义操作区
          Offstage(
            offstage: widget.child == null,
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
