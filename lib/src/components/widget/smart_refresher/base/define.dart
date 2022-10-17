import 'package:dxwidget/src/components/widget/smart_refresher/index.dart';
import 'package:flutter/material.dart';

typedef VoidFutureCallBack = Future<void> Function();

typedef OffsetCallBack = void Function(double offset);

typedef ModeChangeCallBack<T> = void Function(T? mode);

/// wrap child in outside,mostly use in add background color and padding
typedef OuterBuilder = Widget Function(Widget child);

/// custom header builder,you can use second parameter to know what header state is
typedef HeaderBuilder = Widget Function(BuildContext context, RefreshStatus? mode);

/// custom footer builder,you can use second parameter to know what footer state is
typedef FooterBuilder = Widget Function(BuildContext context, RefreshLoadStatus? mode);

/// when viewport not full one page, for different state,whether it should follow the content
typedef OnTwoLevel = void Function(bool isOpen);

/// when viewport not full one page, for different state,whether it should follow the content
typedef ShouldFollowContent = bool Function(RefreshLoadStatus? status);

/// global default indicator builder
typedef IndicatorBuilder = Widget Function();

/// a builder for attaching refresh function with the physics
typedef RefresherBuilder = Widget Function(BuildContext context, RefreshPhysics physics);

enum BezierDismissType { none, rectSpread, scaleToCenter }

enum BezierCircleType { radial, progress }

/// direction that icon should place to the text
enum IconPosition { left, right, top, bottom }

enum TwoLevelDisplayAlignment { fromTop, fromCenter, fromBottom }
