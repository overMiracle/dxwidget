import 'package:flutter/material.dart';

import 'controller.dart';
import 'defined.dart';
import 'extensions.dart';
import 'group_button_item.dart';

class DxGroupButtonBody<T> extends StatefulWidget {
  const DxGroupButtonBody({
    Key? key,
    required this.buttons,
    required this.textAlign,
    required this.textPadding,
    this.controller,
    this.onSelected,
    this.type,
    this.onDisablePressed,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.disabledButtons = const [],
    this.isRadio = false,
    this.enableDeselect = false,
    this.maxSelected,
    this.direction,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius = BorderRadius.zero,
    this.buttonWidth,
    this.buttonHeight,
    this.mainAlignment = DxGroupButtonMainAlignment.center,
    this.crossAlignment = DxGroupButtonCrossAlignment.center,
    this.runAlignment = DxGroupButtonRunAlignment.center,
    this.alignment,
    this.buttonIndexedBuilder,
    this.buttonBuilder,
  }) : super(key: key);

  final List<T> buttons;
  final List<int> disabledButtons;
  final void Function(T, int, bool)? onSelected;
  final Function(int)? onDisablePressed;
  final bool isRadio;
  final bool? enableDeselect;
  final int? maxSelected;
  final Axis? direction;
  final double spacing;
  final double runSpacing;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final BorderRadius? borderRadius;
  final double? buttonWidth;
  final double? buttonHeight;
  final DxGroupButtonType? type;
  final DxGroupButtonMainAlignment mainAlignment;
  final DxGroupButtonCrossAlignment crossAlignment;
  final DxGroupButtonRunAlignment runAlignment;
  final TextAlign textAlign;
  final EdgeInsets textPadding;
  final AlignmentGeometry? alignment;
  final DxGroupButtonController? controller;
  final DxGroupButtonIndexedBuilder? buttonIndexedBuilder;
  final DxGroupButtonValueBuilder<T>? buttonBuilder;

  @override
  State<DxGroupButtonBody<T>> createState() => _DxGroupButtonBodyState<T>();
}

class _DxGroupButtonBodyState<T> extends State<DxGroupButtonBody<T>> {
  late DxGroupButtonController _controller;

  @override
  void didUpdateWidget(covariant DxGroupButtonBody<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller = widget.controller ?? _buildController();
      _controller.onDisablePressed ??= widget.onDisablePressed;
    }
  }

  DxGroupButtonController _buildController() => DxGroupButtonController(
        disabledIndexes: widget.disabledButtons,
        onDisablePressed: widget.onDisablePressed,
      );

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? _buildController();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => _buildBodyByGroupingType(),
    );
  }

  Widget _buildBodyByGroupingType() {
    final buttons = _generateButtonsList();

    switch (widget.type) {
      case DxGroupButtonType.row:
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: widget.mainAlignment.toAxis(),
              crossAxisAlignment: widget.crossAlignment.toAxis(),
              children: buttons,
            ),
          ),
        );
      case DxGroupButtonType.column:
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: widget.mainAlignment.toAxis(),
            crossAxisAlignment: widget.crossAlignment.toAxis(),
            children: buttons,
          ),
        );

      case DxGroupButtonType.wrap:
      default:
        return Wrap(
          direction: widget.direction ?? Axis.horizontal,
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          alignment: widget.mainAlignment.toWrap(),
          crossAxisAlignment: widget.crossAlignment.toWrap(),
          runAlignment: widget.runAlignment.toWrap(),
          children: buttons,
        );
    }
  }

  List<Widget> _generateButtonsList() {
    final rebuildedButtons = <Widget>[];
    for (var i = 0; i < widget.buttons.length; i++) {
      late Widget button;
      final buttonBuilder = widget.buttonBuilder;
      final buttonIndexedBuilder = widget.buttonIndexedBuilder;

      if (buttonBuilder != null || buttonIndexedBuilder != null) {
        button = GestureDetector(
          onTap: _controller.disabledIndexes.contains(i)
              ? () => _controller.onDisablePressed?.call(i)
              : () {
                  _selectButton(i);
                  widget.onSelected?.call(widget.buttons[i], i, _isSelected(i));
                },
          child: buttonBuilder != null
              ? buttonBuilder(_isSelected(i), widget.buttons[i], context)
              : buttonIndexedBuilder!(_isSelected(i), i, context),
        );
      } else {
        button = DxGroupButtonItem(
          text: widget.buttons[i].toString(),
          onPressed: _controller.disabledIndexes.contains(i)
              ? () => _controller.onDisablePressed?.call(i)
              : () {
                  _selectButton(i);
                  widget.onSelected?.call(widget.buttons[i], i, _isSelected(i));
                },
          isSelected: _isSelected(i),
          isDisable: _controller.disabledIndexes.contains(i),
          selectedTextStyle: widget.selectedTextStyle,
          unselectedTextStyle: widget.unselectedTextStyle,
          selectedColor: widget.selectedColor,
          unselectedColor: widget.unselectedColor,
          selectedBorderColor: widget.selectedBorderColor,
          unselectedBorderColor: widget.unselectedBorderColor,
          borderRadius: widget.borderRadius,
          height: widget.buttonHeight,
          width: widget.buttonWidth,
          textAlign: widget.textAlign,
          textPadding: widget.textPadding,
          alignment: widget.alignment,
        );
      }

      /// Padding adding
      /// when groupingType is row or column
      if (widget.spacing > 0.0 && widget.buttonIndexedBuilder == null && widget.buttonBuilder == null) {
        if (widget.type == DxGroupButtonType.row) {
          button = Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.spacing),
            child: button,
          );
        } else if (widget.type == DxGroupButtonType.column) {
          button = Padding(
            padding: EdgeInsets.symmetric(vertical: widget.spacing),
            child: button,
          );
        }
      }

      rebuildedButtons.add(button);
    }
    return rebuildedButtons;
  }

  void _selectButton(int i) {
    if (widget.isRadio) {
      if (widget.enableDeselect! && _controller.selectedIndex == i) {
        _controller.unselectIndex(i);
      } else {
        _controller.selectIndex(i);
      }
    } else {
      final maxSelected = widget.maxSelected;
      final selectedIndexesCount = _controller.selectedIndexes.length;
      if (maxSelected != null && selectedIndexesCount >= maxSelected && !_controller.selectedIndexes.contains(i)) {
        return;
      }
      _controller.toggleIndexes([i]);
    }
  }

  bool _isSelected(int i) => widget.isRadio ? _controller.selectedIndex == i : _controller.selectedIndexes.contains(i);
}
