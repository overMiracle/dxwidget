import 'package:dxwidget/src/components/selection/index.dart';
import 'package:flutter/material.dart';

class DxSelectionAnimationWidget extends StatefulWidget {
  final DxSelectionListViewController controller;
  final Widget view;
  final int animationMilliseconds;

  const DxSelectionAnimationWidget({
    Key? key,
    required this.controller,
    required this.view,
    this.animationMilliseconds = 200,
  }) : super(key: key);

  @override
  State<DxSelectionAnimationWidget> createState() => _DxSelectionAnimationWidgetState();
}

class _DxSelectionAnimationWidgetState extends State<DxSelectionAnimationWidget> with SingleTickerProviderStateMixin {
  bool _isControllerDisposed = false;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.animationMilliseconds),
      vsync: this,
    )..addListener(() => setState(() {}));
    widget.controller.addListener(_showListViewWidget);
  }

  @override
  dispose() {
    widget.controller.removeListener(_showListViewWidget);
    _animationController.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      left: 0,
      child: Material(
        color: const Color(0x43000000),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - (widget.controller.listViewTop ?? 0),
          child: Padding(padding: EdgeInsets.zero, child: widget.view),
        ),
      ),
    );
  }

  _showListViewWidget() {
    if (_isControllerDisposed) return;
    Animation<double> animation =
        Tween(begin: 0.0, end: MediaQuery.of(context).size.height - (widget.controller.listViewTop ?? 0))
            .animate(_animationController);
    if (animation.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
}
