import 'package:flutter/material.dart';

import 'defined.dart';

/// UI settings of package
class DxGroupButtonOptions {
  const DxGroupButtonOptions({
    this.type = DxGroupButtonType.wrap,
    this.direction,
    this.spacing = 10,
    this.runSpacing = 10,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.borderRadius,
    this.buttonHeight,
    this.buttonWidth,
    this.mainAlignment = DxGroupButtonMainAlignment.center,
    this.crossAlignment = DxGroupButtonCrossAlignment.center,
    this.runAlignment = DxGroupButtonRunAlignment.center,
    this.textAlign = TextAlign.left,
    this.textPadding = EdgeInsets.zero,
    this.alignment,
  });

  /// The field is responsible for how the buttons will be grouped
  final DxGroupButtonType type;

  /// [EdgeInsets] The inner padding of buttons [GroupButton]
  final EdgeInsets textPadding;

  /// [TextAlign] The buttons text alignment [GroupButton]
  final TextAlign textAlign;

  /// [Alignment] Text position inside the buttons in case [buttonWidth] or [buttonHeight] defined.
  final AlignmentGeometry? alignment;

  /// The direction of arrangement of the buttons in [GroupButton]
  final Axis? direction;

  /// The spacing between buttons inside [GroupButton]
  final double spacing;

  /// When [groupingType] is [GroupingType.wrap]
  /// this field sets Wrap [runSpacing]
  final double runSpacing;

  /// [TextStyle] of text of selected button(s)
  final TextStyle? selectedTextStyle;

  /// [TextStyle] of text of unselected buttons
  final TextStyle? unselectedTextStyle;

  /// background [Color] of selected button(s)
  final Color? selectedColor;

  /// background [Color] of  unselected buttons
  final Color? unselectedColor;

  /// border [Color] of selected button(s)
  final Color? selectedBorderColor;

  /// border [Color] of  unselected buttons
  final Color? unselectedBorderColor;

  /// [BorderRadius] of  buttons
  /// How much the button will be rounded
  final BorderRadius? borderRadius;

  /// Height of Group button
  final double? buttonHeight;

  /// Width of group button
  final double? buttonWidth;

  /// How the buttons should be placed in the main axis in a layout
  final DxGroupButtonMainAlignment mainAlignment;

  /// How the buttons should be placed along the cross axis in a layout
  final DxGroupButtonCrossAlignment crossAlignment;

  /// How the button runs themselves should be placed along the cross axis in a layout
  final DxGroupButtonRunAlignment runAlignment;
}
