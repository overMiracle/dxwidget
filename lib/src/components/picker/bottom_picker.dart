import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/picker/base/picker_clip_rrect.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:flutter/material.dart';

/// 该picker用于显示自定的底部弹出框: 对话框结构如下：
///              column
///             /      \
///            /       \
///     (透明的上半部)   column(下半部)
///                   /           \
///                  /             \
///            确认取消标题栏       show方法传入的widget(因此传入的contentWidget 需要满足column的布局规则)
/// 显示的视图：标题(标准的)+内容(自定义的content)
/// contentWidget 底部对话框的内容区的widget
/// title 默认文本为 请选择
/// confirm 底部对话框的确认，可以是widget，也可以是String，容错处理是文本 确认
/// cancel 底部对话框的取消，可以是widget，也可以是String， 容错处理是文本 取消
/// onConfirmPressed 点击确定的回调 如果不设置 则关闭picker 需要使用者去关闭picker
/// onCancelPressed 点击取消的回调 如果不设置 则关闭picker
/// barrierDismissible 点击对话框外部 是否取消对话框
class DxBottomPicker {
  static void show(
    BuildContext context, {
    bool barrierDismissible = true,
    bool showTitle = true,
    String title = '请输入',
    dynamic confirm,
    dynamic cancel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    required contentWidget,
  }) {
    final ThemeData theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget pageChild = DxBottomPickerWidget(
          contentWidget: contentWidget,
          confirm: confirm,
          cancel: cancel,
          onConfirmPressed: onConfirm,
          onCancelPressed: onCancel,
          barrierDismissible: barrierDismissible,
          pickerTitleConfig: DxPickerTitleConfig(titleText: title, showTitle: showTitle),
        );
        return Theme(data: theme, child: pageChild);
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder:
          (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      useRootNavigator: true,
    );
  }
}

class DxBottomPickerWidget extends StatefulWidget {
  final Widget contentWidget;
  final dynamic confirm;
  final dynamic cancel;
  final Function()? onConfirmPressed;
  final Function()? onCancelPressed;
  final bool barrierDismissible;
  final DxPickerTitleConfig pickerTitleConfig;
  final DxPickerThemeData? themeData;

  const DxBottomPickerWidget({
    Key? key,
    required this.contentWidget,
    this.confirm,
    this.cancel,
    this.onConfirmPressed,
    this.onCancelPressed,
    this.barrierDismissible = true,
    this.pickerTitleConfig = DxPickerTitleConfig.defaultConfig,
    this.themeData,
  }) : super(key: key);

  @override
  State<DxBottomPickerWidget> createState() => _DxBottomPickerWidgetState();
}

class _DxBottomPickerWidgetState extends State<DxBottomPickerWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late final DxPickerThemeData themeData;

  @override
  void initState() {
    super.initState();
    themeData = DxPickerThemeData().merge(widget.themeData);
    //用于动画
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween(end: Offset.zero, begin: const Offset(0.0, 1.0)).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _controller.reverse();
        return true;
      },
      child: Scaffold(
        backgroundColor: DxStyle.mask,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: _buildTopWidget()),
            _buildBottomWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBottomWidget() {
    return SlideTransition(
      position: _animation as Animation<Offset>,
      child: DxPickerClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(themeData.cornerRadius),
          topRight: Radius.circular(themeData.cornerRadius),
        ),
        child: Container(
          color: Colors.white,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Offstage(
                offstage: !widget.pickerTitleConfig.showTitle,
                child: _buildTitleWidget(),
              ),
              SafeArea(top: false, child: widget.contentWidget),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return DxPickerTitle(
      onCancel: () {
        widget.onCancelPressed?.call();
        _closeDialog();
      },
      onConfirm: () {
        widget.onConfirmPressed?.call();
        _closeDialog();
      },
      pickerTitleConfig: widget.pickerTitleConfig.copyWith(
        cancel: _buildCancelWidget(),
        confirm: _buildConfirmWidget(),
      ),
    );
  }

  Widget? _buildConfirmWidget() {
    Widget? confirmWidget;
    if (widget.confirm is Widget) {
      confirmWidget = widget.confirm;
    } else if (widget.confirm is String) {
      confirmWidget = _buildDefaultConfirm(widget.confirm);
    } else {
      confirmWidget = _buildDefaultConfirm('确认');
    }
    return confirmWidget;
  }

  Widget? _buildCancelWidget() {
    Widget? cancelWidget;
    if (widget.cancel is Widget) {
      cancelWidget = widget.cancel;
    } else if (widget.cancel is String) {
      cancelWidget = _buildDefaultCancel(widget.cancel);
    } else {
      cancelWidget = _buildDefaultCancel('取消');
    }
    return cancelWidget;
  }

  Widget _buildDefaultConfirm(String string) {
    return Text(string, style: themeData.confirmTextStyle, textAlign: TextAlign.right);
  }

  Widget _buildDefaultCancel(String? string) {
    return Text(string ?? '取消', style: themeData.cancelTextStyle, textAlign: TextAlign.right);
  }

  Widget _buildTopWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.barrierDismissible) {
          _closeDialog();
        }
      },
      child: Container(color: const Color(0x33999999)),
    );
  }

  void _closeDialog() {
    Navigator.of(context).maybePop();
  }
}

/// 单元
class DxPickerItem {
  /// 主键
  final int id;

  /// 父id
  final int pid;

  ///展示的名称
  final String name;

  ///是否被选中
  bool isSelect;

  /// 是否禁用
  bool isDisabled;

  /// 子节点
  List<DxPickerItem>? child;

  ///自己添加的扩展
  Map? ext;

  DxPickerItem({
    this.id = 0,
    this.pid = 0,
    this.name = '',
    this.isSelect = false,
    this.isDisabled = false,
    this.child,
    this.ext,
  });

  @override
  String toString() {
    return 'DxPickerItem{id: $id, name: $name, isSelect: $isSelect，isDisabled: $isDisabled}';
  }
}
