import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

///版本更新加提示框
///github地址：https://github.com/xuexiangjys/flutter_update_dialog
class DxUpdateDialog {
  bool _isShowing = false;
  late BuildContext _context;
  late DxUpdateWidget _widget;

  DxUpdateDialog(
    BuildContext context, {
    required String title,
    required String updateContent,
    double titleTextSize = 16.0,
    double contentTextSize = 14.0,
    double buttonTextSize = 14.0,
    double progress = -1.0,
    Image? topImage,
    double extraHeight = 5.0,
    double radius = 8.0,
    Color progressColor = const Color(0xFF4078F4),
    bool isForce = false,
    String? updateButtonText,
    String? ignoreButtonText,
    VoidCallback? onClose,
    required VoidCallback onUpdate,
  }) {
    _context = context;
    _widget = DxUpdateWidget(
      title: title,
      updateContent: updateContent,
      onUpdate: onUpdate,
      titleTextSize: titleTextSize,
      contentTextSize: contentTextSize,
      buttonTextSize: buttonTextSize,
      progress: progress,
      topImage: topImage,
      extraHeight: extraHeight,
      radius: radius,
      progressColor: progressColor,
      updateButtonText: updateButtonText ?? '更新',
      onClose: onClose ?? () => dismiss(),
    );
  }

  /// 显示弹窗
  Future<bool> show() {
    try {
      if (isShowing()) {
        return Future<bool>.value(false);
      }
      showGeneralDialog<bool>(
        context: _context,
        barrierDismissible: false,
        transitionBuilder: (_, a1, a2, child) => Transform.scale(scale: a1.value, child: child),
        pageBuilder: (_, __, ___) => WillPopScope(onWillPop: () => Future<bool>.value(false), child: _widget),
      );
      _isShowing = true;
      return Future<bool>.value(true);
    } catch (err) {
      _isShowing = false;
      return Future<bool>.value(false);
    }
  }

  /// 隐藏弹窗
  Future<bool> dismiss() {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.pop(_context);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } catch (err) {
      return Future<bool>.value(false);
    }
  }

  /// 是否显示
  bool isShowing() => _isShowing;

  /// 更新进度
  void update(double progress) {
    if (isShowing()) {
      _widget.update(progress);
    }
  }

  /// 显示版本更新提示框
  static DxUpdateDialog showUpdate(
    BuildContext context, {
    double width = 0.0,
    required String title,
    required String updateContent,
    required VoidCallback onUpdate,
    double titleTextSize = 16.0,
    double contentTextSize = 14.0,
    double buttonTextSize = 14.0,
    double progress = -1.0,
    Color progressColor = const Color(0xFF4078F4),
    Image? topImage,
    double extraHeight = 5.0,
    double radius = 8.0,
    bool enableIgnore = false,
    VoidCallback? onClose,
    String? updateButtonText,
    String? ignoreButtonText,
    bool isForce = false,
  }) {
    final DxUpdateDialog dialog = DxUpdateDialog(
      context,
      title: title,
      updateContent: updateContent,
      onUpdate: onUpdate,
      titleTextSize: titleTextSize,
      contentTextSize: contentTextSize,
      buttonTextSize: buttonTextSize,
      progress: progress,
      topImage: topImage,
      extraHeight: extraHeight,
      radius: radius,
      progressColor: progressColor,
      updateButtonText: updateButtonText,
      ignoreButtonText: ignoreButtonText,
      onClose: onClose,
    );
    dialog.show();
    return dialog;
  }
}

// ignore: must_be_immutable
class DxUpdateWidget extends StatefulWidget {
  /// 对话框的宽度
  final double width;

  /// 升级标题
  final String title;

  /// 更新内容
  final String updateContent;

  /// 标题文字的大小
  final double titleTextSize;

  /// 更新文字内容的大小
  final double contentTextSize;

  /// 按钮文字的大小
  final double buttonTextSize;

  /// 顶部图片
  final Widget? topImage;

  /// 拓展高度(适配顶部图片高度不一致的情况）
  final double extraHeight;

  /// 边框圆角大小
  final double radius;

  /// 更新事件
  final VoidCallback onUpdate;

  double progress;

  /// 进度条的颜色
  final Color progressColor;

  /// 更新事件
  final VoidCallback? onClose;

  /// 是否是强制更新
  final bool isForce;

  /// 更新按钮内容
  final String updateButtonText;

  /// 忽略按钮内容
  final String ignoreButtonText;

  DxUpdateWidget({
    Key? key,
    this.width = 0.0,
    required this.title,
    required this.updateContent,
    required this.onUpdate,
    this.titleTextSize = 16.0,
    this.contentTextSize = 14.0,
    this.buttonTextSize = 14.0,
    this.progress = -1.0,
    this.progressColor = const Color(0xFF4078F4),
    this.topImage,
    this.extraHeight = 5.0,
    this.radius = 8.0,
    this.isForce = false,
    this.updateButtonText = '更新',
    this.ignoreButtonText = '忽略此版本',
    this.onClose,
  }) : super(key: key);

  final _DxUpdateWidgetState _state = _DxUpdateWidgetState();

  void update(double progress) => _state.update(progress);

  @override
  State<DxUpdateWidget> createState() => _state;
}

class _DxUpdateWidgetState extends State<DxUpdateWidget> {
  void update(double progress) {
    if (mounted) {
      setState(() => widget.progress = progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: dialogWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 170, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: const DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage(DxAsset.updateBg, package: 'dxwidget'),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: widget.extraHeight),
                        alignment: Alignment.center,
                        child:
                            Text(widget.title, style: TextStyle(fontSize: widget.titleTextSize, color: Colors.black)),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 160),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: ScrollConfiguration(
                          behavior: DxNoScrollBehavior(),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              widget.updateContent,
                              style: TextStyle(fontSize: widget.contentTextSize, color: const Color(0xFF666666)),
                            ),
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: DxButton(
                          block: true,
                          height: 46,
                          gradient: DxStyle.$GRADIENT$4A92E3$4078F4,
                          title: widget.updateButtonText,
                          onClick: widget.onUpdate,
                        ),
                        secondChild: DxNumberProgress(
                          height: 14,
                          value: widget.progress,
                          backgroundColor: widget.progressColor.withOpacity(0.3),
                          valueColor: widget.progressColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        crossFadeState: widget.progress < 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.onClose?.call(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 15, 15, 20),
                      child: Image.asset(DxAsset.updateClose, width: 15, height: 15, package: 'dxwidget'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
