import 'dart:async';

import 'package:flutter/material.dart';

/// 文字跑马灯Widget
// ignore: must_be_immutable
class DxMarqueeText extends StatefulWidget {
  ///滚动文字（不超过设置的宽度不滚动）
  final String text;

  /// 文字样式
  final TextStyle? textStyle;

  ///滚动方向，水平或者垂直
  final Axis scrollAxis;

  ///空白部分占控件的百分比
  final double ratioOfBlankToScreen;

  ///滚动评率 毫秒（默认100）
  final int timerRest;

  /// 尽量设置宽高，自动算宽|高受布局影响较大
  late double width;

  late double height;

  DxMarqueeText({
    Key? key,
    required this.text,
    this.width = 0,
    this.height = 0,
    this.timerRest = 100,
    this.textStyle,
    this.scrollAxis = Axis.horizontal,
    this.ratioOfBlankToScreen = 0.25,
  }) : super(key: key);

  @override
  State<DxMarqueeText> createState() => _DxMarqueeTextState();
}

class _DxMarqueeTextState extends State<DxMarqueeText> with SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  double blankWidth = 1;
  double blankHeight = 1;
  double position = 0.0;
  Timer? timer;
  final double _moveDistance = 3.0;
  GlobalKey? _key;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      var size = context.findRenderObject()!.paintBounds.size;
      widget.width = (widget.width) > 0 ? widget.width : size.width;
      widget.height = (widget.height) > 0 ? widget.height : size.height;

      _key = GlobalKey();
      if (calculateTextWith(
              widget.text, widget.textStyle?.fontSize, widget.textStyle?.fontWeight, double.infinity, 1, context) >
          widget.width) {
        blankWidth = widget.width * widget.ratioOfBlankToScreen;
        blankHeight = widget.height * widget.ratioOfBlankToScreen;
        setState(() {
          startTimer();
        });
      } else {
        blankWidth = widget.width;
        blankHeight = widget.height;
        setState(() {});
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: widget.timerRest), (timer) {
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      double pixels = scrollController.position.pixels;
      //当animateTo的距离大于最大滑动距离时，则要返回第一个child的特定位置，让末尾正好处于最右侧，然后继续滚动，造成跑马灯的假象
      if (pixels + _moveDistance >= maxScrollExtent) {
        if (widget.scrollAxis == Axis.horizontal) {
          position = (maxScrollExtent - blankWidth - widget.width) / 2 + pixels - maxScrollExtent;
        } else {
          position = (maxScrollExtent - blankHeight - widget.height) / 2 + pixels - maxScrollExtent;
        }
        scrollController.jumpTo(position);
      }
      position += _moveDistance;
      scrollController.animateTo(position, duration: Duration(milliseconds: widget.timerRest), curve: Curves.linear);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget getBothEndsChild() {
    if (widget.scrollAxis == Axis.vertical) {
      String newString = widget.text.split("").join("\n");
      return Center(
        child: Text(
          newString,
          style: widget.textStyle,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Center(child: Text(widget.text, style: widget.textStyle));
  }

  Widget getCenterChild() {
    if (widget.scrollAxis == Axis.horizontal) {
      return SizedBox(width: blankWidth);
    } else {
      return SizedBox(height: blankHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      width: widget.width,
      height: widget.height,
      child: ListView(
        scrollDirection: widget.scrollAxis,
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          getBothEndsChild(),
          getCenterChild(),
          getBothEndsChild(),
        ],
      ),
    );
  }

  double calculateTextWith(
      String value, double? fontSize, FontWeight? fontWeight, double maxWidth, int maxLines, BuildContext context) {
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
      locale: Localizations.localeOf(context),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: value,
        style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      ),
    );
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.width;
  }

  @override
  void dispose() {
    timer?.cancel();
    scrollController.dispose();
    super.dispose();
  }
}
