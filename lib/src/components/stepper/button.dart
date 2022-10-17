import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 步进器按钮
/// 这个文件不要引入到dxwidget中去
class DxStepperButton extends StatefulWidget {
  final bool disabled;
  final DxStepperTheme theme;
  final double? size;
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final IconData iconName;
  final BorderRadius borderRadius;

  const DxStepperButton({
    Key? key,
    this.disabled = false,
    this.size,
    this.theme = DxStepperTheme.normal,
    required this.onTap,
    required this.iconName,
    required this.borderRadius,
    required this.onLongPressStart,
    required this.onLongPressEnd,
  }) : super(key: key);

  factory DxStepperButton.minus({
    required VoidCallback onTap,
    required VoidCallback onLongPressStart,
    required VoidCallback onLongPressEnd,
    DxStepperTheme theme = DxStepperTheme.normal,
    bool disabled = false,
    double? size,
  }) {
    return DxStepperButton(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      disabled: disabled,
      size: size,
      theme: theme,
      iconName: Icons.remove,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(DxStyle.stepperBorderRadius),
        bottomLeft: Radius.circular(DxStyle.stepperBorderRadius),
      ),
    );
  }

  factory DxStepperButton.plus({
    required VoidCallback onTap,
    required VoidCallback onLongPressStart,
    required VoidCallback onLongPressEnd,
    DxStepperTheme theme = DxStepperTheme.normal,
    bool disabled = false,
    double? size,
  }) {
    return DxStepperButton(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      disabled: disabled,
      theme: theme,
      size: size,
      iconName: Icons.add,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(DxStyle.stepperBorderRadius),
        bottomRight: Radius.circular(DxStyle.stepperBorderRadius),
      ),
    );
  }

  @override
  State<DxStepperButton> createState() => _DxStepperButtonState();
}

class _DxStepperButtonState extends State<DxStepperButton> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disabled,
      child: MouseRegion(
        cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (TapDownDetails details) {
            setState(() => active = true);
          },
          onTapUp: (TapUpDetails details) {
            setState(() => active = false);
          },
          onTapCancel: () {
            setState(() => active = false);
          },
          onLongPressStart: (LongPressStartDetails details) {
            widget.onLongPressStart();
          },
          onLongPressEnd: (LongPressEndDetails details) {
            widget.onLongPressEnd();
          },
          onLongPressUp: () {
            widget.onLongPressEnd();
          },
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: isRound ? null : widget.borderRadius,
                shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                color: bgColor,
                border: border,
              ),
              child: Icon(
                widget.iconName,
                color: color,
                size: size * 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get size => widget.size ?? DxStyle.stepperInputHeight;

  double get opacity {
    if (isRound) {
      if (widget.disabled) return 0.3;
      if (active) return DxStyle.activeOpacity;
    }

    return 1.0;
  }

  Border? get border {
    if (isRound) {
      return Border.all(width: 1.0, color: DxStyle.stepperButtonRoundThemeColor);
    }
    return null;
  }

  Color get bgColor {
    if (isRound) {
      return widget.iconName == Icons.add ? DxStyle.stepperButtonRoundThemeColor : DxStyle.white;
    }

    if (widget.disabled) return DxStyle.stepperButtonDisabledColor;

    if (active) return DxStyle.stepperActiveColor;
    return DxStyle.stepperBackgroundColor;
  }

  Color get color {
    if (isRound) {
      return widget.iconName == Icons.add ? DxStyle.white : DxStyle.stepperButtonRoundThemeColor;
    }
    if (widget.disabled) {
      return DxStyle.stepperButtonDisabledIconColor;
    }
    return DxStyle.stepperButtonIconColor;
  }

  bool get isRound => widget.theme == DxStepperTheme.round;
}
