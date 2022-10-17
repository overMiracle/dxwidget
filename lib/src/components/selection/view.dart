import 'package:dxwidget/src/components/selection/index.dart';
import 'package:dxwidget/src/components/selection/more.dart';
import 'package:dxwidget/src/theme/index.dart';
import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

/// 默认筛选参数转换器，对传入的筛选数据做处理，返回 Map 参数对象。
const DxSelectionConverterDelegate _defaultConverter = DefaultSelectionConverter();

// ignore: must_be_immutable
class DxSelectionView extends StatefulWidget {
  final DxSelectionConverterDelegate selectionConverterDelegate;
  final DxOnCustomSelectionMenuClick? onCustomSelectionMenuClick;
  final DxOnCustomFloatingLayerClick? onCustomFloatingLayerClick;
  final DxOnMoreSelectionMenuClick? onMoreSelectionMenuClick;
  final DxOnSelectionChanged onSelectionChanged;
  final List<DxSelectionItem> originalSelectionData;
  final DxOnMenuItemInterceptor? onMenuClickInterceptor;
  final DxOnSelectionPreShow? onSelectionPreShow;

  ///筛选所在列表的外部列表滚动需要收起筛选，此处为最外层列表，有点恶心，但是暂时只想到这个方法，有更好方式的一定要告诉我
  final ScrollController? extraScrollController;

  ///指定筛选固定的相对于屏幕的顶部距离，默认null不指定
  final double? constantTop;

  /// 处理完默认选中的参数后给外部回调
  final OnDefaultParamsPrepared? onDefaultParamsPrepared;

  /// 用于对 SelectionWindowType.Range 类型的列数做配置的回调。
  final DxConfigTagCountPerRow? configRowCount;

  final DxSelectionViewController? selectionViewController;

  DxSelectionThemeData? themeData;

  DxSelectionView({
    Key? key,
    required this.originalSelectionData,
    this.selectionViewController,
    required this.onSelectionChanged,
    this.configRowCount,
    this.selectionConverterDelegate = _defaultConverter,
    this.onMenuClickInterceptor,
    this.onCustomSelectionMenuClick,
    this.onCustomFloatingLayerClick,
    this.onMoreSelectionMenuClick,
    this.onDefaultParamsPrepared,
    this.onSelectionPreShow,
    this.constantTop,
    this.extraScrollController,
    this.themeData,
  }) : super(key: key) {
    themeData = DxSelectionThemeData().merge(themeData);
  }

  @override
  State<StatefulWidget> createState() => DxSelectionViewState();
}

class DxSelectionViewState extends State<DxSelectionView> {
  final Map<String, String> _customParams = {};
  DxSelectionViewController? _selectionViewController;

  @override
  void initState() {
    super.initState();
    _selectionViewController = widget.selectionViewController ?? DxSelectionViewController();
    for (var f in widget.originalSelectionData) {
      f.configRelationshipAndDefaultValue();
    }

    widget.onDefaultParamsPrepared?.call(
      widget.selectionConverterDelegate.convertSelectedData(widget.originalSelectionData),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.originalSelectionData.isNotEmpty) {
      for (var f in widget.originalSelectionData) {
        f.configRelationship();
      }
      return DxSelectionMenuWidget(
        context: context,
        items: widget.originalSelectionData,
        themeData: widget.themeData!,
        extraScrollController: widget.extraScrollController,
        constantTop: widget.constantTop,
        configRowCount: widget.configRowCount,
        onMenuItemClick: (int menuIndex) {
          if (widget.onMenuClickInterceptor != null && widget.onMenuClickInterceptor!(menuIndex)) {
            return true;
          }

          if (widget.onSelectionPreShow != null) {
            widget.originalSelectionData[menuIndex].filterShowType =
                widget.onSelectionPreShow!(menuIndex, widget.originalSelectionData[menuIndex]);
          }

          /// 自定义 Menu 的时候，
          /// 1、外部设置选中的 key-value 参数。
          /// 2、触发更新 UI。
          /// 3、触发 _onSelectionChanged 统一回调给外部
          if (widget.originalSelectionData[menuIndex].type == DxSelectionType.customHandle &&
              widget.onCustomSelectionMenuClick != null) {
            widget.onCustomSelectionMenuClick!(menuIndex, widget.originalSelectionData[menuIndex],
                (Map<String, String> customParams) {
              _customParams.clear();
              _customParams.addAll(customParams);
              _onSelectionChanged(menuIndex);
              setState(() {});
            });
          }

          /// 自定义 Menu 的时候，让外部设置选中的 value 进来统一更新 UI。 然后触发 _onSelectionChanged 统一回调给外部
          if (widget.originalSelectionData[menuIndex].type == DxSelectionType.more &&
              widget.onMoreSelectionMenuClick != null) {
            widget.onMoreSelectionMenuClick!(menuIndex, (
                {bool updateData = false, List<DxSelectionItem>? moreSelections}) {
              if (updateData) {
                List<DxSelectionItem> moreSelectionEntities = moreSelections ?? [];
                widget.originalSelectionData[menuIndex].children = moreSelectionEntities;
                widget.originalSelectionData[menuIndex].configRelationshipAndDefaultValue();
              }
              setState(() {});
              _openMore(widget.originalSelectionData[menuIndex],
                  onCustomFloatingLayerClick: widget.onCustomFloatingLayerClick);
            });
          }
          return false;
        },
        onConfirm: (DxSelectionItem results, int firstIndex, int secondIndex, int thirdIndex) {
          _onSelectionChanged(widget.originalSelectionData.indexOf(results));
        },
      );
    }
    return const SizedBox.shrink();
  }

  void _onSelectionChanged(int menuIndex) {
    widget.onSelectionChanged(
        menuIndex, widget.selectionConverterDelegate.convertSelectedData(widget.originalSelectionData), _customParams, (
            {String? menuTitle, bool isMenuTitleHighLight = false}) {
      /// 说明没有 menu 被选中，不需要更新。
      if (menuIndex >= 0) {
        widget.originalSelectionData[menuIndex].isCustomTitleHighLight = isMenuTitleHighLight;
        widget.originalSelectionData[menuIndex].customTitle = menuTitle;
      }

      /// 当设置了自定义的参数时：
      /// 1、执行关闭筛选页面动作（会将menu 中的箭头置为朝下的非激活状态）；
      /// 2、刷新 Menu title；
      _selectionViewController?.closeSelectionView();
      _selectionViewController?.refreshSelectionTitle();
      setState(() {});
    });
    setState(() {});
  }

  void _openMore(DxSelectionItem entity, {DxOnCustomFloatingLayerClick? onCustomFloatingLayerClick}) {
    if (entity.children.isNotEmpty) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, second) {
            return DxSelectionMorePage(
              item: entity,
              themeData: widget.themeData!,
              onCustomFloatingLayerClick: onCustomFloatingLayerClick,
              confirmCallback: (_) {
                DxEventBus.instance.fire(RefreshMenuTitleEvent());
                _onSelectionChanged(widget.originalSelectionData.indexOf(entity));
              },
            );
          },
        ),
      );
    }
  }
}
