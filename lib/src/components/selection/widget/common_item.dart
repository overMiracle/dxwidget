import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

class DxSelectionCommonItemWidget extends StatelessWidget {
  final DxSelectionItem item;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final bool isCurrentFocused;
  final bool isFirstLevel;
  final bool isMoreSelectionListType;

  final ValueChanged<DxSelectionItem>? itemSelectFunction;

  final DxSelectionThemeData? themeData;

  const DxSelectionCommonItemWidget({
    Key? key,
    required this.item,
    this.backgroundColor,
    this.isFirstLevel = false,
    this.isMoreSelectionListType = false,
    this.itemSelectFunction,
    this.selectedBackgroundColor,
    this.isCurrentFocused = false,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget checkbox;
    const Widget sizedBoxShrink = SizedBox.shrink();
    if (!item.isUnLimit() && (item.children.isEmpty)) {
      if (item.isInLastLevel() && item.hasCheckBoxBrother()) {
        checkbox = Container(
          padding: const EdgeInsets.only(left: 6),
          width: 21,
          child: (item.isSelected)
              ? Image.asset(DxAsset.selected, package: 'dxwidget')
              : Image.asset(DxAsset.unSelected, package: 'dxwidget'),
        );
      } else {
        checkbox = sizedBoxShrink;
      }
    } else {
      checkbox = sizedBoxShrink;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => itemSelectFunction?.call(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: getItemBGColor(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.title + getSelectedItemCount(item),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: getItemTextStyle(),
                    ),
                  ),
                  checkbox
                ],
              ),
              Visibility(
                visible: !DxTools.isEmpty(item.subTitle),
                child: Padding(
                  padding: EdgeInsets.only(right: item.isInLastLevel() ? 21 : 0),
                  child: DxCSS2Text.toTextView(
                    item.subTitle ?? '',
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    defaultStyle: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.none,
                      color: DxStyle.$999999,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color? getItemBGColor() {
    if (isCurrentFocused) {
      return selectedBackgroundColor;
    } else {
      return backgroundColor;
    }
  }

  bool isHighLight(DxSelectionItem item) {
    if (item.isInLastLevel()) {
      if (item.isUnLimit()) {
        return isCurrentFocused;
      } else {
        return item.isSelected;
      }
    } else {
      return isCurrentFocused;
    }
  }

  bool isBold(DxSelectionItem item) {
    if (isHighLight(item)) {
      return true;
    } else {
      return item.hasCheckBoxBrother() && item.selectedList().isNotEmpty;
    }
  }

  TextStyle? getItemTextStyle() {
    if (isHighLight(item)) {
      return themeData?.itemSelectedTextStyle;
    } else if (isBold(item)) {
      return themeData?.itemBoldTextStyle;
    }
    return themeData?.itemNormalTextStyle;
  }

  String getSelectedItemCount(DxSelectionItem item) {
    String itemCount = "";
    if ((DxSelectionUtil.getTotalLevel(item) < 3 || !isFirstLevel) && item.children.isNotEmpty) {
      int count = item.children.where((f) => f.isSelected && !f.isUnLimit()).length;
      if (count > 1) {
        return '($count)';
      } else if (count == 1 && item.hasCheckBoxBrother()) {
        return '($count)';
      } else {
        var unLimited = item.children.where((f) => f.isSelected && f.isUnLimit()).toList();
        if (unLimited.isNotEmpty) {
          return '(全部)';
        }
      }
    }
    return itemCount;
  }
}
