import 'package:flutter/material.dart';

typedef DxPopoverTransitionBuilder = Widget Function(Animation<double> animation, Widget child);

/// Popover Transition
enum DxPopoverTransition { scale, other }

/// Popover direction
enum DxPopoverDirection { top, bottom, left, right }
