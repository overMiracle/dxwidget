import 'package:flutter/widgets.dart';

/// KeepAliveWrapper can keep the item(s) of scrollview alive, **Not dispose**.
class DxKeepAliveWidget extends StatefulWidget {
  final bool keepAlive;
  final Widget child;

  const DxKeepAliveWidget({
    Key? key,
    this.keepAlive = true,
    required this.child,
  }) : super(key: key);

  @override
  State<DxKeepAliveWidget> createState() => _DxKeepAliveWidgetState();
}

class _DxKeepAliveWidgetState extends State<DxKeepAliveWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant DxKeepAliveWidget oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
