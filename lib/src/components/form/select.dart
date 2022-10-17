import 'package:dxwidget/src/components/text/auto_size.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

///
/// 选择型表单项
/// 包括"标题"、"副标题"、"必填项提示"
/// 点击右侧文本显示区域后触发 onTap 回调函数，用户可在此回调函数中执行启动弹框，跳转页面等操作
///
class DxSelectFormItem extends StatefulWidget {
  /// 边框
  final BoxBorder? border;

  /// 是否必填
  final bool isRequire;

  /// 前缀组件,比方一些图标等
  final Widget? leading;

  /// 标题
  final String title;

  /// 辅助
  final IconData? helperIcon;
  final Widget? helperWidget;
  final String helperString;

  /// 点击辅助图标回调
  final VoidCallback? onHelper;

  /// 点击录入区回调
  final VoidCallback? onTap;

  /// 录入项 hint 提示
  final String hint;

  /// 录入项 值
  final String? value;

  /// 选中文本最大行数
  final int maxLines;

  /// title最大行数
  final int? titleMaxLines;

  const DxSelectFormItem({
    Key? key,
    this.border,
    this.isRequire = false,
    this.leading,
    this.title = '',
    this.helperIcon,
    this.helperWidget,
    this.helperString = '',
    this.onHelper,
    this.hint = '请选择',
    this.value,
    this.maxLines = 3,
    this.titleMaxLines,
    this.onTap,
  }) : super(key: key);

  @override
  State<DxSelectFormItem> createState() => _DxSelectFormItemState();
}

class _DxSelectFormItemState extends State<DxSelectFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      // 右边距应该是20，但是箭头图标貌似有点占用空间，所以选择18
      padding: const EdgeInsets.only(left: 20, right: 18),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Row(
        children: <Widget>[
          DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),
          DxFormUtil.buildHelperWidget(widget.helperIcon, widget.helperWidget, widget.helperString, widget.onHelper),
          // 文案选择区
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: _buildRightWidget(),
            ),
          ),
        ],
      ),
    );
  }

  // 右侧区域
  Widget _buildRightWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(child: buildText()),
            DxFormUtil.buildRightArrowWidget(),
          ],
        ),
      ),
      onTap: () => widget.onTap?.call(),
    );
  }

  Widget buildText() {
    if (widget.value != null && widget.value!.isNotEmpty) {
      return DxAutoSizeText(
        widget.value!,
        style: DxStyle.$404040$15,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        maxLines: widget.maxLines,
      );
    } else {
      return Text(widget.hint, textAlign: TextAlign.end, style: DxStyle.$CCCCCC$14.copyWith(height: 1.2));
    }
  }
}
