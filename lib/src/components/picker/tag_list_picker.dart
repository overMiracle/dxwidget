import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/picker/base/picker_clip_rrect.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:flutter/material.dart';

///样式的枚举类型
/// [average] 等分布局
/// [auto] 流式布局
enum DxTagPickerLayoutStyle {
  ///等分布局
  average,

  ///流式布局
  wrap,
}

typedef DxTagPickerOnItemClick = void Function(DxPickerItem tagItem, bool isSelect);

/// 多选标签弹框,适用于底部弹出 Picker，且选择样式为 Tag 的场景。
/// 功能：多选标签弹框，适用于从底部弹出的情况，属于 Picker；
/// 参考网址：https://bruno.ke.com/page/v2.2.0/widgets/brn-multi-select-tags-picker
// ignore: must_be_immutable
class DxTagPicker extends StatefulWidget {
  /// 标题
  final String? title;

  /// item的高度, 默认数值是48，如果想让Tag的高度变高，就调大这个数值
  final double? itemHeight;

  /// 是等分样式还是流式布局样式，[DxTagPickerLayoutStyle]，默认等分
  final DxTagPickerLayoutStyle layoutStyle;

  /// 一行多少个数据，默认4个
  final int? crossAxisCount;

  /// 最多选择多少个item，默认0可以无限选
  final int maxSelectItemCount;

  /// 当点击到最大数目时的点击事件
  final VoidCallback? onMaxSelectClick;

  /// 数据源
  final List<DxPickerItem> items;

  /// 点击提交功能
  final ValueChanged onConfirm;

  /// 主题
  final DxPickerThemeData? themeData;

  static void show(
    BuildContext context, {
    String? title = '请选择',
    double itemHeight = 42,
    DxTagPickerLayoutStyle layoutStyle = DxTagPickerLayoutStyle.average,
    int crossAxisCount = 4,
    int maxSelectItemCount = 0,
    VoidCallback? onMaxSelectClick,
    required List<DxPickerItem> items,
    required ValueChanged onConfirm,
    DxPickerThemeData? themeData,
  }) {
    themeData = DxPickerThemeData().merge(themeData);
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return DxTagPicker(
          title: title,
          itemHeight: itemHeight,
          layoutStyle: layoutStyle,
          crossAxisCount: crossAxisCount,
          maxSelectItemCount: maxSelectItemCount,
          onMaxSelectClick: onMaxSelectClick,
          items: items,
          onConfirm: onConfirm,
          themeData: themeData,
        );
      },
    );
  }

  const DxTagPicker({
    Key? key,
    this.title,
    this.itemHeight = 42.0,
    this.crossAxisCount,
    this.layoutStyle = DxTagPickerLayoutStyle.average,
    this.maxSelectItemCount = 0,
    this.onMaxSelectClick,
    required this.items,
    required this.onConfirm,
    this.themeData,
  }) : super(key: key);

  @override
  State<DxTagPicker> createState() => _DxTagPickerState();
}

class _DxTagPickerState extends State<DxTagPicker> with WidgetsBindingObserver {
  late final VoidCallback _onUpdate;

  /// 操作类型属性
  final List<DxPickerItem> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _onUpdate = () => setState(() {});
    for (DxPickerItem item in widget.items) {
      //选中的标签
      if (item.isSelect == true) {
        _selectedTags.add(item);
      }
    }

    /// 绘制完成关闭弹窗
    WidgetsBinding.instance.addPostFrameCallback((callback) => DxToast.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return DxPickerClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.themeData?.cornerRadius ?? 5),
        topRight: Radius.circular(widget.themeData?.cornerRadius ?? 5),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: <Widget>[
            _createContentWidget(context),
            _createHeaderWidget(context),
          ],
        ),
      ),
    );
  }

  /// 创建头部视图
  Widget _createHeaderWidget(BuildContext context) {
    return DxPickerTitle(
      pickerTitleConfig: DxPickerTitleConfig(titleText: widget.title ?? ''),
      themeData: widget.themeData,
      onCancel: () => Navigator.of(context).maybePop(),
      onConfirm: () {
        widget.onConfirm(_selectedTags);
        Navigator.of(context).maybePop();
      },
    );
  }

  /// 创建内容视图
  Widget _createContentWidget(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('数据为空，请维护', style: DxStyle.$CCCCCC$14)),
      );
    }
    if (widget.layoutStyle == DxTagPickerLayoutStyle.average) {
      return LayoutBuilder(
        builder: (_, constraints) {
          double maxWidth = constraints.maxWidth;
          return _buildGridViewWidget(context, maxWidth);
        },
      );
    } else {
      return _buildWrapViewWidget(context);
    }
  }

  ///等宽度的布局
  Widget _buildGridViewWidget(BuildContext context, double maxWidth) {
    int $crossAxisCount = (widget.crossAxisCount == null || widget.crossAxisCount == 0) ? 4 : widget.crossAxisCount!;
    double width = (maxWidth - ($crossAxisCount - 1) * 16 - 40) / $crossAxisCount;
    //计算宽高比
    double $childAspectRatio = width / (widget.itemHeight ?? 42);
    return Padding(
      /// 上下有GridView内边距
      padding: EdgeInsets.fromLTRB(20, (widget.themeData?.titleHeight ?? 48) - 5, 20, 0),
      child: ScrollConfiguration(
        behavior: DxNoScrollBehavior(),
        child: GridView.count(
          primary: true,
          shrinkWrap: true,
          crossAxisCount: $crossAxisCount,
          //水平子Widget之间间距
          crossAxisSpacing: 8.0,
          //垂直子Widget之间间距
          mainAxisSpacing: 12.0,
          //宽高比
          childAspectRatio: $childAspectRatio,
          physics: const BouncingScrollPhysics(),
          //GridView内边距
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: widget.items.map((DxPickerItem item) {
            bool selected = item.isSelect;
            return Opacity(
              opacity: item.isDisabled ? 0.3 : 1,
              child: ChoiceChip(
                selected: selected,
                padding: EdgeInsets.zero,
                pressElevation: 0,
                backgroundColor: widget.themeData?.tagBgColor,
                selectedColor: widget.themeData?.tagSelectedBgColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                label: Center(
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: selected ? widget.themeData?.tagSelectedTextStyle : widget.themeData?.tagTextStyle,
                  ),
                ),
                onSelected: (bool value) {
                  if (widget.maxSelectItemCount > 0 &&
                      _selectedTags.length >= widget.maxSelectItemCount &&
                      value == true) {
                    widget.onMaxSelectClick?.call();
                    return;
                  }
                  _clickTag(value, item);
                  _onUpdate();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ///流式布局
  Widget _buildWrapViewWidget(BuildContext context) {
    return ScrollConfiguration(
      behavior: DxNoScrollBehavior(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, (widget.themeData?.titleHeight ?? 48) + 10, 20, 0),
          child: Wrap(
            spacing: 15.0,
            children: widget.items.map((DxPickerItem item) {
              bool selected = item.isSelect;
              return Opacity(
                opacity: item.isDisabled ? 0.3 : 1,
                child: ChoiceChip(
                  selected: selected,
                  pressElevation: 0,
                  backgroundColor: widget.themeData?.tagBgColor,
                  selectedColor: widget.themeData?.tagSelectedBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                  label: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: selected ? widget.themeData?.tagSelectedTextStyle : widget.themeData?.tagTextStyle,
                  ),
                  onSelected: (bool value) {
                    if (widget.maxSelectItemCount > 0 &&
                        _selectedTags.length > widget.maxSelectItemCount &&
                        value == true) {
                      widget.onMaxSelectClick?.call();
                      return;
                    }
                    _clickTag(value, item);
                    _onUpdate();
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  ///每一个item的点击事件
  void _clickTag(bool selected, DxPickerItem item) {
    if (item.isDisabled) return;
    if (selected) {
      item.isSelect = true;
      _selectedTags.add(item);
    } else {
      item.isSelect = false;
      _selectedTags.remove(item);
    }
  }
}
