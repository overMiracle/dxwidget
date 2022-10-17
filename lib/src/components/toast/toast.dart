import 'dart:async';
import 'dart:math';

import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/toast/index.dart';
import 'package:flutter/material.dart';

class DxToast {
  /// loading style, default [DxToastStyle.dark].
  late DxToastStyle style;

  /// loading indicator type, default [DxToastIndicatorType.fadingCircle].
  late DxToastIndicatorType indicatorType;

  /// loading mask type, default [DxToastMaskType.none].
  late DxToastMaskType maskType;

  /// toast position, default [DxToastPosition.center].
  late DxToastPosition toastPosition;

  /// loading animationStyle, default [DxToastAnimationStyle.opacity].
  late DxToastAnimationStyle animationStyle;

  /// textAlign of status, default [TextAlign.center].
  late TextAlign textAlign;

  /// content padding of loading.
  late EdgeInsets contentPadding;

  /// padding of [status].
  late EdgeInsets textPadding;

  /// size of indicator, default 40.0.
  late double indicatorSize;

  /// radius of loading, default 5.0.
  late double radius;

  /// fontSize of loading, default 15.0.
  late double fontSize;

  /// width of progress indicator, default 2.0.
  late double progressWidth;

  /// width of indicator, default 4.0, only used for [DxToastIndicatorType.ring, DxToastIndicatorType.dualRing].
  late double lineWidth;

  /// display duration of [showSuccess] [showError] [showInfo] [showToast], default 2000ms.
  late Duration displayDuration;

  /// animation duration of indicator, default 200ms.
  late Duration animationDuration;

  /// loading custom animation, default null.
  DxToastAnimation? customAnimation;

  /// textStyle of status, default null.
  TextStyle? textStyle;

  /// color of loading status, only used for [DxToastStyle.custom].
  Color? textColor;

  /// color of loading indicator, only used for [DxToastStyle.custom].
  Color? indicatorColor;

  /// progress color of loading, only used for [DxToastStyle.custom].
  Color? progressColor;

  /// background color of loading, only used for [DxToastStyle.custom].
  Color? backgroundColor;

  /// boxShadow of loading, only used for [DxToastStyle.custom].
  List<BoxShadow>? boxShadow;

  /// mask color of loading, only used for [DxToastMaskType.custom].
  Color? maskColor;

  /// should allow user interactions while loading is displayed.
  bool? userInteractions;

  /// should dismiss on user tap.
  bool? dismissOnTap;

  /// indicator widget of loading
  Widget? indicatorWidget;

  /// success widget of loading
  Widget? successWidget;

  /// error widget of loading
  Widget? errorWidget;

  /// info widget of loading
  Widget? infoWidget;

  Widget? _w;

  DxToastOverlayEntry? overlayEntry;
  GlobalKey<DxToastContainerState>? _key;
  GlobalKey<DxToastProgressState>? _progressKey;
  Timer? _timer;

  Widget? get w => _w;
  GlobalKey<DxToastContainerState>? get key => _key;
  GlobalKey<DxToastProgressState>? get progressKey => _progressKey;

  final List<DxToastStatusCallback> _statusCallbacks = <DxToastStatusCallback>[];

  factory DxToast() => _instance;
  static final DxToast _instance = DxToast._internal();

  DxToast._internal() {
    /// set default value
    style = DxToastStyle.dark;
    indicatorType = DxToastIndicatorType.threeBounce;
    maskType = DxToastMaskType.none;
    toastPosition = DxToastPosition.center;
    animationStyle = DxToastAnimationStyle.opacity;
    textAlign = TextAlign.center;
    indicatorSize = 40.0;
    radius = 5.0;
    fontSize = 14.0;
    progressWidth = 2.0;
    lineWidth = 4.0;
    displayDuration = const Duration(milliseconds: 1000);
    animationDuration = const Duration(milliseconds: 200);
    textPadding = const EdgeInsets.only(bottom: 5.0);
    contentPadding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0);
  }

  static DxToast get instance => _instance;
  static bool get isShow => _instance.w != null;

  /// init DxToast
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, DxToastLoading(child: child));
      } else {
        return DxToastLoading(child: child);
      }
    };
  }

  /// show [status] [duration] [toastPosition] [maskType]
  /// 这个不区分正确还是错误，只是一个简单的文本弹窗
  static Future<void> show(
    String msg, {
    Duration? duration,
    DxToastPosition? toastPosition,
    DxToastMaskType? maskType,
    bool? dismissOnTap,
  }) {
    _instance.style = DxToastStyle.dark;
    return _instance._show(
      status: msg,
      duration: duration ?? DxToastTheme.displayDuration,
      toastPosition: toastPosition ?? DxToastTheme.toastPosition,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  /// success [status] [duration] [maskType]
  /// 成功提示
  static Future<void> success(
    String msg, {
    Duration? duration,
    DxToastMaskType? maskType,
    bool? dismissOnTap,
  }) {
    _instance.style = DxToastStyle.dark;
    Widget w = _instance.successWidget ??
        Icon(Icons.check_circle, color: DxToastTheme.indicatorColor, size: DxToastTheme.indicatorSize);
    return _instance._show(
      status: msg,
      duration: duration ?? DxToastTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// error [status] [duration] [maskType]
  /// 错误提示
  static Future<void> error(
    String msg, {
    Duration? duration = const Duration(milliseconds: 2000),
    DxToastMaskType? maskType,
    bool? dismissOnTap,
  }) {
    _instance.style = DxToastStyle.dark;
    Widget w = _instance.errorWidget ??
        Icon(Icons.cancel, color: DxToastTheme.indicatorColor, size: DxToastTheme.indicatorSize);
    return _instance._show(
      status: msg,
      duration: duration ?? DxToastTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// info [status] [duration] [maskType]
  /// 提示信息
  static Future<void> info(
    String msg, {
    Duration? duration = const Duration(milliseconds: 1500),
    DxToastMaskType? maskType,
    bool? dismissOnTap,
  }) {
    _instance.style = DxToastStyle.dark;
    Widget w =
        _instance.infoWidget ?? Icon(Icons.info, color: DxToastTheme.indicatorColor, size: DxToastTheme.indicatorSize);
    return _instance._show(
      status: msg,
      duration: duration ?? DxToastTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// warning [status] [duration] [maskType]
  /// 提示信息
  static Future<void> warning(
    String msg, {
    Duration? duration = const Duration(milliseconds: 1500),
    DxToastMaskType? maskType,
    bool? dismissOnTap,
  }) {
    _instance.style = DxToastStyle.dark;
    Widget w = _instance.infoWidget ??
        Icon(Icons.report_problem, color: DxToastTheme.indicatorColor, size: DxToastTheme.indicatorSize);
    return _instance._show(
      status: msg,
      duration: duration ?? DxToastTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// show loading with [status] [indicator] [maskType]
  static Future<void> loading({
    String msg = '加载中···',
    Widget? indicator,
    DxToastMaskType? maskType,
    bool? dismissOnTap,
  }) {
    _instance.style = DxToastStyle.dark;
    Widget w = indicator ?? (_instance.indicatorWidget ?? const DxToastLoadingIndicator());
    return _instance._show(
      status: msg,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// show loading with [status] [indicator] [maskType]
  static Future<void> loadingSimple({
    DxToastMaskType? maskType,
    bool? dismissOnTap,
  }) {
    _instance
      ..style = DxToastStyle.custom
      ..boxShadow = <BoxShadow>[]
      ..backgroundColor = Colors.transparent
      ..textColor = Colors.white.withOpacity(0.85);
    return _instance._show(
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: DxLoading(),
    );
  }

  /// show progress with [value] [status] [maskType], value should be 0.0 ~ 1.0.
  static Future<void> progress(
    double value, {
    String? msg,
    DxToastMaskType? maskType,
  }) async {
    assert(
      value >= 0.0 && value <= 1.0,
      'progress value should be 0.0 ~ 1.0',
    );

    if (_instance.style == DxToastStyle.custom) {
      assert(
        _instance.progressColor != null,
        'while loading style is custom, progressColor should not be null',
      );
    }

    _instance.style = DxToastStyle.dark;
    if (_instance.w == null || _instance.progressKey == null) {
      if (_instance.key != null) await dismiss(animation: false);
      GlobalKey<DxToastProgressState> progressKey = GlobalKey<DxToastProgressState>();
      Widget w = DxToastProgress(key: progressKey, value: value);

      _instance._show(
        status: msg,
        maskType: maskType,
        dismissOnTap: false,
        w: w,
      );
      _instance._progressKey = progressKey;
    }
    // update progress
    _instance.progressKey?.currentState?.updateProgress(min(1.0, value));
    // update status
    if (msg != null) _instance.key?.currentState?.updateStatus(msg);
  }

  /// dismiss loading
  static Future<void> dismiss({
    bool animation = true,
  }) {
    // cancel timer
    _instance._cancelTimer();
    return _instance._dismiss(animation);
  }

  /// add loading status callback
  static void addStatusCallback(DxToastStatusCallback callback) {
    if (!_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.add(callback);
    }
  }

  /// remove single loading status callback
  static void removeCallback(DxToastStatusCallback callback) {
    if (_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.remove(callback);
    }
  }

  /// remove all loading status callback
  static void removeAllCallbacks() {
    _instance._statusCallbacks.clear();
  }

  /// show [status] [duration] [toastPosition] [maskType]
  Future<void> _show({
    Widget? w,
    String? status,
    Duration? duration,
    DxToastMaskType? maskType,
    bool? dismissOnTap,
    DxToastPosition? toastPosition,
  }) async {
    assert(
      overlayEntry != null,
      'You should call Dx.init() in your MaterialApp',
    );

    if (style == DxToastStyle.custom) {
      assert(
        backgroundColor != null,
        'while loading style is custom, backgroundColor should not be null',
      );
    }

    maskType ??= _instance.maskType;
    if (maskType == DxToastMaskType.custom) {
      assert(
        maskColor != null,
        'while mask type is custom, maskColor should not be null',
      );
    }

    if (animationStyle == DxToastAnimationStyle.custom) {
      assert(
        customAnimation != null,
        'while animationStyle is custom, customAnimation should not be null',
      );
    }

    toastPosition ??= DxToastPosition.center;
    bool animation = _w == null;
    _progressKey = null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<DxToastContainerState>();
    _w = DxToastContainer(
      key: _key,
      status: status,
      indicator: w,
      animation: animation,
      toastPosition: toastPosition,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      completer: completer,
    );
    completer.future.whenComplete(() {
      _callback(DxToastStatus.show);
      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () async {
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  Future<void> _dismiss(bool animation) async {
    if (key != null && key?.currentState == null) {
      _reset();
      return;
    }

    return key?.currentState?.dismiss(animation).whenComplete(() {
      _reset();
    });
  }

  void _reset() {
    _w = null;
    _key = null;
    _progressKey = null;
    _cancelTimer();
    _markNeedsBuild();
    _callback(DxToastStatus.dismiss);
  }

  void _callback(DxToastStatus status) {
    for (final DxToastStatusCallback callback in _statusCallbacks) {
      callback(status);
    }
  }

  void _markNeedsBuild() => overlayEntry?.markNeedsBuild();

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
