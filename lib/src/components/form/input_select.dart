import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 右侧两部分组成，右侧其中左边是输入框，右侧是选择框
// ignore: must_be_immutable
class DxInputSelectFormItem extends StatefulWidget {
  /// 录入项 是否可编辑
  final bool isEdit;

  /// 边框
  final BoxBorder? border;

  /// 录入项是否为必填项（展示*图标） 默认为 false 不必填
  final bool isRequire;

  /// 前缀组件,比方一些图标等
  final Widget? leading;

  /// 录入项标题
  final String title;

  /// 辅助
  final IconData? helperIcon;
  final Widget? helperWidget;
  final String helperString;

  /// 点击辅助图标回调
  final VoidCallback? onHelper;

  /// 输入框提示语
  final String inputHit;
  final String selectHit;

  /// 输入内容类型，参见[BrnInputType]
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;

  /// 右侧选择框 值
  final String? selectValue;

  final TextEditingController? inputController;
  final ValueChanged<String>? onInputChanged;
  final ValueChanged<String>? onSelectChanged;
  final VoidCallback? onSelectTap;

  const DxInputSelectFormItem({
    Key? key,
    this.isEdit = true,
    this.border,
    this.isRequire = false,
    this.leading,
    this.title = '',
    this.helperIcon,
    this.helperWidget,
    this.helperString = '',
    this.onHelper,
    this.inputHit = '请输入',
    this.selectHit = '请选择',
    this.selectValue,
    this.inputController,
    this.onInputChanged,
    this.onSelectChanged,
    this.inputType,
    this.inputFormatters,
    this.onSelectTap,
  }) : super(key: key);

  @override
  State<DxInputSelectFormItem> createState() => _DxInputSelectFormItemState();
}

class _DxInputSelectFormItemState extends State<DxInputSelectFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      // 右边距应该是20，但是箭头图标貌似有点占用空间，所以选择18
      padding: const EdgeInsets.only(left: 20, right: 18),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),
          DxFormUtil.buildHelperWidget(widget.helperIcon, widget.helperWidget, widget.helperString, widget.onHelper),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    enabled: widget.isEdit,
                    maxLines: 1,
                    keyboardType: widget.inputType,
                    style: DxStyle.$404040$15,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintStyle: DxStyle.$CCCCCC$14,
                      hintText: widget.inputHit,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    textAlign: TextAlign.end,
                    controller: widget.inputController,
                    onChanged: (text) => widget.onInputChanged?.call(text),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('𐌗', style: TextStyle(color: Color(0xFF101010), fontSize: 14, height: 1.5)),
                ),
                _buildRightWidget(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 右侧区域
  Widget _buildRightWidget(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: SizedBox(
          height: 54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              buildRightText(),
              DxFormUtil.buildRightArrowWidget(),
            ],
          ),
        ),
      ),
      onTap: () => widget.onSelectTap?.call(),
    );
  }

  Widget buildRightText() {
    if (widget.selectValue != null && widget.selectValue!.isNotEmpty) {
      return Text(
        widget.selectValue!,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.end,
        style: DxStyle.$404040$15.copyWith(height: 1.2),
      );
    } else {
      return Text(widget.selectHit, textAlign: TextAlign.end, style: DxStyle.$CCCCCC$14.copyWith(height: 1.2));
    }
  }
}
