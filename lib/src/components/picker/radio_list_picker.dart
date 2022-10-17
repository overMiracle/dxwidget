import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/picker/base/picker_clip_rrect.dart';
import 'package:dxwidget/src/components/picker/base/picker_title.dart';
import 'package:flutter/material.dart';

/// 点击确定时的回调
/// [selectedItems] 被选中的 item 集合
///
/// 事件拦截回调（如果配置了此项，返回值为是否拦截，如果为true，则进行拦截，不进行默认回调）
typedef DxRadioListClickInterceptor = bool Function(List<DxPickerItem> selectedItems);
typedef DxRadioListPickerConfirm = void Function(List<DxPickerItem> selectedItems);

/// 多选列表 Picker
class DxRadioListPicker extends StatefulWidget {
  /// 标题
  final String title;

  /// 数据条目
  final List<DxPickerItem> items;

  /// 最多选择多少个item，默认可以无限选
  final int maxSelectCount;

  /// 拦截器
  final DxRadioListClickInterceptor? interceptor;

  /// 确定事件
  final DxRadioListPickerConfirm? onConfirm;

  /// 主题
  final DxPickerThemeData? themeData;

  static void show(
    BuildContext context, {
    String title = '请选择',
    required List<DxPickerItem> items,
    int maxSelectCount = 0,
    DxRadioListClickInterceptor? interceptor,
    DxRadioListPickerConfirm? onConfirm,
    DxPickerThemeData? themeData,
  }) {
    themeData = DxPickerThemeData().merge(themeData);
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return DxRadioListPicker(
          title: title,
          items: items,
          maxSelectCount: maxSelectCount,
          interceptor: interceptor,
          onConfirm: onConfirm,
          themeData: themeData,
        );
      },
    );
  }

  const DxRadioListPicker({
    Key? key,
    this.title = '请选择',
    required this.items,
    this.maxSelectCount = 0,
    this.interceptor,
    this.onConfirm,
    this.themeData,
  }) : super(key: key);

  @override
  State<DxRadioListPicker> createState() => _DxRadioListPickerState();
}

class _DxRadioListPickerState extends State<DxRadioListPicker> with WidgetsBindingObserver {
  final List<DxPickerItem> _selectedList = [];
  @override
  void initState() {
    super.initState();
    for (DxPickerItem item in widget.items) {
      //选中的按钮
      if (item.isSelect == true) {
        _selectedList.add(item);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DxPickerTitle(
              pickerTitleConfig: DxPickerTitleConfig(titleText: widget.title),
              onConfirm: () {
                if (widget.interceptor == null || !widget.interceptor!(_selectedList)) {
                  widget.onConfirm?.call(_selectedList);
                  Navigator.of(context).pop();
                }
              },
              onCancel: () => Navigator.of(context).pop(),
            ),
            SizedBox(
              width: double.infinity,
              height: widget.themeData?.pickerHeight,
              child: ScrollConfiguration(
                behavior: DxNoScrollBehavior(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _buildItem(context, index),
                  itemCount: widget.items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    /// 获取当前的选中状态
    bool selectStatus = widget.items[index].isSelect;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.maxSelectCount == 1) {
          for (var item in widget.items) {
            item.isSelect = false;
          }
          setState(() {
            widget.items[index].isSelect = !widget.items[index].isSelect;
          });
          _selectedList.clear();
          if (!selectStatus) {
            _selectedList.add(widget.items[index]);
          }
          return;
        }
        if (widget.maxSelectCount > 0 && _selectedList.length >= widget.maxSelectCount && selectStatus == false) {
          DxToast.show('最多选择${widget.maxSelectCount}个');
          return;
        }
        setState(() {
          widget.items[index].isSelect = !widget.items[index].isSelect;
        });
        if (!selectStatus) {
          _selectedList.add(widget.items[index]);
        } else {
          _selectedList.remove(widget.items[index]);
        }
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.items[index].name,
                    style: selectStatus ? widget.themeData?.tagSelectedTextStyle : widget.themeData?.tagTextStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: selectStatus
                      ? Image.asset(DxAsset.selected, scale: 3.0, package: 'dxwidget')
                      : Image.asset(DxAsset.unSelected, scale: 3.0, package: 'dxwidget'),
                ),
              ],
            ),
          ),
          index != widget.items.length - 1
              ? const Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: DxDivider())
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
