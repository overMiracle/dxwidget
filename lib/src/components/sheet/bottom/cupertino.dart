import 'package:dxwidget/src/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 自定义顶部内容
class DxCupertinoBottomSheet extends StatefulWidget {
  final String? title;
  final Color backgroundColor;
  final Color pillColor;
  final Widget child;

  const DxCupertinoBottomSheet({
    super.key,
    this.title,
    this.pillColor = DxStyle.gray4,
    this.backgroundColor = Colors.white,
    required this.child,
  });

  static show<T>({
    String? title,
    required BuildContext context,
    required Widget child,
    Color pillColor = DxStyle.gray4,
    Color backgroundColor = Colors.white,
    double elevation = 10,
    BoxConstraints? constraints = const BoxConstraints(minWidth: double.infinity, maxHeight: 320),
  }) {
    return showBottomSheet(
      context: context,
      constraints: constraints,
      elevation: elevation,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (_) => DxCupertinoBottomSheet(
        title: title,
        pillColor: pillColor,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }

  @override
  State<DxCupertinoBottomSheet> createState() => _DxCupertinoBottomSheetState();
}

class _DxCupertinoBottomSheetState extends State<DxCupertinoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.title == null
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    Container(
                      height: 5.0,
                      width: 25.0,
                      decoration: BoxDecoration(color: widget.pillColor, borderRadius: BorderRadius.circular(50.0)),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              )
            : _titleWidget(),
        widget.child,
      ],
    );
  }

  Widget _titleWidget() {
    // 构建整体标题
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: const Text('关闭', style: DxStyle.$999999$12, textAlign: TextAlign.left),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: Text(widget.title!, textAlign: TextAlign.center, maxLines: 1, style: DxStyle.$404040$14$W500),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 20), child: Text('  ')),
          ],
        ),
        //有标题则添加分割线
        const Divider(thickness: 1, height: 0.5, color: DxStyle.$F5F5F5),
      ],
    );
  }
}
