import 'dart:ui' as ui;

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 弹窗位置集合
enum DxPopupPosition { top, bottom, right, left, center }

/// 关闭图标位置
enum DxPopupCloseIconPosition { topLeft, topRight, bottomLeft, bottomRight }

/// DxPopup 列布局
/// 弹出层容器，用于展示弹窗、信息提示等内容，支持多个弹出层叠加展示。
Future<T?> showDxPopup<T extends Object?>(
  BuildContext context, {
  DxPopupPosition position = DxPopupPosition.center,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  Color? overlayColor,
  Duration? duration,
  bool round = false,
  bool closeOnClickOverlay = true,
  bool closeable = false,
  IconData closeIconName = Icons.close,
  String? closeIconUrl,
  DxPopupCloseIconPosition closeIconPosition = DxPopupCloseIconPosition.topRight,
  DxTransitionBuilder? transitionBuilder,
  bool safeAreaInsetBottom = false,
  VoidCallback? onClickCloseIcon,
  VoidCallback? onClick,
  VoidCallback? onOpen,
  VoidCallback? onClose,
  VoidCallback? onOpened,
  VoidCallback? onClosed,
  required WidgetBuilder builder,
}) {
  final DxPopupThemeData popupThemeData = DxPopupTheme.of(context);
  final Color overlayThemeBackgroundColor = DxTheme.of(context).overlayBackgroundColor;

  return Navigator.of(context, rootNavigator: true).push<T>(
    _DxPopupRoute<T>(
      builder: (BuildContext context) {
        Widget content = builder(context);
        if (closeable) {
          content = _DxCloseableScope(
            closeIconName: closeIconName,
            closeIconUrl: closeIconUrl,
            closeIconPosition: closeIconPosition,
            onClickCloseIcon: onClickCloseIcon,
            child: content,
          );
        }

        return _DxPopupWrapper(
          position: position,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          round: round,
          safeAreaInsetBottom: safeAreaInsetBottom,
          child: content,
        );
      },
      // popupPosition: _getPopupAlign(position),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: closeOnClickOverlay,
      barrierColor: overlayColor ?? overlayThemeBackgroundColor,

      transitionDuration: duration ?? popupThemeData.transitionDuration,
      transitionBuilder: transitionBuilder ?? _getPopupTransition(position),
      onTransitionRouteEnter: onOpened,
      onTransitionRouteLeave: onClosed,
      onOpen: onOpen,
      onClose: onClose,
    ),
  );
}

class _DxPopupWrapper extends StatelessWidget {
  const _DxPopupWrapper({
    Key? key,
    required this.position,
    this.backgroundColor,
    this.borderRadius,
    required this.round,
    required this.safeAreaInsetBottom,
    this.onClick,
    this.child,
  }) : super(key: key);

  // ****************** Props ******************

  /// 弹出位置，可选值为 `top` `bottom` `right` `left` `center`
  final DxPopupPosition position;

  /// 弹窗的样式
  final Color? backgroundColor;

  /// 圆角大小
  final BorderRadius? borderRadius;

  /// 是否显示圆角
  final bool round;

  /// 是否开启底部安全区适配
  final bool safeAreaInsetBottom;

  /// 点击事件
  final VoidCallback? onClick;

  /// 内容
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData win = MediaQuery.of(context);
    final DxPopupThemeData themeData = DxPopupTheme.of(context);

    return Align(
      alignment: _popupAlign,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onClick?.call(),
        child: Material(
          color: backgroundColor ?? themeData.backgroundColor,
          borderRadius: round ? _getRoundRadius(themeData, position) : BorderRadius.zero,
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: needWidthFilled ? win.size.width : null,
            height: needHeightFilled ? win.size.height : null,
            padding: safeAreaInsetBottom ? EdgeInsets.only(bottom: win.padding.bottom) : null,
            child: child,
          ),
        ),
      ),
    );
  }

  bool get needWidthFilled => position == DxPopupPosition.top || position == DxPopupPosition.bottom;

  bool get needHeightFilled => position == DxPopupPosition.left || position == DxPopupPosition.right;

  Alignment get _popupAlign {
    switch (position) {
      case DxPopupPosition.top:
        return Alignment.topCenter;
      case DxPopupPosition.bottom:
        return Alignment.bottomCenter;
      case DxPopupPosition.right:
        return Alignment.centerRight;
      case DxPopupPosition.left:
        return Alignment.centerLeft;
      case DxPopupPosition.center:
        return Alignment.center;
    }
  }

  BorderRadius _getRoundRadius(DxPopupThemeData themeData, DxPopupPosition position) {
    if (borderRadius != null) {
      return borderRadius!;
    }

    final ui.Radius radius = Radius.circular(themeData.roundBorderRadius);
    switch (position) {
      case DxPopupPosition.top:
        return BorderRadius.only(bottomLeft: radius, bottomRight: radius);
      case DxPopupPosition.bottom:
        return BorderRadius.only(topLeft: radius, topRight: radius);
      case DxPopupPosition.right:
        return BorderRadius.only(topLeft: radius, bottomLeft: radius);
      case DxPopupPosition.left:
        return BorderRadius.only(topRight: radius, bottomRight: radius);
      case DxPopupPosition.center:
        return BorderRadius.all(radius);
    }
  }
}

class _DxCloseableScope extends StatelessWidget {
  const _DxCloseableScope({
    Key? key,
    required this.closeIconName,
    this.closeIconUrl,
    required this.closeIconPosition,
    this.onClickCloseIcon,
    this.child,
  }) : super(key: key);

  // ****************** Props ******************

  /// 关闭图标名称
  final IconData closeIconName;

  /// 关闭图片链接
  final String? closeIconUrl;

  /// 关闭图标位置，可选值为 `topLeft` `topRight` `bottomLeft` `bottomRight`
  final DxPopupCloseIconPosition closeIconPosition;

  // ****************** Events ******************
  /// 点击关闭图标时触发
  final GestureTapCallback? onClickCloseIcon;
  // ****************** Slots ******************
  /// 内容
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final DxPopupThemeData themeData = DxPopupTheme.of(context);
    return Stack(
      children: <Widget>[
        child ?? const SizedBox.shrink(),
        _buildCloseIcon(context, themeData),
      ],
    );
  }

  Widget _buildCloseIcon(BuildContext context, DxPopupThemeData themeData) {
    final Widget icon = GestureDetector(
      onTap: () {
        onClickCloseIcon?.call();
        Navigator.of(context).maybePop();
      },
      child: Icon(
        closeIconName,
        // color: active ? themeData.closeIconActiveColor : themeData.closeIconColor,
        color: themeData.closeIconActiveColor,
      ),
    );

    switch (closeIconPosition) {
      case DxPopupCloseIconPosition.topLeft:
        return Positioned(
          top: themeData.closeIconMargin,
          left: themeData.closeIconMargin,
          child: icon,
        );
      case DxPopupCloseIconPosition.topRight:
        return Positioned(
          top: themeData.closeIconMargin,
          right: themeData.closeIconMargin,
          child: icon,
        );
      case DxPopupCloseIconPosition.bottomLeft:
        return Positioned(
          bottom: themeData.closeIconMargin,
          left: themeData.closeIconMargin,
          child: icon,
        );
      case DxPopupCloseIconPosition.bottomRight:
        return Positioned(
          bottom: themeData.closeIconMargin,
          right: themeData.closeIconMargin,
          child: icon,
        );
    }
  }
}

class _DxPopupRoute<T extends Object?> extends PopupRoute<T> {
  _DxPopupRoute({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    String? barrierLabel,
    required Color barrierColor,
    required Duration transitionDuration,
    RouteSettings? settings,
    required this.transitionBuilder,
    this.onOpen,
    this.onClose,
    this.onTransitionRouteEnter,
    this.onTransitionRouteLeave,
  })  : _builder = builder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        super(settings: settings);

  final WidgetBuilder _builder;

  final VoidCallback? onTransitionRouteEnter;
  final VoidCallback? onTransitionRouteLeave;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  final DxTransitionBuilder transitionBuilder;

  void _onDxPopupTransitionChange(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        onTransitionRouteLeave?.call();
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        onTransitionRouteEnter?.call();
        break;
    }
  }

  @override
  void install() {
    onOpen?.call();
    super.install();
    controller?.addStatusListener(_onDxPopupTransitionChange);
  }

  @override
  void dispose() {
    controller?.removeStatusListener(_onDxPopupTransitionChange);
    super.dispose();
    onClose?.call();
  }

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: DxTransitionVisible(
        animation: animation,
        transitionBuilder: transitionBuilder,
        child: _builder(context),
      ),
    );
  }

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: DxStyle.animationTimingFunctionEnter,
      reverseCurve: DxStyle.animationTimingFunctionLeave,
    );
  }
}

DxTransitionBuilder _getPopupTransition(DxPopupPosition position) {
  switch (position) {
    case DxPopupPosition.top:
      return DxPopupTransition.slideToBottom;
    case DxPopupPosition.bottom:
      return DxPopupTransition.slideToTop;
    case DxPopupPosition.right:
      return DxPopupTransition.slideToLeft;
    case DxPopupPosition.left:
      return DxPopupTransition.slideToRight;
    default:
      return DxPopupTransition.scale;
  }
}

// ignore: avoid_classes_with_only_static_members
class DxPopupTransition {
  static Widget slideToBottom(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget slideToTop(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget slideToLeft(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget slideToRight(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget scale(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return Transform.scale(scale: animation.value, child: child);
  }
}
