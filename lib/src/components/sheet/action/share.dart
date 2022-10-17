import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// 分享面板
/// 底部弹起的分享面板，用于展示各分享渠道对应的操作按钮，不含具体的分享逻辑
class DxShareActionSheet {
  /// 顶部标题
  final String title;

  /// 标题下方的辅助描述文字
  final String? desc;

  /// 图标大小，默认48
  final double iconSize;

  /// 因为布局居中数量少的时候会挤在一起，就加间隔
  final double itemSpace;

  /// 第一行渠道列表，必须至少有一行
  final List<DxShareActionSheetItem> firstItems;

  /// 第二行渠道列表
  final List<DxShareActionSheetItem>? secondItems;

  /// 是否在点击遮罩层后关闭
  final bool isDismissible;

  /// 点击分享选项时触发
  /// item是点击的单元，row是点击的第几行，index是第几个
  final Function(DxShareActionSheetItem item, int row, int index)? onSelect;

  const DxShareActionSheet({
    Key? key,
    this.title = '请选择',
    this.desc,
    this.iconSize = 48,
    this.itemSpace = 0,
    required this.firstItems,
    this.secondItems,
    this.isDismissible = true,
    this.onSelect,
  }) : assert(iconSize <= DxStyle.shareSheetItemSize, 'iconSize不能超过${DxStyle.shareSheetItemSize}');

  /// 显示
  static void show(
    BuildContext context, {
    String title = '请选择',
    final String? desc,
    final double iconSize = 48,
    final double itemSpace = 0,
    required final List<DxShareActionSheetItem> firstItems,
    final List<DxShareActionSheetItem>? secondItems,
    final bool isDismissible = true,
    final Function(DxShareActionSheetItem item, int row, int index)? onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (BuildContext context) => _DxShareActionSheet(DxShareActionSheet(
        title: title,
        desc: desc,
        iconSize: iconSize,
        itemSpace: itemSpace,
        firstItems: firstItems,
        secondItems: secondItems,
        isDismissible: isDismissible,
        onSelect: onSelect,
      )),
    );
  }
}

class _DxShareActionSheet extends StatelessWidget {
  final DxShareActionSheet dxShareSheet;
  final Widget sizedBoxShrink = const SizedBox.shrink();

  const _DxShareActionSheet(this.dxShareSheet);

  /// 标题和描述
  Widget buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: DxStyle.shareSheetHeaderPadding,
      child: Column(children: [
        Text(dxShareSheet.title, style: DxStyle.$22222$15$W500),
        const SizedBox(height: DxStyle.intervalSm),
        dxShareSheet.desc != null
            ? Text(
                dxShareSheet.desc!,
                style: const TextStyle(
                    fontSize: DxStyle.shareSheetDescriptionFontSize, color: DxStyle.shareSheetDescriptionColor),
              )
            : sizedBoxShrink,
      ]),
    );
  }

  /// 取消按钮
  Widget buildCancelItem(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Divider(color: DxStyle.$F8F8F8, thickness: 8, height: 8),
        GestureDetector(
          child: DecoratedBox(
            decoration: const BoxDecoration(color: DxStyle.shareSheetBackgroundColor),
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                alignment: Alignment.center,
                height: DxStyle.shareSheetCancelItemHeight,
                child: const Text(
                  '取消',
                  style: TextStyle(
                    fontSize: DxStyle.shareSheetCancelItemFontSize,
                    color: DxStyle.shareSheetCancelItemTextColor,
                  ),
                ),
              ),
            ),
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget buildShare(BuildContext context, List<DxShareActionSheetItem> items, int row) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DxStyle.shareSheetPadding),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            items.length,
            (int index) {
              DxShareActionSheetItem item = items[index];
              return GestureDetector(
                onTap: () {
                  if (item.canClick) {
                    Navigator.of(context).pop();
                    item.onClick?.call();
                    dxShareSheet.onSelect?.call(item, row, index);
                  }
                },
                child: _buildItem(item),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 构建分享按钮单元
  Widget _buildItem(DxShareActionSheetItem item) {
    Widget child = Container(
      margin: EdgeInsets.symmetric(horizontal: dxShareSheet.itemSpace / 2),
      width: DxStyle.shareSheetItemSize,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: dxShareSheet.iconSize,
            height: dxShareSheet.iconSize,
            margin: const EdgeInsets.only(bottom: DxStyle.intervalLg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(dxShareSheet.iconSize / 2)),
            ),
            child: FittedBox(
              child: item.icon ?? const Icon(Icons.share, color: DxStyle.shareSheetItemIconColor),
            ),
          ),
          Text(
            item.title,
            style: const TextStyle(fontSize: DxStyle.fontSizeSm, color: DxStyle.gray7),
          ),
          item.desc != null
              ? Text(item.desc!, style: const TextStyle(fontSize: DxStyle.fontSize11, color: DxStyle.gray4))
              : sizedBoxShrink
        ],
      ),
    );
    if (!item.canClick) return Opacity(opacity: 0.4, child: child);
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DxStyle.shareSheetHeaderBorderRadius)),
        color: DxStyle.shareSheetBackgroundColor,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            (dxShareSheet.title != '' || dxShareSheet.desc != '') ? buildTitle(context) : sizedBoxShrink,

            /// 构建第一行
            buildShare(context, dxShareSheet.firstItems, 0),

            /// 构建第二行
            dxShareSheet.secondItems != null
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DxDivider(),
                  )
                : sizedBoxShrink,
            dxShareSheet.secondItems != null ? buildShare(context, dxShareSheet.secondItems!, 1) : sizedBoxShrink,
            buildCancelItem(context),
          ],
        ),
      ),
    );
  }
}

/// 条目
class DxShareActionSheetItem {
  final String title;
  final String? desc;
  final Widget? icon;

  /// 是否可点击（如果为预设类型，设置为不可点击后会变为相应的置灰图标）默认为true
  final bool canClick;
  final VoidCallback? onClick;

  DxShareActionSheetItem({
    this.title = '',
    this.desc,
    this.icon,
    this.canClick = true,
    this.onClick,
  });
}
