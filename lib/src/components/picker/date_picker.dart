import 'package:dxwidget/src/components/picker/base/picker_clip_rrect.dart';
import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date/date_widget.dart';
import 'package:dxwidget/src/components/picker/date/datetime_widget.dart';
import 'package:dxwidget/src/components/picker/date/time_widget.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

///时间选择模式枚举
enum DxDateTimePickerMode {
  /// Display DatePicker
  date,

  /// Display TimePicker
  time,

  /// Display DateTimePicker
  datetime,
}

/// 时间选择
/// 参考网址：https://bruno.ke.com/page/v2.2.0/widgets/brn-date-picker
class DxDatePicker {
  /// Display date picker in bottom sheet.
  ///
  /// context: [BuildContext]
  /// minDateTime: [DateTime] minimum date simple
  /// maxDateTime: [DateTime] maximum date simple
  /// initialDateTime: [DateTime] initial date simple for selected
  /// dateFormat: [String] date format pattern
  /// locale: [DateTimePickerLocale] internationalization
  /// pickerMode: [DxDateTimePickerMode] display mode: date(DatePicker)、simple(TimePicker)、datetime(DateTimePicker)
  /// pickerTheme: [DxPickerTitleConfig] the theme of date simple picker
  /// onCancel: [DateVoidCallback] pressed title cancel widget event
  /// onClose: [DateVoidCallback] date picker closed event
  /// onChange: [DateValueCallback] selected date simple changed event
  /// onConfirm: [DateValueCallback] pressed title confirm widget event
  static void show(
    BuildContext context, {

    /// If rootNavigator is set to true, the state from the furthest instance of this class is given instead.
    /// Useful for pushing contents above all subsequent instances of [Navigator].
    bool rootNavigator = false,

    /// 点击弹框外部区域能否消失
    bool? isDismissible = true,

    /// 能滚动到的最小日期
    DateTime? minDateTime,

    /// 能滚动到的最大日期
    DateTime? maxDateTime,

    /// 初始选择的时间。默认当前时间
    DateTime? initialDateTime,

    /// 时间格式化的格式
    String? dateFormat,

    /// 分钟间切换的差值
    int minuteDivider = 1,

    /// 时间选择组件显示的时间类型
    DxDateTimePickerMode pickerMode = DxDateTimePickerMode.date,

    /// 时间选择组件的标题
    String cancelTitle = '取消',

    /// 时间选择组件的标题
    String title = '请选择',

    /// 点击【取消】回调给调用方的回调事件
    DateVoidCallback? onCancel,

    /// 点击【完成】回调给调用方的数据
    DateVoidCallback? onClose,

    /// 时间滚动选择时候的回调事件
    DateValueCallback? onChange,

    /// 弹框点击外围消失的回调事件
    DateValueCallback? onConfirm,
  }) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context);
    final DateTime now = DateTime.now();
    // handle the range of datetime
    minDateTime ??= DateTime.parse(datePickerMinDatetime);
    maxDateTime ??= DateTime.parse(datePickerMaxDatetime);

    // handle initial DateTime
    initialDateTime ??= now;

    // Set value of date format
    dateFormat = DateTimeFormatter.generateDateFormat(dateFormat, pickerMode);

    Navigator.of(context, rootNavigator: rootNavigator)
        .push(
          _DatePickerRoute(
            isDismissible: isDismissible,
            minDateTime: minDateTime,
            maxDateTime: maxDateTime,
            initialDateTime: initialDateTime,
            dateFormat: dateFormat,
            minuteDivider: minuteDivider,
            pickerMode: pickerMode,
            pickerTitleConfig:
                DxPickerTitleConfig(titleText: title, cancel: Text(cancelTitle, style: themeData.cancelTextStyle)),
            onCancel: onCancel,
            onChange: onChange,
            onConfirm: onConfirm,
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            themeData: themeData,
          ),
        )
        .whenComplete(onClose ?? () {});
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  final DateTime? minDateTime, maxDateTime, initialDateTime;
  final String? dateFormat;
  final DxDateTimePickerMode pickerMode;
  final DxPickerTitleConfig pickerTitleConfig;
  final VoidCallback? onCancel;
  final DateValueCallback? onChange;
  final DateValueCallback? onConfirm;
  final bool? isDismissible;
  final int? minuteDivider;
  final DxPickerThemeData themeData;

  _DatePickerRoute({
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.minuteDivider,
    this.dateFormat,
    this.pickerMode = DxDateTimePickerMode.date,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.barrierLabel,
    this.isDismissible,
    RouteSettings? settings,
    required this.themeData,
  }) : super(settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => isDismissible ?? true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    double height = themeData.pickerHeight;
    if (pickerTitleConfig.title != null || pickerTitleConfig.showTitle) {
      height += themeData.titleHeight;
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(route: this, pickerHeight: height),
    );
  }
}

// ignore: must_be_immutable
class _DatePickerComponent extends StatelessWidget {
  final _DatePickerRoute route;
  final double _pickerHeight;

  const _DatePickerComponent({required this.route, required pickerHeight}) : _pickerHeight = pickerHeight;

  @override
  Widget build(BuildContext context) {
    Widget? pickerWidget;
    switch (route.pickerMode) {
      case DxDateTimePickerMode.date:
        pickerWidget = DxDateWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initialDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          pickerTitleConfig: route.pickerTitleConfig,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DxDateTimePickerMode.time:
        pickerWidget = DxTimeWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          minuteDivider: route.minuteDivider ?? 1,
          pickerTitleConfig: route.pickerTitleConfig,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DxDateTimePickerMode.datetime:
        pickerWidget = DxDateTimeWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          minuteDivider: route.minuteDivider ?? 1,
          pickerTitleConfig: route.pickerTitleConfig,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
    }
    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return ClipRect(
          child: CustomSingleChildLayout(
            delegate: _BottomPickerLayout(route.animation!.value, _pickerHeight),
            child: DxPickerClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(route.themeData.cornerRadius),
                topRight: Radius.circular(route.themeData.cornerRadius),
              ),
              child: pickerWidget,
            ),
          ),
        );
      },
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.contentHeight);

  final double progress;
  final double contentHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: contentHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
