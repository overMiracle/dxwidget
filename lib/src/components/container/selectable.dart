library selectable_container;

import 'package:flutter/material.dart';

/// Box that can be tapped.
/// When selected a check Icon appears
/// github地址：https://github.com/fgcan10/selectable_container
class DxSelectableContainer extends StatelessWidget {
  /// Background color for the space between the child and the
  /// Default value: scaffoldBackgroundColor
  final Color? marginColor;

  /// Background color when container is selected.
  /// Default value : dialogBackgroundColor
  final Color? selectedBackgroundColor;

  /// Background color when container is not selected.
  /// Default value : dialogBackgroundColor
  final Color? unselectedBackgroundColor;

  /// Background color of the icon when container is selected.
  /// Default value : theme.primaryColor
  final Color? selectedBackgroundColorIcon;

  /// Background color of the icon when container is not selected.
  /// Default value : theme.primaryColorDark
  final Color? unselectedBackgroundColorIcon;

  /// Border color when container is selected.
  /// Default value : primaryColor
  final Color? selectedBorderColor;

  /// Border color when container is not selected.
  /// Default value :primaryColorDark
  final Color? unselectedBorderColor;

  /// Border color of the icon when container is selected.
  /// Default value : Colors.white
  final Color? selectedBorderColorIcon;

  /// Border color of the icon when container is not selected.
  /// Default value : Colors.white
  final Color? unselectedBorderColorIcon;

  /// Icon's color
  /// Default value : white
  final Color iconColor;

  /// Icon's size
  /// Default value : 16
  final int iconSize;

  /// The child to render inside the container
  final Widget? child;

  /// Border size
  /// Default value : 2 pixels
  final int borderSize;

  /// Callback of type ValueChanged
  final ValueChanged<bool>? onValueChanged;

  /// Opacity when container is not selected.
  /// When not 1 it will be animated when tapped.
  /// Default value : 0.5
  final double unselectedOpacity;

  /// Opacity when container is selected.
  /// When not 1 it will be animated when tapped.
  /// Default value : 1
  final double selectedOpacity;

  /// Opacity animation duration in milliseconds.
  /// Default value : 600
  final int opacityAnimationDuration;

  /// Icon to be shown when selected.
  /// Default value : Icons.check
  final IconData icon;

  /// Icon to be shown when unselected.
  /// Default value : geen
  final IconData? unselectedIcon;

  /// Icon position.
  /// Default value : Alignment.topRight
  final Alignment iconAlignment;

  final EdgeInsets padding;

  /// Elevation
  /// Default value : 0.0
  final double elevation;

  ///Default value : 10.0
  final double borderRadius;

  ///Default not selected
  final bool selected;

  // Top margin. Default value : 0.0
  final double topMargin;

  // Bottom margin. Default value : 0.0
  final double bottomMargin;

  // Left margin. Default value : 0.0
  final double leftMargin;

  // Right margin. Default value : 0.0
  final double rightMargin;

  // Top position of the icon.
  final double? topIconPosition;

  // Bottom position of the icon.
  final double? bottomIconPosition;

  // Left position of the icon.
  final double? leftIconPosition;

  // Right position of the icon.
  final double? rightIconPosition;

  const DxSelectableContainer({
    super.key,
    this.marginColor,
    this.unselectedBackgroundColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColorIcon,
    this.selectedBackgroundColorIcon,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedBorderColorIcon,
    this.unselectedBorderColorIcon,
    this.iconSize = 16,
    this.iconColor = Colors.white,
    this.icon = Icons.check,
    this.unselectedIcon,
    this.iconAlignment = Alignment.topRight,
    this.borderSize = 2,
    this.selectedOpacity = 1.0,
    this.unselectedOpacity = 0.5,
    this.opacityAnimationDuration = 600,
    this.padding = EdgeInsets.zero,
    this.elevation = 0.0,
    this.borderRadius = 10.0,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
    this.topIconPosition,
    this.bottomIconPosition,
    this.leftIconPosition,
    this.rightIconPosition,
    this.onValueChanged,
    this.selected = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onValueChanged?.call(!selected),
      child: AnimatedOpacity(
        opacity: selected ? selectedOpacity : unselectedOpacity,
        duration: Duration(milliseconds: opacityAnimationDuration),
        child: Material(
          elevation: 0.0,
          child: Material(
            elevation: elevation,
            color: marginColor ?? theme.scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
              child: Stack(
                alignment: iconAlignment,
                children: <Widget>[
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(iconSize / 2),
                    padding: padding,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: selected
                              ? selectedBorderColor ?? theme.primaryColor
                              : unselectedBorderColor ?? theme.primaryColorDark,
                          width: borderSize.toDouble()),
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: selected
                          ? selectedBackgroundColor ?? theme.dialogBackgroundColor
                          : unselectedBackgroundColor ?? theme.dialogBackgroundColor,
                    ),
                    child: child,
                  ),
                  Positioned(
                    top: topIconPosition,
                    bottom: bottomIconPosition,
                    left: leftIconPosition,
                    right: rightIconPosition,
                    child: Visibility(
                      visible: !selected && unselectedIcon != null,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: unselectedBorderColorIcon ?? Colors.white),
                            shape: BoxShape.circle,
                            color: unselectedBackgroundColorIcon ?? theme.primaryColorDark),
                        child: Icon(unselectedIcon, size: iconSize.toDouble(), color: iconColor),
                      ),
                    ),
                  ),
                  Positioned(
                    top: topIconPosition,
                    bottom: bottomIconPosition,
                    left: leftIconPosition,
                    right: rightIconPosition,
                    child: Visibility(
                      visible: selected,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: selectedBorderColorIcon ?? Colors.white),
                            shape: BoxShape.circle,
                            color: selectedBackgroundColorIcon ?? theme.primaryColor),
                        child: Icon(icon, size: iconSize.toDouble(), color: iconColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
