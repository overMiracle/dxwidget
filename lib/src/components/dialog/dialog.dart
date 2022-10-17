import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

enum DxDialogThemeType { normal, roundButton }

enum DxDialogAction { cancel, confirm }

typedef DxDialogBeforeClose = Future<bool> Function(DxDialogAction action);

class DxDialogOption {
  const DxDialogOption({
    this.title = '',
    this.width,
    this.message = '',
    this.messageAlign = TextAlign.center,
    this.theme = DxDialogThemeType.normal,
    this.showConfirmButton = true,
    this.showCancelButton = false,
    this.confirmButtonText = '',
    this.confirmButtonColor,
    this.cancelButtonText = '',
    this.cancelButtonColor,
    this.overlayColor,
    this.closeOnClickOverlay = false,
    this.beforeClose,
    this.transitionBuilder = kDxDialogBounceTransition,
  });

  final String title;
  final double? width;
  final String message;
  final TextAlign messageAlign;
  final DxDialogThemeType theme;
  final bool showConfirmButton;
  final bool showCancelButton;
  final String confirmButtonText;
  final Color? confirmButtonColor;
  final String cancelButtonText;
  final Color? cancelButtonColor;
  final Color? overlayColor;
  final bool closeOnClickOverlay;
  final DxDialogBeforeClose? beforeClose;
  final DxTransitionBuilder? transitionBuilder;

  DxDialogOption merge(DxDialogOption? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      title: other.title,
      width: other.width,
      message: message,
      messageAlign: messageAlign,
      theme: theme,
      showConfirmButton: showConfirmButton,
      showCancelButton: showCancelButton,
      confirmButtonText: confirmButtonText,
      confirmButtonColor: confirmButtonColor,
      cancelButtonText: cancelButtonText,
      cancelButtonColor: cancelButtonColor,
      overlayColor: overlayColor,
      closeOnClickOverlay: closeOnClickOverlay,
      beforeClose: beforeClose,
      transitionBuilder: transitionBuilder,
    );
  }

  DxDialogOption copyWith({
    String? title,
    double? width,
    String? message,
    TextAlign? messageAlign,
    DxDialogThemeType? theme,
    bool? showConfirmButton,
    bool? showCancelButton,
    String? confirmButtonText,
    Color? confirmButtonColor,
    String? cancelButtonText,
    Color? cancelButtonColor,
    Color? overlayColor,
    bool? closeOnClickOverlay,
    DxDialogBeforeClose? beforeClose,
    DxTransitionBuilder? transitionBuilder,
  }) {
    return DxDialogOption(
      title: title ?? this.title,
      width: width ?? this.width,
      message: message ?? this.message,
      messageAlign: messageAlign ?? this.messageAlign,
      theme: theme ?? this.theme,
      showConfirmButton: showConfirmButton ?? this.showConfirmButton,
      showCancelButton: showCancelButton ?? this.showCancelButton,
      confirmButtonText: confirmButtonText ?? this.confirmButtonText,
      confirmButtonColor: confirmButtonColor ?? this.confirmButtonColor,
      cancelButtonText: cancelButtonText ?? this.cancelButtonText,
      cancelButtonColor: cancelButtonColor ?? this.cancelButtonColor,
      overlayColor: overlayColor ?? this.overlayColor,
      closeOnClickOverlay: closeOnClickOverlay ?? this.closeOnClickOverlay,
      beforeClose: beforeClose ?? this.beforeClose,
      transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    );
  }
}

/// 弹出层
class DxDialog {
  const DxDialog._();

  static Future<DxDialogAction?> alert(
    BuildContext context, {

    /// 标题
    String? title,

    /// 弹窗宽度
    double? width,

    /// 文本内容，支持通过 `\n` 换行
    String? message,

    /// 内容水平对齐方式，可选值为 `left` `right` `center`
    TextAlign? messageAlign,

    /// 式风格，可选值为 `roundButton` `normal`
    DxDialogThemeType? theme,

    /// 是否展示确认按钮
    bool? showConfirmButton,

    /// 是否展示取消按钮
    bool? showCancelButton,

    /// 确认按钮文案
    String? confirmButtonText,

    /// 确认按钮颜色
    Color? confirmButtonColor,

    /// 取消按钮文案
    String? cancelButtonText,

    /// 取消按钮颜色
    Color? cancelButtonColor,

    /// 自定义遮罩层样式
    Color? overlayColor,

    /// 是否在点击遮罩层后关闭
    bool? closeOnClickOverlay,

    /// 关闭前判断, `return false` 不关闭
    DxDialogBeforeClose? beforeClose,

    /// 动画
    DxTransitionBuilder? transitionBuilder,

    /// 点击确认按钮时触发
    VoidCallback? onConfirm,

    /// 点击取消按钮时触发
    VoidCallback? onCancel,

    /// 打开面板时触发
    VoidCallback? onOpen,

    /// 关闭面板时触发
    VoidCallback? onClose,

    /// 打开面板且动画结束后触发
    VoidCallback? onOpened,

    /// 关闭面板且动画结束后触发
    VoidCallback? onClosed,

    /// 自定义内容
    WidgetBuilder? builder,

    /// 自定义标题
    WidgetBuilder? titleBuilder,

    /// 自定义底部按钮区域
    WidgetBuilder? footerBuilder,
  }) async {
    DxDialog.isInstanceShow = true;
    final DxDialogThemeData themeData = DxDialogTheme.of(context);
    final DxDialogOption defaultOptions = DxDialog.currentOptions;
    final DxDialogAction? action = await showDxPopup<DxDialogAction>(
      context,
      builder: (BuildContext context) {
        return DxDialogWidget(
          title: title ?? defaultOptions.title,
          width: width ?? defaultOptions.width,
          message: message ?? defaultOptions.message,
          messageAlign: messageAlign ?? defaultOptions.messageAlign,
          theme: theme ?? defaultOptions.theme,
          showConfirmButton: showConfirmButton ?? defaultOptions.showConfirmButton,
          showCancelButton: showCancelButton ?? defaultOptions.showCancelButton,
          confirmButtonText: confirmButtonText ?? defaultOptions.confirmButtonText,
          confirmButtonColor: confirmButtonColor ?? defaultOptions.confirmButtonColor,
          cancelButtonText: cancelButtonText ?? defaultOptions.cancelButtonText,
          cancelButtonColor: cancelButtonColor ?? defaultOptions.cancelButtonColor,
          beforeClose: beforeClose ?? defaultOptions.beforeClose,
          onConfirm: onConfirm,
          onCancel: onCancel,
          titleSlot: titleBuilder?.call(context),
          footerSlot: footerBuilder?.call(context),
          child: builder?.call(context),
        );
      },
      position: DxPopupPosition.center,
      overlayColor: overlayColor ?? defaultOptions.overlayColor,
      closeOnClickOverlay: closeOnClickOverlay ?? defaultOptions.closeOnClickOverlay,
      transitionBuilder: transitionBuilder ?? defaultOptions.transitionBuilder,
      backgroundColor: themeData.backgroundColor,
      borderRadius: BorderRadius.circular(themeData.borderRadius),
      round: true,
      onOpen: onOpen,
      onClose: onClose,
      onOpened: onOpened,
      onClosed: onClosed,
    );
    DxDialog.isInstanceShow = false;
    return action;
  }

  static Future<DxDialogAction?> confirm(
    BuildContext context, {

    /// 标题
    String? title,

    /// 弹窗宽度
    double? width,

    /// 文本内容，支持通过 `\n` 换行
    String? message,

    /// 内容水平对齐方式，可选值为 `left` `right` `center`
    TextAlign? messageAlign,

    /// 式风格，可选值为 `roundButton` `normal`
    DxDialogThemeType? theme,

    /// 是否展示确认按钮
    bool? showConfirmButton,

    /// 是否展示取消按钮
    bool? showCancelButton,

    /// 确认按钮文案
    String? confirmButtonText,

    /// 确认按钮颜色
    Color? confirmButtonColor,

    /// 取消按钮文案
    String? cancelButtonText,

    /// 取消按钮颜色
    Color? cancelButtonColor,

    /// 自定义遮罩层样式
    Color? overlayColor,

    /// 是否在点击遮罩层后关闭
    bool? closeOnClickOverlay,

    /// 关闭前判断, `return false` 不关闭
    DxDialogBeforeClose? beforeClose,

    /// 动画
    DxTransitionBuilder? transitionBuilder,

    /// 点击确认按钮时触发
    VoidCallback? onConfirm,

    /// 点击取消按钮时触发
    VoidCallback? onCancel,

    /// 打开面板时触发
    VoidCallback? onOpen,

    /// 关闭面板时触发
    VoidCallback? onClose,

    /// 打开面板且动画结束后触发
    VoidCallback? onOpened,

    /// 关闭面板且动画结束后触发
    VoidCallback? onClosed,

    /// 自定义内容
    WidgetBuilder? builder,

    /// 自定义标题
    WidgetBuilder? titleBuilder,

    /// 自定义底部按钮区域
    WidgetBuilder? footerBuilder,
  }) async {
    return alert(
      context,
      title: title,
      width: width,
      message: message,
      messageAlign: messageAlign,
      theme: theme,
      showConfirmButton: showConfirmButton,
      showCancelButton: showCancelButton ?? true,
      confirmButtonText: confirmButtonText,
      confirmButtonColor: confirmButtonColor,
      cancelButtonText: cancelButtonText,
      cancelButtonColor: cancelButtonColor,
      overlayColor: overlayColor,
      closeOnClickOverlay: closeOnClickOverlay,
      beforeClose: beforeClose,
      transitionBuilder: transitionBuilder,
      onConfirm: onConfirm,
      onCancel: onCancel,
      onOpen: onOpen,
      onClose: onClose,
      onOpened: onOpened,
      onClosed: onClosed,
      builder: builder,
      titleBuilder: titleBuilder,
      footerBuilder: footerBuilder,
    );
  }

  static bool isInstanceShow = false;

  static void close(BuildContext context) {
    if (isInstanceShow) {
      Navigator.of(context).maybePop();
    }
  }

  static DxDialogOption currentOptions = const DxDialogOption();

  static void setDefaultOptions(DxDialogOption option) {
    currentOptions = currentOptions.merge(option);
  }

  static void resetDefaultOptions(DxDialogOption option) {
    currentOptions = const DxDialogOption();
  }
}

Widget kDxDialogBounceTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) {
  final Animation<double> curve = animation.drive(Tween<double>(begin: 0.7, end: 0.9));

  return FadeTransition(opacity: animation, child: ScaleTransition(scale: curve, child: child));
}

class DxDialogWidget extends StatefulWidget {
  const DxDialogWidget({
    Key? key,
    this.title = '',
    this.width,
    this.message = '',
    this.messageAlign = TextAlign.left,
    this.theme = DxDialogThemeType.normal,
    this.showConfirmButton = true,
    this.showCancelButton = false,
    this.confirmButtonText = '',
    this.confirmButtonColor,
    this.cancelButtonText = '',
    this.cancelButtonColor,
    this.beforeClose,
    this.onConfirm,
    this.onCancel,
    this.child,
    this.titleSlot,
    this.footerSlot,
  }) : super(key: key);

  /// 标题
  final String title;

  /// 弹窗宽度
  final double? width;

  /// 文本内容，支持通过 `\n` 换行
  final String message;

  /// 内容水平对齐方式，可选值为 `left` `right` `center`
  final TextAlign messageAlign;

  /// 式风格，可选值为 `roundButton` `normal`
  final DxDialogThemeType theme;

  /// 是否展示确认按钮
  final bool showConfirmButton;

  /// 是否展示取消按钮
  final bool showCancelButton;

  /// 确认按钮文案
  final String confirmButtonText;

  /// 确认按钮颜色
  final Color? confirmButtonColor;

  /// 取消按钮文案
  final String cancelButtonText;

  /// 取消按钮颜色
  final Color? cancelButtonColor;

  /// 关闭前的回调函数，返回 `false` 可阻止关闭
  final DxDialogBeforeClose? beforeClose;

  /// 点击确认按钮时触发
  final VoidCallback? onConfirm;

  /// 点击取消按钮时触发
  final VoidCallback? onCancel;

  /// 自定义内容
  final Widget? child;

  /// 自定义标题
  final Widget? titleSlot;

  /// 自定义底部按钮区域
  final Widget? footerSlot;

  @override
  State<DxDialogWidget> createState() => _DxDialogWidgetState();
}

class _DxDialogWidgetState extends State<DxDialogWidget> {
  final ValueNotifier<bool> confirmLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> cancelLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final DxDialogThemeData themeData = DxDialogTheme.of(context);
    final double winWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: widget.width ?? (winWidth < 321.0 ? themeData.smallScreenWidthFactor * winWidth : themeData.width),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildTitle(themeData),
          _buildContent(themeData),
          _buildFooter(themeData),
        ],
      ),
    );
  }

  bool get hasTitle => widget.titleSlot != null || widget.title.isNotEmpty;

  Widget _buildTitle(DxDialogThemeData themeData) {
    final bool isolated = widget.message.isEmpty && widget.child == null;

    return Visibility(
      visible: hasTitle,
      child: Container(
        padding: isolated ? themeData.headerIsolatedPadding : EdgeInsets.only(top: themeData.headerPaddingTop),
        alignment: Alignment.center,
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: themeData.fontSize,
            color: DxStyle.textColor,
            fontWeight: themeData.headerFontWeight,
            height: themeData.headerLineHeight,
          ),
          child: widget.titleSlot ?? Text(widget.title),
        ),
      ),
    );
  }

  Widget _buildContent(DxDialogThemeData themeData) {
    if (widget.child != null) {
      return widget.child!;
    }
    final double winHeight = MediaQuery.of(context).size.height;

    return Visibility(
      visible: widget.message.isNotEmpty,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: themeData.messageMaxHeight * winHeight,
        ),
        padding: EdgeInsets.only(
          top: 20.0,
          bottom: isRoundTheme ? DxStyle.paddingMd : 26.0,
          left: themeData.messagePadding,
          right: themeData.messagePadding,
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            fontSize: themeData.messageFontSize,
            height: themeData.messageLineHeight,
            color: hasTitle ? themeData.hasTitleMessageTextColor : null,
          ),
          textAlign: widget.messageAlign,
        ),
      ),
    );
  }

  bool get isRoundTheme => widget.theme == DxDialogThemeType.roundButton;

  Widget _buildButtons(DxDialogThemeData themeData) {
    return Container(
      height: themeData.buttonHeight,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: DxStyle.gray3, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Visibility(
            visible: widget.showCancelButton,
            child: Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: cancelLoading,
                builder: (BuildContext context, bool loading, Widget? child) {
                  return DxButton(
                    type: DxButtonType.normal,
                    hasBorder: false,
                    height: 56,
                    title: widget.cancelButtonText.isNotEmpty ? widget.cancelButtonText : '取消',
                    titleColor: widget.cancelButtonColor,
                    loading: loading,
                    onClick: _onCancel,
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: widget.showCancelButton,
            child: const VerticalDivider(width: 1.0, color: DxStyle.borderColor),
          ),
          Visibility(
            visible: widget.showConfirmButton,
            child: Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: confirmLoading,
                builder: (BuildContext context, bool loading, Widget? child) {
                  return DxButton(
                    type: DxButtonType.normal,
                    hasBorder: false,
                    height: 56,
                    title: widget.confirmButtonText.isNotEmpty ? widget.confirmButtonText : '确定',
                    titleColor: widget.confirmButtonColor ?? themeData.confirmButtonTextColor,
                    loading: loading,
                    onClick: _onConfirm,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRoundButtons(DxDialogThemeData themeData) {
    return Container(
      padding: const EdgeInsets.only(
        top: DxStyle.paddingXs,
        left: DxStyle.paddingLg,
        right: DxStyle.paddingLg,
        bottom: DxStyle.paddingMd,
      ),
      child: DxActionBar(
        children: <Widget>[
          Visibility(
            visible: widget.showCancelButton,
            child: ValueListenableBuilder<bool>(
              valueListenable: cancelLoading,
              builder: (BuildContext context, bool loading, Widget? child) {
                return DxActionBarButton(
                  type: DxButtonType.warning,
                  title: widget.cancelButtonText.isNotEmpty ? widget.cancelButtonText : '取消',
                  color: widget.cancelButtonColor,
                  loading: loading,
                  onClick: _onCancel,
                  height: themeData.roundButtonHeight,
                );
              },
            ),
          ),
          Visibility(
            visible: widget.showConfirmButton,
            child: ValueListenableBuilder<bool>(
              valueListenable: confirmLoading,
              builder: (BuildContext context, bool loading, Widget? child) {
                return DxActionBarButton(
                  type: DxButtonType.danger,
                  title: widget.confirmButtonText.isNotEmpty ? widget.confirmButtonText : '确认',
                  color: widget.confirmButtonColor,
                  loading: loading,
                  onClick: _onConfirm,
                  height: themeData.roundButtonHeight,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(DxDialogThemeData themeData) {
    if (widget.footerSlot != null) {
      return widget.footerSlot!;
    }
    return widget.theme == DxDialogThemeType.roundButton ? _buildRoundButtons(themeData) : _buildButtons(themeData);
  }

  void _close(DxDialogAction action) {
    Navigator.of(context).maybePop(action);
  }

  void _onConfirm() => _getActionHandler(DxDialogAction.confirm);

  void _onCancel() => _getActionHandler(DxDialogAction.cancel);

  Future<void> _getActionHandler(DxDialogAction action) async {
    switch (action) {
      case DxDialogAction.confirm:
        widget.onConfirm?.call();
        break;
      case DxDialogAction.cancel:
        widget.onCancel?.call();
        break;
    }

    if (widget.beforeClose != null) {
      setLoading(action, true);

      final bool flag = await widget.beforeClose!(action);

      if (flag) {
        _close(action);
        setLoading(action, false);
      } else {
        setLoading(action, false);
      }
    } else {
      _close(action);
    }
  }

  void setLoading(DxDialogAction action, bool loading) {
    switch (action) {
      case DxDialogAction.confirm:
        confirmLoading.value = loading;
        break;
      case DxDialogAction.cancel:
        cancelLoading.value = loading;
        break;
    }
  }
}
