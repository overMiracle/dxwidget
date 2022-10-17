import 'package:dxwidget/src/components/picker/base/picker_clip_rrect.dart';
import 'package:dxwidget/src/components/picker/base/picker_title_config.dart';
import 'package:dxwidget/src/components/picker/date_range/constants.dart';
import 'package:dxwidget/src/components/picker/date_range/date_range_widget.dart';
import 'package:dxwidget/src/components/picker/date_range/date_time_formatter.dart';
import 'package:dxwidget/src/components/picker/date_range/time_range_widget.dart';
import 'package:dxwidget/src/theme/components/picker/picker.dart';
import 'package:flutter/material.dart';

/// 时间范围选择展示模式
enum DxDateRangePickerMode {
  /// 日期模式，仅展示到 月、日
  date,

  /// 时间模式，仅展示到 时、分、秒
  time,
}

/// 从底部弹出时间范围选择 Picker
/// 参考网址：https://bruno.ke.com/page/v2.2.0/widgets/brn-date-range-picker
class DxDateRangePicker {
  /// isDismissible[bool]点击背景是否自动消失
  /// minDateTime: [DateTime] 可选的最小时间
  /// maxDateTime: [DateTime] 可选的最大时间
  /// isLimitTimeRange: [bool] 是否显示开始时间必须小于等于结束时间，默认为 true，仅在 [DxDateRangePickerMode] 为 simple 时生效
  /// initialDateTime: [DateTime] 初始化选中时间
  /// dateFormat: [String] 时间展示格式，如：yyyy 年 MM 月 dd 日
  /// minuteDivider：[int] 分钟展示间隔，默认值为 1
  /// pickerMode: [DxDateRangePickerMode] 展示的 mode: date(DatePicker)、simple(TimePicker)
  /// onCancel: [DateVoidCallback] 取消回调
  /// onClose: [DateVoidCallback] 关闭回调
  /// onChange: [DateValueCallback] 时间变化回调
  /// onConfirm: [DateValueCallback] 点击确认的回调
  /// pickerTitleConfig: [DxPickerTitleConfig] Picker title 配置
  /// themeData: [DxPickerConfig] 主题配置
  static void show(
    BuildContext context, {
    String? title,
    bool isDismissible = true,
    DateTime? minDateTime,
    DateTime? maxDateTime,
    bool isLimitTimeRange = true,
    DateTime? initialStartDateTime,
    DateTime? initialEndDateTime,
    String? dateFormat,
    int minuteDivider = 1,
    DxDateRangePickerMode pickerMode = DxDateRangePickerMode.date,
    DateVoidCallback? onCancel,
    DateVoidCallback? onClose,
    DateRangeValueCallback? onChange,
    DateRangeValueCallback? onConfirm,
  }) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context);
    final DateTime now = DateTime.now();
    // handle the range of datetime
    minDateTime ??= now;
    maxDateTime ??= DateTime.parse(datePickerMaxDatetime);
    // handle initial DateTime
    initialStartDateTime ??= now;

    // Set value of date format
    dateFormat = DateTimeFormatter.generateDateRangePickerFormat(dateFormat, pickerMode);
    Navigator.push(
      context,
      _DatePickerRoute(
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
        isLimitTimeRange: isLimitTimeRange,
        initialStartDateTime: initialStartDateTime,
        initialEndDateTime: initialEndDateTime,
        dateFormat: dateFormat,
        minuteDivider: minuteDivider,
        pickerMode: pickerMode,
        pickerTitleConfig: title == null ? DxPickerTitleConfig.defaultConfig : DxPickerTitleConfig(titleText: title),
        onCancel: onCancel,
        onChange: onChange,
        onConfirm: onConfirm,
        isDismissible: isDismissible,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        themeData: themeData,
      ),
    ).whenComplete(onClose ?? () {});
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  final DateTime? minDateTime, maxDateTime, initialStartDateTime, initialEndDateTime;
  final bool isLimitTimeRange;
  final String? dateFormat;
  final DxDateRangePickerMode pickerMode;
  final DxPickerTitleConfig pickerTitleConfig;
  final VoidCallback? onCancel;
  final DateRangeValueCallback? onChange;
  final DateRangeValueCallback? onConfirm;
  final int minuteDivider;
  final bool? isDismissible;
  final DxPickerThemeData themeData;

  _DatePickerRoute({
    this.minDateTime,
    this.maxDateTime,
    this.isLimitTimeRange = true,
    this.initialStartDateTime,
    this.initialEndDateTime,
    this.minuteDivider = 1,
    this.dateFormat,
    this.pickerMode = DxDateRangePickerMode.date,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.barrierLabel,
    this.isDismissible,
    required this.themeData,
    RouteSettings? settings,
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
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
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

class _DatePickerComponent extends StatelessWidget {
  final _DatePickerRoute route;
  final double _pickerHeight;

  const _DatePickerComponent({required this.route, required pickerHeight}) : _pickerHeight = pickerHeight;

  @override
  Widget build(BuildContext context) {
    final DxPickerThemeData themeData = DxPickerTheme.of(context);
    Widget? pickerWidget;
    switch (route.pickerMode) {
      case DxDateRangePickerMode.date:
        pickerWidget = DxDateRangeWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initialStartDateTime: route.initialStartDateTime,
          initialEndDateTime: route.initialEndDateTime,
          dateFormat: route.dateFormat,
          pickerTitleConfig: route.pickerTitleConfig,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DxDateRangePickerMode.time:
        pickerWidget = DxTimeRangeWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          isLimitTimeRange: route.isLimitTimeRange,
          initialStartDateTime: route.initialStartDateTime,
          initialEndDateTime: route.initialEndDateTime,
          minuteDivider: route.minuteDivider,
          dateFormat: route.dateFormat,
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
                topLeft: Radius.circular(themeData.cornerRadius),
                topRight: Radius.circular(themeData.cornerRadius),
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
