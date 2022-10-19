import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

typedef OnDxChipListSelected = void Function(int index, DxChipItem item);

/// Creates a list of [ChoiceChips] with
/// all logic handled.
///
///
/// Set the names of chips and boom !
/// Use [supportsMultiSelect] if
/// multiple chips can be selected at once.
/// 暂时只能单选
class DxChipList extends StatefulWidget {
  const DxChipList({
    Key? key,
    this.shouldWrap = false,
    this.axis = Axis.horizontal,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.activeTextColor = DxStyle.$3660C8,
    this.activeBgColor = DxStyle.$EEF3FF,
    this.inactiveBgColor = DxStyle.$F5F5F5,
    this.inactiveBorderColor = DxStyle.$F5F5F5,
    this.activeBorderColor = DxStyle.$3660C8,
    this.borderRadius = 15.0,
    // this.supportsMultiSelect = false,
    this.runSpacing = 0.0,
    this.spacing = 0.0,
    this.textStyle = DxStyle.$404040$12,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.onSelected,
    required this.children,
  }) : super(key: key);

  /// 是否支持多选，默认false为单选
  // final bool supportsMultiSelect;

  /// 未选中背景颜色
  final Color inactiveBgColor;

  /// 选中背景颜色
  final Color activeBgColor;

  /// 选中文字颜色
  final Color activeTextColor;

  /// For any text styling needs.
  ///
  /// Using [color] here is pointless
  /// as it will be overwritten by
  /// the value of [activeTextColorList]
  /// and [inactiveTextColorList].
  final TextStyle textStyle;

  /// Determines if the chip_list should be wrapped.
  ///
  /// If you set it to [true],
  /// ensure that you wrap the [ChipList]
  /// within a [SizedBox] and define the [width]
  /// property.
  ///
  /// Defaults to false.
  final bool shouldWrap;

  /// If you wish to change the [ScrollPhysics]
  /// of the widget.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics scrollPhysics;

  /// MainAxisAlignment for the parent [Row] or [Column] of
  /// the [ChipList], which is used in case of
  /// [Axis.horizontal] or [Axis.vertical] being passed in
  /// to [axis].
  ///
  /// Defaults to [MainAxisAlignment.center]
  final MainAxisAlignment mainAxisAlignment;

  /// [WrapAlignment] used, if [shouldWrap] is [true].
  ///
  /// Defaults to [WrapAlignment.start].
  final WrapAlignment wrapAlignment;

  /// [WrapCrossAlignment] used, if [shouldWrap] is [true]
  ///
  /// Defaults to [WrapCrossAlignment.start].
  final WrapCrossAlignment wrapCrossAlignment;

  /// [Axis] used, if [shouldWrap] is [true].
  ///
  /// Defaults to [Axis.horizontal].
  final Axis axis;

  /// [WrapAlignment] used, if [shouldWrap] is [true].
  ///
  /// How the runs themselves should
  /// be placed in the cross axis.
  ///
  /// Defaults to [WrapAlignment.start].
  final WrapAlignment runAlignment;

  /// [runSpacing] used, if [shouldWrap] is [true],
  ///
  /// How much space to place between the
  /// runs themselves in the cross axis.
  ///
  /// Defaults to 0.0.
  final double runSpacing;

  /// [spacing] used, if [shouldWrap] is [true],
  ///
  /// How much space to place between
  /// children in a run in the main axis.
  ///
  /// Defaults to 0.0.
  final double spacing;
  final TextDirection? textDirection;

  final VerticalDirection verticalDirection;
  final double borderRadius;

  final Color inactiveBorderColor;

  final Color activeBorderColor;

  final double widgetSpacing = 4.0;

  final OnDxChipListSelected? onSelected;

  final List<DxChipItem> children;

  @override
  State<DxChipList> createState() => _DxChipListState();
}

class _DxChipListState extends State<DxChipList> {
  @override
  Widget build(BuildContext context) {
    return widget.shouldWrap
        ? Wrap(
            alignment: widget.wrapAlignment,
            crossAxisAlignment: widget.wrapCrossAlignment,
            direction: widget.axis,
            runAlignment: widget.runAlignment,
            runSpacing: widget.runSpacing,
            spacing: widget.spacing,
            textDirection: widget.textDirection,
            verticalDirection: widget.verticalDirection,
            children: List.generate(widget.children.length, (index) => _buildChipItem(index)),
          )
        : SingleChildScrollView(
            scrollDirection: widget.axis,
            physics: widget.scrollPhysics,
            child: widget.axis == Axis.horizontal
                ? Row(
                    mainAxisAlignment: widget.mainAxisAlignment,
                    children: List.generate(
                      widget.children.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.widgetSpacing),
                        child: _buildChipItem(index),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: widget.mainAxisAlignment,
                    children: List.generate(
                      widget.children.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: widget.widgetSpacing),
                        child: _buildChipItem(index),
                      ),
                    ),
                  ),
          );
  }

  ChoiceChip _buildChipItem(int index) {
    DxChipItem item = widget.children.elementAt(index);
    return ChoiceChip(
      elevation: 0,
      pressElevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      visualDensity: const VisualDensity(vertical: -4),
      label: Text(
        widget.children[index].name ?? '',
        style: widget.textStyle.copyWith(color: item.isSelected ? widget.activeTextColor : null),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        side: BorderSide(color: item.isSelected ? widget.activeBorderColor : widget.inactiveBorderColor),
      ),
      backgroundColor: widget.inactiveBgColor,
      selected: item.isSelected,
      selectedColor: item.isSelected ? widget.activeBgColor : widget.inactiveBgColor,
      onSelected: (bool val) {
        if (item.isSelected) return;
        for (var v in widget.children) {
          v.isSelected = false;
        }
        item.isSelected = true;
        setState(() {});
        widget.onSelected?.call(index, item);
      },
    );
  }
}

/// 单元
class DxChipItem {
  final String? name;
  final int? value;
  final String? valueString;
  bool isSelected;

  DxChipItem({
    this.name,
    this.value,
    this.valueString,
    this.isSelected = false,
  });
}
