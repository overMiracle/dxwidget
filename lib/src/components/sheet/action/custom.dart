import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 动作面板，内容需要自定义
/// 底部弹起的模态面板，包含与当前情境相关的多个选项。
//ignore: must_be_immutable
class DxCustomActionSheet extends StatelessWidget {
  // 顶部标题
  final String? title;

  // 选项上方的描述信息
  final String? desc;

  // 取消按钮文字
  final String? cancelTitle;

  // 是否在点击遮罩层后关闭
  final bool isDismissible;

  // 自定义菜单内容
  final Widget? child;

  // 主题
  DxActionSheetThemeData? themeData;

  final SizedBox _sizedBoxShrink = const SizedBox.shrink();

  DxCustomActionSheet({
    Key? key,
    this.title,
    this.desc,
    this.cancelTitle,
    this.isDismissible = true,
    this.child,
    this.themeData,
  }) : super(key: key) {
    themeData = DxActionSheetThemeData().merge(themeData);
  }

  static void show(
    BuildContext context, {
    String? title,
    String? desc,
    String? cancelTitle,
    bool isDismissible = true,
    Widget? child,
    DxActionSheetThemeData? themeData,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (BuildContext context) => DxCustomActionSheet(
        title: title,
        desc: desc,
        cancelTitle: cancelTitle,
        isDismissible: isDismissible,
        themeData: themeData,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(themeData!.topRadius)),
        color: DxStyle.actionSheetItemBackground,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            (title != null || desc != null) ? buildTitleItem(context) : _sizedBoxShrink,
            const Divider(thickness: 1, height: 1, color: DxStyle.$F5F5F5),
            child ?? _sizedBoxShrink,
            const Divider(color: DxStyle.$F8F8F8, thickness: 8, height: 8),
            (cancelTitle != null) ? buildCancelItem(context) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget buildTitleItem(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              padding: DxStyle.actionSheetHeaderPadding,
              child: Column(
                children: <Widget>[
                  title != null ? Text(title!, style: themeData!.titleStyle) : _sizedBoxShrink,
                  const SizedBox(height: DxStyle.intervalSm),
                  desc != null
                      ? Text(
                          desc!,
                          style: const TextStyle(
                              fontSize: DxStyle.actionSheetDescriptionFontSize,
                              color: DxStyle.actionSheetDescriptionColor),
                        )
                      : _sizedBoxShrink,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCancelItem(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: DxStyle.actionSheetItemBackground),
        height: DxStyle.actionSheetItemHeight,
        child: Text(cancelTitle ?? '取消', style: themeData!.cancelStyle),
      ),
    );
  }
}
