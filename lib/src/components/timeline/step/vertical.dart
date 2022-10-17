import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 参考网址：https://bruno.ke.com/page/v2.2.0/widgets/brn-step-line

/// 在[contentWidget]的左侧自动添加 竖向步骤条的组件
///
/// 支持[isDashLine]是否为虚线，在虚线的情况下，支持设置虚线每一段的间隔[dashSpace]和每个虚线段的长度[dashLength].
///
/// 线的顶端是图片，支持[iconWidget]配置。
///
/// 常用情况：
///    快递时间节点、跟进时间节点、日历时间节点等等
///
/// 如果不想显示分割线，那么可以将[lineColor] 设置为透明色
///
/// 该组件支持设置为灰色模式[isGrey]，在灰色模式下 线条颜色和icon颜色都是灰色
///
/// 布局步骤同[CustomPaint],因此[iconWidget]和[contentWidget]是顶部对齐的。
/// 如果想要设置icon的偏移，可以通过[iconTopPadding]设置
///
/// 最后一个的竖线不显示
///  ListView.builder(
///      shrinkWrap: true,
///      physics: NeverScrollableScrollPhysics(),
///      itemCount: 5,
///      itemBuilder: (context, index) {
///          if (index == 4) {
///             return DxStepLineWidget(
///                     lineWidth: 1,
///                     lineColor: Colors.transparent,
///                     contentWidget: Container(
///                       height: 50,
///                       color: getRandomColor(),
///                     ),
///                   );
///                 }
///          return BrnStepLineWidget(
///                   lineWidth: 1,
///                   contentWidget: Container(
///                     height: 50,
///                     color: getRandomColor(),
///                ),
///          );
///   },
/// ),
///
/// 最后一个的竖线有颜色变化
///  ListView.builder(
///      shrinkWrap: true,
///      physics: const NeverScrollableScrollPhysics(),
///      itemCount: 5,
///      itemBuilder: (context, index) {
///           if (index == 4) {
///              return DxVerticalSteps(
///                     lineWidth: 1,
///                     lineColor: const <Color>[
///                       Color(0xFF0984F9),
///                       Colors.red,
///                     ],
///                     contentWidget: Container(
///                       height: 60,
///                       color: getRandomColor(),
///                     ),
///               );
///           }
///          return DxVerticalSteps(
///                   lineWidth: 1,
///                   contentWidget: Container(
///                     height: 50,
///                     color: getRandomColor(),
///                ),
///          );
///   },
/// ),
///
///
///
class DxVerticalStep extends StatelessWidget {
  ///线条顶部小圆点的大小
  final double pointSize;

  /// 线条和小圆点之间的间距
  final double pointLineSpace;

  /// 圆点颜色
  final Color? pointColor;

  /// 线条颜色
  final Color? lineColor;

  /// 线的宽度
  final double lineWidth;

  /// 是否画虚线
  final bool isDashLine;

  /// 每段虚线的长度
  final double dashLength;

  /// 每段虚线的间隔
  final double dashSpace;

  /// 内容距离左侧的距离
  final double contentPadding;

  /// 列表
  final List<DxVerticalStepItem> items;

  const DxVerticalStep({
    Key? key,
    this.pointSize = 16,
    this.pointLineSpace = 4,
    this.pointColor,
    this.lineColor,
    this.lineWidth = 1,
    this.isDashLine = false,
    this.dashLength = 4,
    this.dashSpace = 4,
    this.contentPadding = 20,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, int index) => items[index],
    );
  }
}

/// 单元
class DxVerticalStepItem extends StatelessWidget {
  /// 序号
  final int index;

  /// 圆点的颜色
  final Color? pointColor;

  /// 边框线的颜色
  final Color? lineColor;

  /// 自定义圆点widget
  final Widget? pointWidget;

  /// 边框包裹的widget
  final Widget child;

  const DxVerticalStepItem({
    Key? key,
    this.pointColor,
    this.lineColor,
    this.pointWidget,
    required this.index,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DxVerticalStep? parent = context.findAncestorWidgetOfExactType<DxVerticalStep>();
    assert(parent != null, 'DxVerticalStepItem必须在DxVerticalStep中使用');
    Color $pointColor = pointColor ?? parent!.pointColor ?? DxStyle.stepFinishLineColor;
    if (index != 0) $pointColor = DxStyle.gray4;
    Color $lineColor = lineColor ?? parent!.lineColor ?? DxStyle.stepLineColor;
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: _DxVerticalStepPainter(parent: parent!, lineColor: $lineColor),
          child: Padding(
            padding: EdgeInsets.only(left: parent.contentPadding),
            child: child,
          ),
        ),
        pointWidget ?? _buildColorCircleWidget(parent.pointSize, $pointColor),
      ],
    );
  }

  Widget _buildColorCircleWidget(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.3)),
      alignment: Alignment.center,
      child: Container(
        width: size / 2,
        height: size / 2,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _DxVerticalStepPainter extends CustomPainter {
  final DxVerticalStep parent;
  final Color lineColor;
  _DxVerticalStepPainter({required this.parent, required this.lineColor});

  final Paint _paint = Paint()
    ..strokeCap = StrokeCap.round // 画笔笔触类型
    ..isAntiAlias = true; // 是否启动抗锯齿;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.stroke; // 画线模式
    _paint.strokeWidth = parent.lineWidth;

    /// 圆点高度一半
    double halfPointerSize = parent.pointSize / 2;

    /// 总长度 16是icon的长度 4是线条不通栏
    double height = size.height - parent.pointSize - parent.pointLineSpace * 2;
    if (height <= 0) {
      return;
    }
    if (!parent.isDashLine) {
      /// 实线
      /// 起始的位置 去掉圆点的长度+线条不通栏化线的起点：icon的长度+自定义的icon的偏移量
      double temp = parent.pointSize + parent.pointLineSpace;
      _paint.color = lineColor;
      Path path = Path();
      path.moveTo(halfPointerSize, temp);
      path.lineTo(halfPointerSize, temp + height);
      canvas.drawPath(path, _paint);
    } else {
      /// 虚线
      //起始的位置 icon的大小+线条间距+自定义的padding设置
      double ori = parent.pointSize + parent.pointLineSpace + 8;
      double temp = ori;
      //线条总长度 child的大小-上下的通栏-icon
      double height = size.height - ori - parent.pointLineSpace;
      //一共多少段
      int count = (height / (parent.dashLength + parent.dashSpace)).ceil();

      for (int i = 0, n = count; i < n; i++) {
        Path path = Path();
        path.moveTo(halfPointerSize, temp);
        if (temp + parent.dashLength < size.height - parent.pointLineSpace) {
          temp += parent.dashLength;

          path.lineTo(halfPointerSize, temp);
          canvas.drawPath(path, _paint..color = lineColor);
          if (temp + parent.dashSpace < size.height - parent.pointLineSpace) {
            temp += parent.dashSpace;
            path.lineTo(halfPointerSize, temp);
            canvas.drawPath(path, _paint..color = Colors.transparent);
          } else {
            path.lineTo(halfPointerSize, size.height - parent.pointLineSpace);
            canvas.drawPath(path, _paint..color = Colors.transparent);
          }
        } else {
          path.lineTo(halfPointerSize, size.height - parent.pointLineSpace);
          canvas.drawPath(path, _paint..color = lineColor);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
