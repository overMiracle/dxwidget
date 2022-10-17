import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 位置
enum DxCheckerLabelPosition { left, right }

/// 形状
enum DxCheckerShape { square, round }

/// Checkbox 复选框
/// 用于在选中和非选中状态之间进行切换。
class DxCheckbox<T extends dynamic> extends StatelessWidget {
  final T? name;
  final bool disabled;
  final double? iconSize;
  final bool value;
  final Color? checkedColor;
  final DxCheckerLabelPosition labelPosition;
  final bool labelDisabled;
  final DxCheckerShape shape;
  final bool bindGroup;
  final ValueChanged<bool>? onChange;
  final VoidCallback? onClick;
  final Widget Function(bool checked)? iconBuilder;
  final Widget? child;

  const DxCheckbox({
    Key? key,
    this.name,
    this.disabled = false,
    this.iconSize,
    this.value = false,
    this.checkedColor,
    this.labelPosition = DxCheckerLabelPosition.right,
    this.labelDisabled = false,
    this.shape = DxCheckerShape.round,
    this.bindGroup = true,
    this.onChange,
    this.onClick,
    this.iconBuilder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxCheckboxGroup<T>? parent = DxCheckBoxScope.of(context)?.parent as DxCheckboxGroup<T>?;
    if (parent != null && name == null) {
      throw 'use DxCheckbox in the DxCheckboxGroup,please set the name of DxCheckbox';
    }

    void setParentValue(bool checked) {
      final int max = parent!.max;
      final List<T> value = parent.value.toList();

      if (checked) {
        final bool overlimit = max > 0 && value.length >= max;
        if (!overlimit && !value.contains(name)) {
          value.add(name as T);
          if (bindGroup) {
            parent.updateValue(value);
          }
        }
      } else {
        if (value.remove(name!) && bindGroup) {
          parent.updateValue(value);
        }
      }
    }

    final bool checked = parent != null && bindGroup ? parent.value.contains(name) : value;

    void toggle({bool? newValue}) {
      newValue ??= !checked;
      if (parent != null && bindGroup) {
        setParentValue(newValue);
      } else {
        onChange?.call(newValue);
      }
    }

    return DxChecker<T>(
      iconBuilder: iconBuilder,
      role: 'checkbox',
      value: value,
      checked: checked,
      parent: DxCheckerParentProps(
        checkedColor: parent?.checkedColor,
        direction: parent?.direction,
        disabled: parent?.disabled,
        iconSize: parent?.iconSize,
      ),
      onToggle: toggle,
      onClick: onClick,
      disabled: disabled,
      iconSize: iconSize,
      checkedColor: checkedColor,
      name: name,
      labelPosition: labelPosition,
      labelDisabled: labelDisabled,
      shape: shape,
      child: child,
    );
  }
}

class DxChecker<T> extends StatelessWidget {
  const DxChecker({
    Key? key,
    this.name,
    this.disabled = false,
    this.iconSize,
    this.value = false,
    this.checkedColor,
    this.labelPosition = DxCheckerLabelPosition.right,
    this.labelDisabled = false,
    this.shape = DxCheckerShape.round,
    this.role,
    this.parent,
    this.checked = false,
    this.bindGroup = true,
    this.onClick,
    this.onToggle,
    this.iconBuilder,
    this.child,
  }) : super(key: key);

  // ****************** Props ******************
  final T? name;
  final bool disabled;
  final double? iconSize;
  final bool value;
  final Color? checkedColor;
  final DxCheckerLabelPosition labelPosition;
  final bool labelDisabled;
  final DxCheckerShape shape;
  final String? role;
  final DxCheckerParentProps? parent;
  final bool checked;
  final bool bindGroup;

  // ****************** Events ******************
  final VoidCallback? onClick;
  final VoidCallback? onToggle;

  // ****************** Slots ******************
  final Widget Function(bool checked)? iconBuilder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[_buildIcon()];
    if (labelPosition == DxCheckerLabelPosition.left) {
      children.insert(0, _buildLabel());
    } else {
      children.add(_buildLabel());
    }

    return Semantics(
      label: role,
      checked: checked,
      child: GestureDetector(
        onTap: _onClick,
        child: Wrap(
          spacing: DxStyle.checkboxLabelMargin,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final double? iconSize = this.iconSize ?? _parentProps?.iconSize;
    final double size = iconSize ?? DxStyle.checkboxSize;

    final Color? bgColor = _disabled
        ? DxStyle.checkboxDisabledBackgroundColor
        : checked
            ? iconColor ?? DxStyle.checkboxCheckedIconColor
            : null;

    final Color? borderColor = _disabled
        ? DxStyle.checkboxDisabledIconColor
        : checked
            ? iconColor ?? DxStyle.checkboxCheckedIconColor
            : null;

    return MouseRegion(
      cursor: _disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: iconBuilder != null
          ? SizedBox(
              height: DxStyle.checkboxSize,
              child: iconBuilder!(checked),
            )
          : Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  width: 1.0,
                  color: borderColor ?? DxStyle.checkboxBorderColor,
                ),
                shape: shape == DxCheckerShape.round ? BoxShape.circle : BoxShape.rectangle,
              ),
              width: 1.2 * size,
              height: 1.2 * size,
              alignment: Alignment.center,
              child: DxIcon(
                iconName: Icons.check_circle,
                color: checked
                    ? _disabled
                        ? DxStyle.checkboxDisabledIconColor
                        : DxStyle.white
                    : Colors.transparent,
                size: size * 0.8,
              ),
            ),
    );
  }

  Widget _buildLabel() {
    if (child != null) {
      return IgnorePointer(
        ignoring: labelDisabled,
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: DxStyle.checkboxSize * 0.8,
            color: disabled ? DxStyle.checkboxDisabledLabelColor : DxStyle.checkboxLabelColor,
          ),
          child: child!,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _onClick() {
    if (!disabled) {
      onToggle?.call();
    }
    onClick?.call();
  }

  DxCheckerParentProps? get _parentProps => parent != null && bindGroup ? parent! : null;

  bool get _disabled => _parentProps?.disabled ?? disabled;

  Color? get iconColor {
    final Color? checkedColor = this.checkedColor ?? _parentProps?.checkedColor;
    if (checkedColor != null && checked && !_disabled) {
      return checkedColor;
    }
    return null;
  }
}

class DxCheckerParentProps {
  const DxCheckerParentProps({
    this.disabled,
    this.iconSize,
    this.direction,
    this.checkedColor,
  });

  final bool? disabled;
  final double? iconSize;
  final Axis? direction;
  final Color? checkedColor;
}
