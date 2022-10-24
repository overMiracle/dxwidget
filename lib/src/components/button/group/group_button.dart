import 'package:dxwidget/src/utils/screen/index.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'defined.dart';
import 'group_button_body.dart';
import 'options.dart';

class DxGroupButton<T> extends StatelessWidget {
  const DxGroupButton({
    Key? key,
    required this.buttons,
    this.onSelected,
    this.controller,
    this.options = const DxGroupButtonOptions(),
    this.isRadio = true,
    this.buttonIndexedBuilder,
    this.buttonBuilder,
    this.enableDeselect = false,
    this.maxSelected,
  })  : assert(
          maxSelected != null ? maxSelected >= 0 : true,
          'maxSelected must not be negative',
        ),
        assert((buttonBuilder == null && buttonIndexedBuilder == null) ||
            !(buttonBuilder != null && buttonIndexedBuilder != null)),
        super(key: key);

  /// [String] list that will be displayed on buttons in the [GroupButton]
  final List<T> buttons;

  /// Callback [Function] works by clicking on a group element
  ///
  /// Return int [index] of selected button and [isSelected] if [isRadio] = false
  final Function(T value, int index, bool isSelected)? onSelected;

  /// bool variable for switching between modes [CheckBox] and [Radio]
  ///
  /// if the [isRadio] = true, only one button can be selected
  /// if the [isRadio] = false, you can select several at once
  final bool isRadio;

  /// bool variable for enable radio button to be deselected
  ///
  /// * if the [isRadio] = true :
  /// - if the [enableDeselect] = true , the selected radio button can be deselected
  /// - if the [enableDeselect] = false , the selected radio button can't be deselected
  ///
  /// * if the [isRadio] = false:
  /// - [enableDeselect] have no effect
  final bool? enableDeselect;

  /// int variable for setting max selected buttons for [CheckBox]
  ///
  /// [maxSelected] must not be negative.
  final int? maxSelected;

  /// Controller to making widget logic
  final DxGroupButtonController? controller;

  /// UI settings of package
  final DxGroupButtonOptions options;

  /// Custom builder method to create
  /// Your own custom buttons by button [int] index
  final DxGroupButtonIndexedBuilder? buttonIndexedBuilder;

  /// Custom builder method to create
  /// Your own custom buttons by button [T] value
  final DxGroupButtonValueBuilder<T>? buttonBuilder;

  @override
  Widget build(BuildContext context) {
    return DxGroupButtonBody<T>(
      controller: controller,
      buttons: buttons,
      onSelected: onSelected,
      isRadio: isRadio,
      buttonIndexedBuilder: buttonIndexedBuilder,
      buttonBuilder: buttonBuilder,
      enableDeselect: enableDeselect,
      maxSelected: maxSelected,

      /// Options
      direction: options.direction,
      spacing: options.spacing,
      runSpacing: options.runSpacing,
      selectedTextStyle: options.selectedTextStyle ?? TextStyle(fontSize: 14.sp, color: Colors.white),
      unselectedTextStyle: options.unselectedTextStyle ?? TextStyle(fontSize: 14.sp, color: Colors.black),
      selectedColor: options.selectedColor,
      unselectedColor: options.unselectedColor,
      selectedBorderColor: options.selectedBorderColor,
      unselectedBorderColor: options.unselectedBorderColor,
      borderRadius: options.borderRadius,
      buttonWidth: options.buttonWidth,
      buttonHeight: options.buttonHeight,
      mainAlignment: options.mainAlignment,
      crossAlignment: options.crossAlignment,
      runAlignment: options.runAlignment,
      type: options.type,
      textAlign: options.textAlign,
      textPadding: options.textPadding,
      alignment: options.alignment,
    );
  }
}
