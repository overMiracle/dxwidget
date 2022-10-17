import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/cell/cell.dart';
import 'package:dxwidget/src/theme/components/card/collapse.dart';
import 'package:flutter/material.dart';

import '../../theme/style.dart';
import '../widget/slidable/index.dart';

/// 最外层一定要套一层滚动
class DxCollapse extends StatefulWidget {
  /// 外边距
  final EdgeInsets margin;

  /// 内边距
  final EdgeInsets padding;

  /// 各个单元之间的距离
  final double space;

  /// 选中的索引
  final int currentIndex;

  /// 内容
  final List<DxCollapseItem> children;

  const DxCollapse({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.currentIndex = 0,
    this.space = 0,
    required this.children,
  }) : super(key: key);

  @override
  State<DxCollapse> createState() => _DxCollapseState();
}

class _DxCollapseState extends State<DxCollapse> {
  late int $currentIndex;
  late final DxCollapseThemeData themeData;

  @override
  void initState() {
    super.initState();
    $currentIndex = widget.currentIndex;
    themeData = DxCollapseTheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return DxSlidableAutoCloseBehavior(
      child: ScrollConfiguration(
        behavior: DxNoScrollBehavior(),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: _buildList(),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> list = [];
    for (int index = 0; index < widget.children.length; index++) {
      DxCollapseItem item = widget.children.elementAt(index);
      final Widget titleWidget = DxCell(
        disabled: item.disabled,
        color: item.color,
        height: item.height,
        borderPosition: DxCellBorderPosition.bottom,
        title: item.title,
        titleStyle: item.subTitleStyle,
        titleWidget: item.titleWidget,
        subTitle: item.subTitle,
        subTitleStyle: item.subTitleStyle,
        subTitleWidget: item.subTitleWidget,
        trailingWidget: item.trailingWidget ??
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: _CollapseRightIcon(
                expanded: $currentIndex == index,
                duration: themeData.itemTransitionDuration,
                color: item.disabled ? themeData.itemTitleDisabledColor : Colors.black,
              ),
            ),
        slidableExtentRatio: item.slidableExtentRatio,
        slidablePadding: item.slidablePadding,
        slidableActionList: item.slidableActionList,
        onClick: () {
          if (item.disabled) return;
          $currentIndex = $currentIndex == index ? -1 : index;
          setState(() => $currentIndex);
        },
      );

      final Widget contentWidget = _AnimatedContent(
        expanded: $currentIndex == index,
        duration: themeData.itemTransitionDuration,
        child: DefaultTextStyle(
          style: TextStyle(
            color: themeData.itemContentTextColor,
            fontSize: themeData.itemContentFontSize,
            height: themeData.itemContentLineHeight,
          ),
          child: item.child,
        ),
      );

      list.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            titleWidget,
            contentWidget,
            Offstage(
              offstage: $currentIndex != index,
              child: const Divider(height: 0.5, color: DxStyle.$F5F5F5),
            ),
            widget.space == 0 ? const SizedBox.shrink() : SizedBox(height: widget.space),
          ],
        ),
      );
    }
    return list;
  }
}

/// CollapseItem 折叠面板单元
class DxCollapseItem {
  /// 唯一标识符，默认为索引值
  final String? tagName;

  /// 是否禁用面板
  final bool disabled;

  /// 内边距
  final EdgeInsets padding;

  /// 高度
  final double height;

  /// 边框位置
  final DxCellBorderPosition borderPosition;

  /// 背景颜色
  final Color color;

  /// 左侧标题
  final String? title;

  /// 标题下方的描述信息
  final String? subTitle;

  /// 左侧标题额外样式
  final TextStyle? titleStyle;

  /// 描述信息额外类名
  final TextStyle? subTitleStyle;

  /// 自定义左侧 title 的内容
  final Widget? titleWidget;

  /// 自定义标题下方 subtitle 的内容
  final Widget? subTitleWidget;

  /// 自定义左侧组件
  final Widget? leading;

  /// 右侧文本
  final String? trailing;

  /// 右侧文本样式
  final TextStyle? trailingStyle;

  /// 自定义右侧组件
  final Widget? trailingWidget;

  final double slidablePadding;

  /// 滑动长度比例，Must be between 0 (excluded) and 1.
  final double slidableExtentRatio;

  /// 滑动事件
  final List<DxSlidableAction>? slidableActionList;

  /// 面板内容
  final Widget child;

  DxCollapseItem({
    this.tagName,
    this.disabled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0),
    this.height = 54,
    this.borderPosition = DxCellBorderPosition.none,
    this.color = Colors.white,
    this.leading,
    this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.titleWidget,
    this.subTitleWidget,
    this.trailing,
    this.trailingStyle,
    this.trailingWidget,
    this.slidablePadding = 0,
    this.slidableActionList,
    this.slidableExtentRatio = 0.5,
    required this.child,
  });
}

/// 折叠动画组件
class _AnimatedSize extends AnimatedWidget {
  const _AnimatedSize({
    Key? key,
    required Animation<double> listenable,
    this.child,
  }) : super(key: key, listenable: listenable);

  final Widget? child;

  double get height => (listenable as Animation<double>).value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, height: height, child: child);
  }
}

/// 折叠内容组件
class _AnimatedContent extends StatefulWidget {
  const _AnimatedContent({
    Key? key,
    required this.duration,
    this.expanded = false,
    this.child,
  }) : super(key: key);

  final Duration duration;

  final bool expanded;

  final Widget? child;

  @override
  __AnimatedContentState createState() => __AnimatedContentState();
}

class __AnimatedContentState extends State<_AnimatedContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  GlobalKey wrapKey = GlobalKey();
  double? maxHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _animation = _controller = AnimationController(
      value: widget.expanded ? 1.0 : 0.0,
      duration: widget.duration,
      vsync: this,
    );

    _calcMaxHeight();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _AnimatedContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calcMaxHeight();
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    /// 重新计算高度后再动画
    WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (widget.expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _calcMaxHeight() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timestamp) {
      final double? currentMaxHeight = wrapKey.currentContext?.size?.height;
      if (maxHeight != currentMaxHeight) {
        maxHeight = wrapKey.currentContext?.size?.height;
        _animation = _controller.drive(Tween<double>(begin: 0.0, end: maxHeight));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedSize(
      listenable: _animation,
      child: SingleChildScrollView(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        child: UnconstrainedBox(
          key: wrapKey,
          constrainedAxis: Axis.horizontal,
          child: widget.child,
        ),
      ),
    );
  }
}

/// 旋转图标组件
class _CollapseRightIcon extends StatefulWidget {
  final Color? color;

  final Duration duration;

  final bool expanded;

  const _CollapseRightIcon({
    Key? key,
    this.color,
    required this.duration,
    this.expanded = false,
  }) : super(key: key);

  @override
  __CollapseRightIconState createState() => __CollapseRightIconState();
}

class __CollapseRightIconState extends State<_CollapseRightIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(value: widget.expanded ? 1.0 : 0.0, duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _CollapseRightIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      key: UniqueKey(),
      turns: _animation,
      child: const Icon(Icons.keyboard_arrow_down, size: 18, color: DxStyle.$BBBBBB),
    );
  }
}
