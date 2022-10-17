import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// TreeSelect 分类选择
/// 用于从一组相关联的数据集合中进行选择。
class DxTreeSelection extends StatelessWidget {
  const DxTreeSelection({
    Key? key,
    this.max,
    this.treeList = const <DxTreeSelectionItem>[],
    this.height,
    this.rightActiveIndexList = const <String>[],
    this.selectedIconName = Icons.check,
    this.selectedIconUrl,
    this.leftActiveIndex = 0,
    this.isMultiple = false,
    this.onLeftClick,
    this.onRightClick,
    this.onRightActiveIndexChange,
    this.onLeftActiveIndexChange,
    this.child,
  })  : assert(max == null || (max >= 0)),
        super(key: key);

  /// 右侧项最大选中个数
  final int? max;

  /// 分类显示所需的数据
  final List<DxTreeSelectionItem> treeList;

  /// 高度
  final double? height;

  /// 右侧选中项的 id
  final List<String> rightActiveIndexList;

  /// 自定义右侧栏选中状态的图标名字
  final IconData selectedIconName;

  /// 自定义右侧栏选中状态的图标访问地址
  final String? selectedIconUrl;

  /// 左侧选中项的索引
  final int leftActiveIndex;

  /// 是否多选
  final bool isMultiple;

  /// 点击左侧导航时触发
  final void Function(int index)? onLeftClick;

  /// 点击右侧选择项时触发
  final void Function(DxTreeSelectionChild data)? onRightClick;

  /// 右侧选中项的id变化回调
  final void Function(List<String> rightActiveIndexList)? onRightActiveIndexChange;

  /// 左侧选中项的索引变化回调
  final void Function(int leftActiveIndex)? onLeftActiveIndexChange;

  /// 自定义右侧区域内容
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final DxTreeSelectionThemeData themeData = DxTreeSelectionTheme.of(context);

    return DefaultTextStyle(
      style: TextStyle(fontSize: themeData.fontSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _buildSidebar(themeData),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: themeData.contentBackgroundColor,
              child: _buildContent(themeData),
            ),
          ),
        ],
      ),
    );
  }

  void _onSidebarChange(int index) {
    onLeftActiveIndexChange?.call(index);
    onLeftClick?.call(index);
  }

  Widget _buildSidebar(DxTreeSelectionThemeData themeData) {
    final List<DxSidebarItem> items = treeList.map((DxTreeSelectionItem item) {
      return DxSidebarItem(
        dot: item.dot,
        title: item.text,
        badge: item.badge,
        disabled: item.disabled,
        padding: themeData.navItemPadding,
      );
    }).toList();
    return DxSidebar(
      value: leftActiveIndex,
      onChange: _onSidebarChange,
      backgroundColor: themeData.navBackgroundColor,
      children: items,
    );
  }

  Widget? _buildContent(DxTreeSelectionThemeData themeData) {
    if (child != null) {
      return child!;
    }
    final DxTreeSelectionItem? selected = treeList.isNotEmpty ? treeList[leftActiveIndex] : null;
    if (selected != null) {
      return ListView(
        children: selected.children.map<Widget>((DxTreeSelectionChild item) {
          final bool active = _isActiveItem(item.id);

          final Widget rightIcon = Visibility(
            visible: active,
            child: Container(
              width: 32.0,
              padding: const EdgeInsets.only(right: DxStyle.paddingMd),
              child: DxIcon(
                color: themeData.itemActiveColor,
                size: themeData.itemSelectedSize,
                iconName: selectedIconName,
              ),
            ),
          );

          final Color bgColor = active ? DxStyle.activeColor : Colors.transparent;
          final Color textColor = item.disabled
              ? themeData.itemDisabledColor!
              : active
                  ? themeData.itemActiveColor!
                  : DxStyle.textColor;
          return GestureDetector(
            onTap: () {
              if (item.disabled) return;

              List<String> $activeId;
              if (isMultiple) {
                $activeId = rightActiveIndexList;
                if ($activeId.contains(item.id)) {
                  $activeId.remove(item.id);
                } else if (max == null || (max != null && rightActiveIndexList.length < max!)) {
                  $activeId.add(item.id);
                }
              } else {
                $activeId = <String>[item.id];
              }

              onRightActiveIndexChange?.call($activeId);

              onRightClick?.call(item);
            },
            child: DefaultTextStyle(
              style: TextStyle(color: textColor),
              child: Container(
                height: themeData.itemHeight,
                color: bgColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: DxStyle.paddingMd),
                    Expanded(
                      child: Text(
                        item.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: DxStyle.fontWeightBold),
                      ),
                    ),
                    rightIcon,
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
    return null;
  }

  bool _isActiveItem(String id) => rightActiveIndexList.contains(id);
}

class DxTreeSelectionChild {
  String id;
  String text;
  bool disabled;

  DxTreeSelectionChild({
    required this.id,
    required this.text,
    this.disabled = false,
  });

  factory DxTreeSelectionChild.fromJson(Map<String, dynamic> json) {
    return DxTreeSelectionChild(
      id: json['id'].toString(),
      text: json['text'].toString(),
      disabled: json['disabled'] == true,
    );
  }
}

class DxTreeSelectionItem {
  bool dot;
  String text;
  String badge;
  List<DxTreeSelectionChild> children;
  bool disabled;

  DxTreeSelectionItem({
    this.dot = false,
    required this.text,
    this.badge = '',
    this.children = const <DxTreeSelectionChild>[],
    this.disabled = false,
  });

  factory DxTreeSelectionItem.fromJson(Map<String, dynamic> json) {
    return DxTreeSelectionItem(
      dot: json['dot'] == true,
      badge: json['badge'] as String? ?? '',
      text: json['text'].toString(),
      disabled: json['disabled'] == true,
      children: json['children'] is List<Map<String, dynamic>>
          ? (json['children'] as List<Map<String, dynamic>>)
              .map((Map<String, dynamic> item) => DxTreeSelectionChild.fromJson(item))
              .toList()
          : <DxTreeSelectionChild>[],
    );
  }
}
