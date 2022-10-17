import 'dart:async';

import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DxStepperTheme { normal, round }

enum DxStepperActionType { plus, minus }

const Duration longPressInterval = Duration(milliseconds: 200);

/// Stepper 步进器
/// 步进器由增加按钮、减少按钮和输入框组成，用于在一定范围内输入、调整数字。
class DxStepper extends StatefulWidget {
  /// 样式风格，可选值为 `round`
  final DxStepperTheme theme;

  /// 当前输入的值
  final num value;

  /// 最小值
  final num min;

  /// 最大值
  final num max;

  /// 步长，每次点击时改变的值
  final num step;

  /// 输入框宽度
  final double? inputWidth;

  /// 按钮大小以及输入框高度
  final double? buttonSize;

  /// 固定显示的小数位数
  final int decimalLength;

  /// 是否只允许输入整数
  final bool integer;

  /// 是否禁用步进器
  final bool disabled;

  /// 是否禁用增加按钮
  final bool disablePlus;

  /// 是否禁用减少按钮
  final bool disableMinus;

  /// 	是否禁用输入框
  final bool disableInput;

  /// 输入值变化前的回调函数，返回 false 可阻止输入
  final bool Function(dynamic)? beforeChange;

  /// 是否显示增加按钮
  final bool showPlus;

  /// 是否显示减少按钮
  final bool showMinus;

  /// 是否开启长按手势
  final bool longPress;

  /// 点击减少按钮时触发
  final VoidCallback? onMinus;

  /// 点击增加按钮时触发
  final VoidCallback? onPlus;

  /// 当绑定值变化时触发的事件
  final Function(String val) onChange;

  const DxStepper({
    Key? key,
    this.theme = DxStepperTheme.normal,
    this.min = 0,
    this.max = 999999,
    this.value = 1,
    this.step = 1,
    this.inputWidth,
    this.buttonSize,
    this.decimalLength = 0,
    this.integer = false,
    this.disabled = false,
    this.disablePlus = false,
    this.disableMinus = false,
    this.disableInput = false,
    this.beforeChange,
    this.showPlus = true,
    this.showMinus = true,
    this.longPress = true,
    this.onMinus,
    this.onPlus,
    required this.onChange,
  }) : super(key: key);

  @override
  State<DxStepper> createState() => _DxStepperState();
}

class _DxStepperState extends State<DxStepper> {
  late num value;
  DxStepperActionType? actionType;
  Timer? longPressTimer;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.0,
      children: <Widget>[
        _StepperButton.minus(
          onTap: () {
            actionType = DxStepperActionType.minus;
            onChange();
          },
          onLongPressStart: () {
            actionType = DxStepperActionType.minus;
            onTouchStart();
          },
          onLongPressEnd: onTouchEnd,
          size: widget.buttonSize,
          disabled: minusDisabled,
          theme: widget.theme,
        ),
        _buildInput(context),
        _StepperButton.plus(
          onTap: () {
            actionType = DxStepperActionType.plus;
            onChange();
          },
          onLongPressStart: () {
            actionType = DxStepperActionType.plus;
            onTouchStart();
          },
          onLongPressEnd: onTouchEnd,
          size: widget.buttonSize,
          disabled: plusDisabled,
          theme: widget.theme,
        ),
      ],
    );
  }

  Widget _buildInput(BuildContext context) {
    final TextEditingController textController =
        TextEditingController(text: value.toStringAsFixed(widget.decimalLength));
    final Color color = widget.disabled ? DxStyle.stepperInputDisabledTextColor : DxStyle.stepperInputTextColor;

    final Color bgColor =
        widget.disabled ? DxStyle.stepperInputDisabledBackgroundColor : DxStyle.stepperBackgroundColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        DxDialog.confirm(context, title: '请输入数量,最大${widget.max}', builder: (_) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DxField(
              autofocus: true,
              inputAlign: TextAlign.center,
              controller: textController,
              placeholder: '请输入数量',
              type: 'number',
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  widget.integer ? RegExp(r'^[0-9]*') : RegExp(r'^[0-9]*(\.[0-9]*){0,1}'),
                ),
              ],
              onSubmitted: (String val) {
                String valFixed = double.parse(val).toStringAsFixed(widget.decimalLength);
                value = double.parse(valFixed);
                if (value > widget.max) {
                  DxToast.show('超过最大数量');
                  return;
                }
                setState(() => value);
                widget.onChange.call(valFixed);
              },
            ),
          );
        }, onConfirm: () {
          String valFixed = double.parse(textController.text).toStringAsFixed(widget.decimalLength);
          value = double.parse(valFixed);
          if (value > widget.max) {
            DxToast.show('超过最大数量');
            return;
          }
          setState(() => value);
          widget.onChange.call(valFixed);
        });
      },
      child: Container(
        width: widget.inputWidth ?? DxStyle.stepperInputWidth,
        height: widget.buttonSize ?? DxStyle.stepperInputHeight,
        alignment: Alignment.center,
        color: widget.theme == DxStepperTheme.round ? Colors.transparent : bgColor,
        child: Text(value.toStringAsFixed(widget.decimalLength), style: TextStyle(color: color)),
      ),
    );
  }

  bool get minusDisabled {
    return widget.disabled || widget.disableMinus || value <= widget.min;
  }

  bool get plusDisabled {
    return widget.disabled || widget.disablePlus || value >= widget.max;
  }

  void onChange() {
    if ((actionType == DxStepperActionType.plus && plusDisabled) ||
        (actionType == DxStepperActionType.minus && minusDisabled)) {
      return;
    }
    // setValue(value);
    FocusScope.of(context).unfocus();
    switch (actionType) {
      case DxStepperActionType.minus:
        num newVal = value - widget.step;
        String val = newVal.toStringAsFixed(widget.decimalLength);
        setState(() => value = newVal);
        widget.onChange(val);
        widget.onMinus?.call();
        break;
      case DxStepperActionType.plus:
        num newVal = value + widget.step;
        String val = newVal.toStringAsFixed(widget.decimalLength);
        setState(() => value = newVal);
        widget.onChange(val);
        widget.onPlus?.call();
        break;
      default:
        break;
    }
  }

  void longPressStep() {
    longPressTimer = Timer(longPressInterval, () {
      onChange();
      longPressStep();
    });
  }

  void onTouchStart() {
    if (widget.longPress) {
      longPressTimer?.cancel();
      onChange();
      longPressStep();
    }
  }

  void onTouchEnd() {
    if (widget.longPress) {
      longPressTimer?.cancel();
    }
  }
}

class _StepperButton extends StatefulWidget {
  const _StepperButton({
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

  factory _StepperButton.minus({
    required VoidCallback onTap,
    required VoidCallback onLongPressStart,
    required VoidCallback onLongPressEnd,
    DxStepperTheme theme = DxStepperTheme.normal,
    bool disabled = false,
    double? size,
  }) {
    return _StepperButton(
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

  factory _StepperButton.plus({
    required VoidCallback onTap,
    required VoidCallback onLongPressStart,
    required VoidCallback onLongPressEnd,
    DxStepperTheme theme = DxStepperTheme.normal,
    bool disabled = false,
    double? size,
  }) {
    return _StepperButton(
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

  final bool disabled;
  final DxStepperTheme theme;
  final double? size;
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final IconData iconName;
  final BorderRadius borderRadius;

  @override
  __StepperButtonState createState() => __StepperButtonState();
}

class __StepperButtonState extends State<_StepperButton> {
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
      if (widget.disabled) {
        return 0.3;
      }

      if (active) {
        return DxStyle.activeOpacity;
      }
    }

    return 1.0;
  }

  Border? get border {
    if (isRound) {
      return Border.all(
        width: 1.0,
        color: DxStyle.stepperButtonRoundThemeColor,
      );
    }

    return null;
  }

  Color get bgColor {
    if (isRound) {
      return widget.iconName == Icons.add ? DxStyle.stepperButtonRoundThemeColor : DxStyle.white;
    }

    if (widget.disabled) {
      return DxStyle.stepperButtonDisabledColor;
    }

    if (active) {
      return DxStyle.stepperActiveColor;
    }
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

class FlanStepperDetails {
  const FlanStepperDetails({
    required this.name,
  });

  final String name;
}
