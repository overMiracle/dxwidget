import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 空页面操作区域按钮的点击回调
/// index: 被点击按钮的索引
typedef DxIndexedButtonCallback = void Function(int index);

/// 异常页面展示一般用于网络错误、数据为空的提示和引导
// ignore: must_be_immutable
class DxAbnormalCard extends StatelessWidget {
  /// 图片
  final Widget? image;

  /// 标题
  final String? title;

  /// 内容
  final String? content;

  /// 按钮文本
  final List<String>? buttonList;

  /// 点击事件回调
  final DxIndexedButtonCallback? onClick;

  /// 主题
  DxAbnormalCardThemeData? themeData;

  DxAbnormalCard({
    Key? key,
    this.image,
    this.title,
    this.content,
    this.buttonList,
    this.themeData,
    this.onClick,
  }) : super(key: key) {
    themeData = DxAbnormalCardThemeData().merge(themeData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildImageWidget(context),
          _buildTextWidget(),
          _buildContentWidget(),
          _buildButtonWidget(),
        ],
      ),
    );
  }

  ///图片区域
  _buildImageWidget(BuildContext context) {
    if (image != null) return image;
    return const SizedBox.shrink();
  }

  ///文案区域：标题
  _buildTextWidget() {
    return title != null
        ? Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(title!, textAlign: TextAlign.center, style: themeData!.titleTextStyle),
          )
        : const SizedBox.shrink();
  }

  ///文案区域：内容
  _buildContentWidget() {
    return content != null
        ? Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 50),
            child: Text(content!, textAlign: TextAlign.center, style: themeData!.contentTextStyle),
          )
        : const SizedBox.shrink();
  }

  ///操作区按钮
  Widget _buildButtonWidget() {
    List<Widget> buttonWidgetList = [];
    if (buttonList == null) return const SizedBox.shrink();
    int count = buttonList!.length;
    for (int i = 0; i < count; i++) {
      buttonWidgetList.add(
        DxButton(
          margin: const EdgeInsets.only(bottom: 15),
          block: true,
          plain: i == count - 1 ? false : true,
          borderRadius: BorderRadius.circular(themeData?.btnRadius ?? 5),
          title: buttonList![i],
          color: themeData?.buttonColor,
          onClick: () => onClick?.call(i),
        ),
      );
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: buttonWidgetList);
  }
}
