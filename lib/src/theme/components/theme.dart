import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 配置主题
class DxTheme extends StatelessWidget {
  const DxTheme({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  final DxThemeData data;

  final Widget child;

  static final DxThemeData _kFallbackTheme = DxThemeData.fallback();

  static DxThemeData of(BuildContext context) {
    final _DxInheritedTheme? inheritedTheme = context.dependOnInheritedWidgetOfExactType<_DxInheritedTheme>();

    return inheritedTheme?.theme.data ?? _kFallbackTheme;
  }

  @override
  Widget build(BuildContext context) => _DxInheritedTheme(theme: this, child: child);
}

class _DxInheritedTheme extends InheritedTheme {
  const _DxInheritedTheme({Key? key, required this.theme, required Widget child}) : super(key: key, child: child);

  final DxTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DxTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_DxInheritedTheme old) => theme.data != old.theme.data;
}

@immutable
class DxThemeData {
  /// 异常页面
  final DxAbnormalCardThemeData abnormalCardTheme;

  /// ActionBar 动作栏
  final DxActionBarThemeData actionBarTheme;

  /// ActionSheet 动作栏
  final DxActionSheetThemeData actionSheetTheme;

  /// Badge 徽标
  final DxBadgeThemeData badgeTheme;

  /// Button 按钮
  final DxButtonThemeData buttonTheme;

  /// Cell 单元格
  final DxCellThemeData cellTheme;

  /// CellGroup 单元格组
  final DxCellGroupThemeData cellGroupTheme;

  /// Circle 环形进度条
  final DxCircleThemeData circleTheme;

  /// Collapse x叠面板
  final DxCollapseThemeData collapseTheme;

  /// CountDown 倒计时
  final DxCountDownThemeData countDownTheme;

  /// Dialog 弹出框
  final DxDialogThemeData dialogTheme;

  /// Divider 分割线
  final DxDividerThemeData dividerTheme;

  /// Image 图片
  final DxImageThemeData imageTheme;

  /// Loading 加载
  final DxLoadingThemeData loadingTheme;

  final Color overlayBackgroundColor;

  /// Picker 选择器
  final DxPickerThemeData pickerTheme;

  /// Popup 弹出层
  final DxPopupThemeData popupTheme;

  /// Progress 线性进度条
  final DxProgressLinearBarThemeData progressLinearBarTheme;

  /// 选择器
  final DxSelectionThemeData selectionTheme;

  /// 侧边栏导航
  final DxSidebarThemeData sidebarTheme;

  /// SubmitBar 提交订单栏
  final DxSubmitBarThemeData submitBarTheme;

  ///  Switch 开关
  final DxSwitchThemeData switchTheme;

  /// Tag 标签
  final DxTagThemeData tagTheme;

  /// TabBar 标签栏
  final DxTabBarThemeData tabBarTheme;

  ///  分类树选择
  final DxTreeSelectionThemeData treeSelectionTheme;

  factory DxThemeData({
    DxAbnormalCardThemeData? abnormalCardTheme,
    DxActionBarThemeData? actionBarTheme,
    DxActionSheetThemeData? actionSheetTheme,
    DxBadgeThemeData? badgeTheme,
    DxButtonThemeData? buttonTheme,
    DxCellThemeData? cellTheme,
    DxCellGroupThemeData? cellGroupTheme,
    DxCircleThemeData? circleTheme,
    DxCollapseThemeData? collapseTheme,
    DxCountDownThemeData? countDownTheme,
    DxDialogThemeData? dialogTheme,
    DxDividerThemeData? dividerTheme,
    DxImageThemeData? imageTheme,
    DxLoadingThemeData? loadingTheme,
    Color? overlayBackgroundColor,
    DxPickerThemeData? pickerTheme,
    DxPopupThemeData? popupTheme,
    DxProgressLinearBarThemeData? progressLinearBarTheme,
    DxSelectionThemeData? selectionTheme,
    DxSidebarThemeData? sidebarTheme,
    DxSubmitBarThemeData? submitBarTheme,
    DxSwitchThemeData? switchTheme,
    DxTagThemeData? tagTheme,
    DxTabBarThemeData? tabBarTheme,
    DxTreeSelectionThemeData? treeSelectionTheme,
  }) {
    return DxThemeData.raw(
      abnormalCardTheme: abnormalCardTheme ?? DxAbnormalCardThemeData(),
      actionBarTheme: actionBarTheme ?? DxActionBarThemeData(),
      actionSheetTheme: actionSheetTheme ?? DxActionSheetThemeData(),
      badgeTheme: badgeTheme ?? DxBadgeThemeData(),
      buttonTheme: buttonTheme ?? DxButtonThemeData(),
      cellTheme: cellTheme ?? DxCellThemeData(),
      cellGroupTheme: cellGroupTheme ?? DxCellGroupThemeData(),
      circleTheme: circleTheme ?? DxCircleThemeData(),
      collapseTheme: collapseTheme ?? DxCollapseThemeData(),
      countDownTheme: countDownTheme ?? DxCountDownThemeData(),
      dialogTheme: dialogTheme ?? DxDialogThemeData(),
      dividerTheme: dividerTheme ?? DxDividerThemeData(),
      imageTheme: imageTheme ?? DxImageThemeData(),
      loadingTheme: loadingTheme ?? DxLoadingThemeData(),
      overlayBackgroundColor: overlayBackgroundColor ?? const Color.fromRGBO(0, 0, 0, .7),
      pickerTheme: pickerTheme ?? DxPickerThemeData(),
      popupTheme: popupTheme ?? DxPopupThemeData(),
      progressLinearBarTheme: progressLinearBarTheme ?? DxProgressLinearBarThemeData(),
      selectionTheme: selectionTheme ?? DxSelectionThemeData(),
      sidebarTheme: sidebarTheme ?? DxSidebarThemeData(),
      submitBarTheme: submitBarTheme ?? DxSubmitBarThemeData(),
      switchTheme: switchTheme ?? DxSwitchThemeData(),
      tagTheme: tagTheme ?? DxTagThemeData(),
      tabBarTheme: tabBarTheme ?? DxTabBarThemeData(),
      treeSelectionTheme: treeSelectionTheme ?? DxTreeSelectionThemeData(),
    );
  }

  factory DxThemeData.fallback() => DxThemeData();

  const DxThemeData.raw({
    required this.abnormalCardTheme,
    required this.actionBarTheme,
    required this.actionSheetTheme,
    required this.badgeTheme,
    required this.buttonTheme,
    required this.cellTheme,
    required this.cellGroupTheme,
    required this.circleTheme,
    required this.collapseTheme,
    required this.countDownTheme,
    required this.dialogTheme,
    required this.dividerTheme,
    required this.imageTheme,
    required this.loadingTheme,
    required this.overlayBackgroundColor,
    required this.pickerTheme,
    required this.popupTheme,
    required this.progressLinearBarTheme,
    required this.selectionTheme,
    required this.sidebarTheme,
    required this.submitBarTheme,
    required this.switchTheme,
    required this.tagTheme,
    required this.tabBarTheme,
    required this.treeSelectionTheme,
  });

  static DxThemeData lerp(DxThemeData a, DxThemeData b, double t) {
    return DxThemeData.raw(
      abnormalCardTheme: DxAbnormalCardThemeData.lerp(a.abnormalCardTheme, b.abnormalCardTheme, t),
      actionBarTheme: DxActionBarThemeData.lerp(a.actionBarTheme, b.actionBarTheme, t),
      actionSheetTheme: DxActionSheetThemeData.lerp(a.actionSheetTheme, b.actionSheetTheme, t),
      badgeTheme: DxBadgeThemeData.lerp(a.badgeTheme, b.badgeTheme, t),
      buttonTheme: DxButtonThemeData.lerp(a.buttonTheme, b.buttonTheme, t),
      cellTheme: DxCellThemeData.lerp(a.cellTheme, b.cellTheme, t),
      cellGroupTheme: DxCellGroupThemeData.lerp(a.cellGroupTheme, b.cellGroupTheme, t),
      circleTheme: DxCircleThemeData.lerp(a.circleTheme, b.circleTheme, t),
      collapseTheme: DxCollapseThemeData.lerp(a.collapseTheme, b.collapseTheme, t),
      countDownTheme: DxCountDownThemeData.lerp(a.countDownTheme, b.countDownTheme, t),
      dialogTheme: DxDialogThemeData.lerp(a.dialogTheme, b.dialogTheme, t),
      dividerTheme: DxDividerThemeData.lerp(a.dividerTheme, b.dividerTheme, t),
      imageTheme: DxImageThemeData.lerp(a.imageTheme, b.imageTheme, t),
      loadingTheme: DxLoadingThemeData.lerp(a.loadingTheme, b.loadingTheme, t),
      overlayBackgroundColor: Color.lerp(a.overlayBackgroundColor, b.overlayBackgroundColor, t)!,
      pickerTheme: DxPickerThemeData.lerp(a.pickerTheme, b.pickerTheme, t),
      popupTheme: DxPopupThemeData.lerp(a.popupTheme, b.popupTheme, t),
      progressLinearBarTheme: DxProgressLinearBarThemeData.lerp(a.progressLinearBarTheme, b.progressLinearBarTheme, t),
      selectionTheme: DxSelectionThemeData.lerp(a.selectionTheme, b.selectionTheme, t),
      sidebarTheme: DxSidebarThemeData.lerp(a.sidebarTheme, b.sidebarTheme, t),
      submitBarTheme: DxSubmitBarThemeData.lerp(a.submitBarTheme, b.submitBarTheme, t),
      switchTheme: DxSwitchThemeData.lerp(a.switchTheme, b.switchTheme, t),
      tagTheme: DxTagThemeData.lerp(a.tagTheme, b.tagTheme, t),
      tabBarTheme: DxTabBarThemeData.lerp(a.tabBarTheme, b.tabBarTheme, t),
      treeSelectionTheme: DxTreeSelectionThemeData.lerp(a.treeSelectionTheme, b.treeSelectionTheme, t),
    );
  }
}

class DxThemeDataTween extends Tween<DxThemeData> {
  DxThemeDataTween({DxThemeData? begin, DxThemeData? end}) : super(begin: begin, end: end);

  @override
  DxThemeData lerp(double t) => DxThemeData.lerp(begin!, end!, t);
}

class DxAnimatedTheme extends ImplicitlyAnimatedWidget {
  const DxAnimatedTheme({
    Key? key,
    required this.data,
    Curve curve = Curves.linear,
    Duration duration = kThemeAnimationDuration,
    VoidCallback? onEnd,
    required this.child,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final DxThemeData data;

  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedTheme> createState() => _DxAnimatedThemeState();
}

class _DxAnimatedThemeState extends AnimatedWidgetBaseState<AnimatedTheme> {
  DxThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data, (dynamic value) => DxThemeDataTween(begin: value as DxThemeData))!
        as DxThemeDataTween;
  }

  @override
  Widget build(BuildContext context) {
    return DxTheme(data: _data!.evaluate(animation), child: widget.child);
  }
}
