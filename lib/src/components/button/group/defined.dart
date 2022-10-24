import 'package:flutter/material.dart';

/// How the buttons should be placed in the main axis in a layout
enum DxGroupButtonMainAlignment { start, end, center, spaceBetween, spaceAround, spaceEvenly }

/// How the buttons should be placed along the cross axis in a layout
enum DxGroupButtonCrossAlignment { start, center, end }

/// How the button runs themselves should be placed the cross axis in a layout
enum DxGroupButtonRunAlignment { start, end, center, spaceBetween, spaceAround, spaceEvenly }

/// Responsible for how the buttons will be grouped
enum DxGroupButtonType { wrap, column, row }

/// Custom builder method to create custom buttons by index
typedef DxGroupButtonIndexedBuilder = Widget Function(bool selected, int index, BuildContext context);

/// Custom builder method to create custom buttons by value
typedef DxGroupButtonValueBuilder<T> = Widget Function(bool selected, T value, BuildContext context);
