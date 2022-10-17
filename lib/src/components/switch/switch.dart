import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// IOS风格切换按钮组件
class DxSwitch extends StatefulWidget {
  const DxSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.enabledThumbColor,
    this.enabledTrackColor,
    this.disabledTrackColor,
    this.disabledThumbColor,
    this.boxShape,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 400),
  }) : super(key: key);

  ///type of [Color] used for the active thumb color
  final Color? enabledThumbColor;

  ///type of [Color] used for the inactive thumb color
  final Color? disabledThumbColor;

  ///type of [Color] used for the active track color
  final Color? enabledTrackColor;

  ///type of [Color] used for the inactive thumb color
  final Color? disabledTrackColor;

  ///type of [BoxShape] used to define shapes i.e, Circle , Rectangle
  final BoxShape? boxShape;

  ///type of [BorderRadius] used to define the radius of the Container
  final BorderRadius? borderRadius;

  ///type of animation [Duration] called when the switch animates during the specific duration
  final Duration duration;

  /// This property must not be null. Used to set the current state of toggle
  final bool value;

  /// Called when the user toggles the switch on or off.
  final ValueChanged<bool> onChanged;

  @override
  State<DxSwitch> createState() => _DxSwitchState();
}

class _DxSwitchState extends State<DxSwitch> with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  late AnimationController controller;
  late Animation<Offset> offset;
  late bool isOn;

  @override
  void initState() {
    isOn = widget.value;

    controller = AnimationController(duration: widget.duration, vsync: this);
    offset = (isOn
            ? Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            : Tween<Offset>(begin: Offset.zero, end: const Offset(1, 0)))
        .animate(controller);
    super.initState();
  }

  void onStatusChange() {
    setState(() => isOn = !isOn);
    switch (controller.status) {
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      case AnimationStatus.completed:
        controller.reverse();
        break;
      default:
    }
    widget.onChanged(isOn);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onStatusChange,
        child: Stack(
          children: <Widget>[
            const SizedBox(height: 30, width: 45),
            Positioned(
              top: 5,
              child: Container(
                width: 45,
                height: 25,
                decoration: BoxDecoration(
                    color:
                        isOn ? widget.enabledTrackColor ?? Colors.blue : widget.disabledTrackColor ?? DxStyle.$EEEEEE,
                    borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(20))),
              ),
            ),
            Positioned(
              top: 7.5,
              left: 2,
              child: SlideTransition(
                position: offset,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOn ? widget.enabledThumbColor ?? Colors.white : widget.disabledThumbColor ?? Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    animationController?.dispose();
    controller.dispose();
    super.dispose();
  }
}
