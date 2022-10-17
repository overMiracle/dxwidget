import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 无外形轮廓的输入框
/// 支持设置最长输入长度 支持获取验证码 密码掩码输入 支持设置键盘类型 支持placeholder
class DxTextFieldWithOutline extends StatefulWidget {
  const DxTextFieldWithOutline({
    Key? key,
    this.margin,
    this.padding,
    this.width = double.infinity,
    this.height = 56,
    required this.controller,
    this.maxLength = 100,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.focusNode,
    this.leftWidth = 80,
    this.isRequire = false,
    this.fillColor = Colors.white,
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.hintText,
    this.hintTextStyle,
    this.obscureText = false,
    this.isShowDelete = false,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.onChanged,
    this.prefixIcon,
    this.trailing,
    this.trailingEvent,
    this.onClick,
  }) : super(key: key);

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  /// 填充颜色，默认白色
  final Color fillColor;
  final double width;
  final double height;
  final TextEditingController controller;
  final int maxLength;
  final bool autofocus; //是否自动获得焦点 比如进入搜索页面 一进页面就调起键盘
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode; //焦点
  final TextAlign textAlign;

  /// 左侧统一宽度
  final double leftWidth;

  /// 录入项是否为必填项（展示*图标） 默认为 false 不必填
  final bool isRequire;
  final TextStyle? textStyle;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final bool obscureText;
  final bool isShowDelete; // 是否显示删除
  final bool readOnly; // 是否只读
  final bool enableInteractiveSelection; // 是否启用交互
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon; // 自定义左侧控件
  final Widget? trailing; // 自定义右侧
  final VoidCallback? trailingEvent; // 自定义图标事件
  final VoidCallback? onClick; // 整体点击事件

  @override
  State<DxTextFieldWithOutline> createState() => _DxTextFieldWithOutlineState();
}

class _DxTextFieldWithOutlineState extends State<DxTextFieldWithOutline> {
  bool _isShowPwd = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.zero,
      padding: widget.padding ?? EdgeInsets.zero,
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            controller: widget.controller,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText ? !_isShowPwd : false,
            obscuringCharacter: '⁕',
            enableInteractiveSelection: widget.enableInteractiveSelection,
            style: widget.textStyle ?? DxStyle.$404040$14,
            textAlign: widget.textAlign,
            // 数字、手机号限制格式为0到9(白名单)， 密码限制不包含汉字（黑名单）
            inputFormatters: _buildInputFormatter(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              filled: true,
              fillColor: widget.fillColor,
              prefixIcon: widget.prefixIcon, //左侧图标
              hintText: widget.hintText,
              hintStyle: widget.hintTextStyle ?? DxStyle.$999999$12,
              counterText: '',
              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4.0)),
            ),
            onChanged: (String v) {
              widget.onChanged?.call(v);
              setState(() {});
            },
            onTap: () => widget.onClick?.call(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /// 控制child是否显示
              /// 当offstage为true,child不会绘制到屏幕上,不会响应点击事件,也不会占用空间
              /// 当Offstage不可见的时候，如果child有动画等，需要手动停掉，Offstage并不会停掉动画等操作。
              Offstage(
                offstage: widget.trailing == null,
                child: GestureDetector(
                  onTap: widget.trailingEvent,
                  child: Align(alignment: Alignment.centerRight, child: widget.trailing),
                ),
              ),
              widget.isShowDelete && widget.controller.text.isNotEmpty
                  ? GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Icon(CupertinoIcons.clear_circled_solid, size: 18, color: Colors.grey[400]),
                      ),
                      onTap: () {
                        widget.onChanged?.call('');
                        setState(() => widget.controller.text = '');
                      },
                    )
                  : const SizedBox.shrink(),

              Offstage(
                offstage: !widget.obscureText,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SizedBox(
                      width: 20,
                      height: 40,
                      child: Image.asset(
                        _isShowPwd ? DxAsset.pwdShow : DxAsset.pwdHide,
                        fit: BoxFit.contain,
                        package: 'dxwidget',
                      ),
                    ),
                  ),
                  onTap: () => setState(() => _isShowPwd = !_isShowPwd),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 表单格式化
  List<TextInputFormatter>? _buildInputFormatter() {
    if (widget.keyboardType == TextInputType.number) {
      return [FilteringTextInputFormatter.allow(RegExp("[0-9]"))];
    }
    if (widget.keyboardType == TextInputType.phone) {
      return [FilteringTextInputFormatter.allow(RegExp("[0-9]")), DxFormUtil.phoneInputFormatter()];
    }
    return widget.inputFormatters;
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
