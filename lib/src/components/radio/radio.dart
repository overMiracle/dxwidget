import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 单选
// ignore: must_be_immutable
class DxRadio extends StatefulWidget {
  bool value;
  final String? text;
  final bool disabled;
  final double iconSize;
  final Color checkedColor;
  final Function(bool value)? onChanged;

  DxRadio({
    Key? key,
    this.value = false,
    this.text,
    this.disabled = false,
    this.iconSize = DxStyle.checkboxSize,
    this.checkedColor = DxStyle.checkboxCheckedIconColor,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DxRadio> createState() => _DxRadioState();
}

class _DxRadioState extends State<DxRadio> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.disabled
        ? DxStyle.checkboxDisabledBackgroundColor
        : widget.value
            ? widget.checkedColor
            : DxStyle.checkboxBackgroundColor;

    Color borderColor = widget.disabled || !widget.value ? DxStyle.checkboxBorderColor : widget.checkedColor;
    Color iconColor = widget.disabled
        ? (widget.value ? DxStyle.checkboxDisabledIconColor : DxStyle.checkboxDisabledBackgroundColor)
        : DxStyle.checkboxBackgroundColor;

    TextStyle textStyle = widget.disabled
        ? DxStyle.$CCCCCC$14.copyWith(height: 1.3)
        : widget.value
            ? DxStyle.$4A92E3$14.copyWith(height: 1.3)
            : DxStyle.$404040$14.merge(const TextStyle(height: 1.3));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.disabled) return;
        setState(() => widget.value = !widget.value);
        widget.onChanged?.call(widget.value);
      },

      /// 这里为了增大点击面积，套一层sizedBox
      child: SizedBox(
        height: 54,
        child: Row(
          children: <Widget>[
            Container(
              width: widget.iconSize,
              height: widget.iconSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(width: DxStyle.borderWidthBase, color: borderColor),
                borderRadius: BorderRadius.circular(DxStyle.borderRadiusMax),
              ),
              child: Icon(Icons.check, size: widget.iconSize / 1.25, color: iconColor),
            ),
            widget.text != null
                ? Padding(
                    padding: const EdgeInsets.only(left: DxStyle.paddingBase),
                    child: Text("${widget.text}", style: textStyle),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
