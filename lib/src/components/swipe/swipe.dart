import 'dart:async';

import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 轮播
class DxSwipe extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets margin;

  //是否自动播放
  final bool autoPlay;

  // 自动轮播间隔
  final Duration? interval;

  // 动画时长
  final Duration? duration;

  // 初始位置索引值
  final int? initIndex;

  // 是否显示指示器
  final bool showIndicators;

  //指示器大小
  final double indicatorSize;

  // 指示器距离边缘的距离
  final double indicatorMargin;

  // 当前指示器颜色
  final Color activeColor;

  // 其他指示器颜色
  final Color inactiveColor;

  // 滚动方向
  final String scrollDirection;

  // 动画效果，默认fastOutSlowIn
  final Curve curve;

  // 每一页轮播后触发
  final Function(int val)? onChange;

  // 每个页面在滚动方向占据的视窗比例，默认为 1
  final double viewportFraction;

  // 显示内容
  final List<Widget> children;

  // 自定义指示器
  final Widget? indicator;

  final int _length;

  DxSwipe({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.margin = EdgeInsets.zero,
    this.autoPlay = true,
    this.initIndex = 0,
    this.interval = const Duration(seconds: 3),
    this.scrollDirection = 'horizontal',
    this.curve = Curves.fastOutSlowIn,
    this.duration,
    this.showIndicators = true,
    this.indicator,
    this.indicatorSize = DxStyle.swipeIndicatorSize,
    this.indicatorMargin = 10.0,
    this.viewportFraction = 1.0,
    this.activeColor = DxStyle.swipeIndicatorActiveBackgroundColor,
    this.inactiveColor = DxStyle.swipeIndicatorActiveBackgroundColor,
    this.onChange,
    required this.children,
  })  : _length = children.length,
        assert(children.isNotEmpty, 'children 数量必须大于零'),
        assert(viewportFraction > 0.0),
        super(key: key);

  @override
  State<DxSwipe> createState() => _DxSwipeState();
}

class _DxSwipeState extends State<DxSwipe> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  PageController? _pageController;
  Timer? timer;
  late int _currentPage;
  int? _realCurrentPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //如果初始值是0，往左就滑不动了，所以给它赋一个大于零的值
    _currentPage = 100 * widget._length + (widget.initIndex ?? 0);

    _realCurrentPage = widget.initIndex;
    _pageController = PageController(initialPage: _currentPage, viewportFraction: widget.viewportFraction);

    if (widget.autoPlay) start();
  }

  /// 启动
  void start() {
    Duration interval = widget.interval ?? const Duration(seconds: 3);
    Duration duration = widget.duration ?? DxStyle.swipeDuration;
    timer = Timer.periodic(interval, (Timer t) {
      int toPage = _currentPage = _currentPage + 1;
      setState(() => _currentPage = toPage);
      _pageController!.animateToPage(toPage, duration: duration, curve: widget.curve);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: Stack(
        alignment:
            widget.scrollDirection == 'vertical' ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
        children: <Widget>[
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: widget.scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
              itemBuilder: (context, i) {
                int index = i % widget._length;
                return widget.children[index];
              },
              onPageChanged: (i) {
                setState(() {
                  _currentPage = i;
                  _realCurrentPage = i % widget._length;
                });
                widget.onChange?.call((i) % 100 % widget._length + 1);
              },
            ),
          ),
          widget.showIndicators ? (widget.indicator ?? _buildIndicators()) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    final List<Widget> indicatorList = [];
    for (int i = 0; i < widget._length; i++) {
      indicatorList.add(Container(
        width: widget.indicatorSize,
        height: widget.indicatorSize,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: _realCurrentPage == i ? widget.activeColor : widget.inactiveColor,
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(50),
        ),
      ));
    }

    return Positioned(
      left: widget.scrollDirection == 'vertical' ? widget.indicatorMargin : null,
      bottom: widget.scrollDirection == 'horizontal' ? widget.indicatorMargin : null,
      child: widget.scrollDirection == 'vertical'
          ? Column(mainAxisSize: MainAxisSize.min, children: indicatorList)
          : Row(mainAxisSize: MainAxisSize.min, children: indicatorList),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        timer?.cancel();
        break;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }
}
