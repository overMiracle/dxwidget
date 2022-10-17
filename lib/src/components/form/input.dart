import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// 文本输入型录入项
/// 包括"标题"、"副标题"、"必填项提示"\"文本输入框"等元素
///
class DxInputFormItem extends StatefulWidget {
  /// 录入项 是否可编辑
  final bool isEdit;

  /// 边框
  final BoxBorder? border;

  /// 录入项是否为必填项（展示*图标） 默认为 false 不必填
  final bool isRequire;

  /// 前缀组件,比方一些图标等,如果使用了页面中的表单必须统一大小，否则排版出现问题，必填和前缀组件不能同时出现
  final Widget? leading;

  /// 录入项标题
  final String title;

  /// 辅助
  final IconData? helperIcon;
  final Widget? helperWidget;
  final String helperString;

  /// 点击辅助图标回调
  final VoidCallback? onHelper;

  /// 提示文案
  final String hint;

  /// 单位
  final String unit;

  /// 单位
  final Widget? unitWidget;

  /// 输入内容类型
  final TextInputType? inputType;

  /// 表单和后面的自定义unitWidget整体点击事件，如果需要表单不能输入只能通过赋值，就把属性isEdit设置为false
  final VoidCallback? wholeClick;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 最大可输入字符数
  final int? maxCharCount;
  final List<TextInputFormatter>? inputFormatters;

  /// 输入变化回调
  final ValueChanged<String>? onChanged;

  final TextEditingController? controller;

  const DxInputFormItem({
    Key? key,
    this.autofocus = false,
    this.border,
    this.isEdit = true,
    this.isRequire = false,
    this.leading,
    this.title = '',
    this.helperIcon,
    this.helperWidget,
    this.helperString = '',
    this.onHelper,
    this.hint = '请输入',
    this.unit = '',
    this.unitWidget,
    this.maxCharCount,
    this.inputType,
    this.wholeClick,
    this.inputFormatters,
    this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  State<DxInputFormItem> createState() => _MyInputFormItemState();
}

class _MyInputFormItemState extends State<DxInputFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, border: widget.border ?? DxBorder.$F5F5F5$BOTTOM),
      child: Row(
        children: <Widget>[
          DxFormUtil.buildTitleWidget(widget.isRequire, widget.leading, widget.title),
          DxFormUtil.buildHelperWidget(widget.helperIcon, widget.helperWidget, widget.helperString, widget.onHelper),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.wholeClick?.call(),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: widget.autofocus,
                      keyboardType: widget.inputType,
                      enabled: widget.isEdit,
                      maxLines: 1,
                      maxLength: widget.maxCharCount,
                      style: DxStyle.$404040$15,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintStyle: DxStyle.$CCCCCC$14,
                        hintText: widget.hint,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      textAlign: TextAlign.end,
                      controller: widget.controller,
                      inputFormatters: widget.inputFormatters,
                      onChanged: (text) => widget.onChanged?.call(text),
                    ),
                  ),
                  Offstage(
                    offstage: widget.unitWidget == null && widget.unit == '',
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: widget.unitWidget ?? Text(widget.unit, style: DxStyle.$404040$14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
