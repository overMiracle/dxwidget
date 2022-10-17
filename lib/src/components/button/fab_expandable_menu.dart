import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// Builds the Boom Menu
/// https://pub.dev/packages/expandable_fab_menu
class DxExpandableMenuFab extends StatefulWidget {
  final Color btnColor;
  final Color? foregroundColor;
  final double elevation;
  final ShapeBorder fabMenuBorder;
  final Alignment fabAlignment;

  final double marginLeft;
  final double marginRight;
  final double marginBottom;

  final double fabPaddingLeft;
  final double fabPaddingRight;
  final double fabPaddingTop;

  /// The color of the background overlay.
  final Color overlayColor;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData? animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData? animatedIconTheme;

  /// The child of the main button, ignored if [animatedIcon] is non [null].
  final Widget? child;

  /// The speed of the animation
  final int animationSpeed;

  /// Children buttons, from the lowest to the highest.
  final List<DxExpandableMenuFabItem> items;

  const DxExpandableMenuFab({
    Key? key,
    this.fabAlignment = Alignment.centerRight,
    this.foregroundColor,
    this.elevation = 6.0,
    this.overlayColor = Colors.black12,
    this.animatedIcon,
    this.animatedIconTheme,
    this.marginBottom = 0,
    this.marginLeft = 16,
    this.marginRight = 0,
    this.fabMenuBorder = const CircleBorder(),
    this.fabPaddingRight = 0,
    this.fabPaddingLeft = 0,
    this.fabPaddingTop = 0,
    this.animationSpeed = 200,
    this.btnColor = Colors.black26,
    required this.child,
    this.items = const [],
  }) : super(key: key);

  @override
  State<DxExpandableMenuFab> createState() => _DxExpandableMenuFabState();
}

class _DxExpandableMenuFabState extends State<DxExpandableMenuFab> with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _controller;

  Duration _calculateMainControllerDuration() => Duration(
        milliseconds: widget.animationSpeed + widget.items.length * (widget.animationSpeed / 5).round(),
      );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _calculateMainControllerDuration(), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performAnimation() {
    if (!mounted) return;
    _open ? _controller.forward() : _controller.reverse();
  }

  @override
  void didUpdateWidget(DxExpandableMenuFab oldWidget) {
    if (oldWidget.items.length != widget.items.length) {
      _controller.duration = _calculateMainControllerDuration();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _toggleChildren() {
    var newValue = !_open;
    setState(() => _open = newValue);
    _performAnimation();
  }

  List<Widget> _getChildrenList() {
    final singleChildrenTween = 1.0 / widget.items.length;

    return widget.items.reversed.map((DxExpandableMenuFabItem child) {
      int index = widget.items.indexOf(child);

      var childAnimation = Tween(begin: 0.0, end: 62.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0, singleChildrenTween * (index + 1)),
        ),
      );

      return _DxExpandableMenuAnimatedChild(
        animation: childAnimation,
        index: index,
        visible: _open,
        btnColor: child.backgroundColor,
        title: child.title,
        subtitle: child.subtitle,
        titleColor: child.titleColor,
        subTitleColor: child.subTitleColor,
        onTap: child.onTap,
        toggleChildren: () => _toggleChildren(),
        child: child.trailing,
      );
    }).toList();
  }

  /// 渲染遮罩
  Widget _renderOverlay() {
    return Positioned(
      right: -16.0,
      bottom: -16.0,
      top: _open ? 0.0 : null,
      left: _open ? 0.0 : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleChildren,
        child: ColoredBox(color: widget.overlayColor),
      ),
    );
  }

  Widget _renderButton() {
    var child = widget.animatedIcon != null
        ? AnimatedIcon(
            icon: widget.animatedIcon!,
            progress: _controller,
            color: widget.animatedIconTheme?.color,
            size: widget.animatedIconTheme?.size,
          )
        : widget.child;

    var fabChildren = _getChildrenList();

    return Positioned(
      left: widget.marginLeft + 16,
      bottom: widget.marginBottom + 30,
      right: widget.marginRight,
      child: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // const SizedBox(height: kToolbarHeight + 40),
            Visibility(
              visible: _open,
              child: Expanded(
                child: ListView(
                  reverse: true,
                  shrinkWrap: true,
                  children: List.from(fabChildren),
                ),
              ),
            ),
            Align(
              alignment: widget.fabAlignment,
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.fabPaddingLeft,
                  right: widget.fabPaddingRight,
                  top: 8.0 + widget.fabPaddingTop,
                ),
                child: _DxAnimatedFloatingButton(
                  btnColor: widget.btnColor,
                  foregroundColor: widget.foregroundColor,
                  elevation: widget.elevation,
                  onLongPress: _toggleChildren,
                  callback: _toggleChildren,
                  shape: widget.fabMenuBorder,
                  child: child!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      children: [
        _renderOverlay(),
        _renderButton(),
      ],
    );
  }
}

/// 创建按钮菜单
class _DxExpandableMenuAnimatedChild extends AnimatedWidget {
  final Animation<double> animation;
  final int index;
  final Color? btnColor;
  final Widget? child;

  final bool visible;
  final VoidCallback? onTap;
  final VoidCallback toggleChildren;
  final String? title;
  final String? subtitle;
  final Color? titleColor;
  final Color? subTitleColor;

  const _DxExpandableMenuAnimatedChild(
      {Key? key,
      required this.animation,
      required this.index,
      this.btnColor,
      this.child,
      this.title,
      this.subtitle,
      this.visible = false,
      this.onTap,
      required this.toggleChildren,
      this.titleColor,
      this.subTitleColor})
      : super(key: key, listenable: animation);

  void _performAction() {
    if (onTap != null) onTap!();
    toggleChildren();
  }

  @override
  Widget build(BuildContext context) {
    final Widget menuItemWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: child ?? const SizedBox.shrink(),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? '',
                overflow: TextOverflow.clip,
                style: TextStyle(color: titleColor, fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Offstage(
                offstage: subtitle == null,
                child: Text(
                  subtitle!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: subTitleColor, fontSize: 12.0),
                ),
              )
            ],
          ),
        )
      ],
    );
    return GestureDetector(
      onTap: _performAction,
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: menuItemWidget,
      ),
    );
  }
}

class _DxAnimatedFloatingButton extends StatelessWidget {
  final VoidCallback callback;
  final VoidCallback? onLongPress;

  final Color btnColor;
  final Color? foregroundColor;
  final String? tooltip;
  final String? heroTag;
  final double elevation;
  final ShapeBorder shape;
  final Curve curve;
  final Widget child;

  const _DxAnimatedFloatingButton({
    Key? key,
    required this.callback,
    required this.child,
    required this.btnColor,
    this.foregroundColor,
    this.tooltip,
    this.heroTag,
    this.elevation = 6.0,
    this.shape = const CircleBorder(),
    this.curve = Curves.linear,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: AnimatedContainer(
        curve: curve,
        duration: const Duration(milliseconds: 150),
        child: GestureDetector(
          onLongPress: onLongPress,
          child: FloatingActionButton(
            backgroundColor: btnColor,
            foregroundColor: foregroundColor,
            onPressed: callback,
            tooltip: tooltip,
            heroTag: heroTag,
            elevation: elevation,
            highlightElevation: elevation,
            shape: shape,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                child,
                const Text('新建', style: DxStyle.$WHITE$11),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 条目
class DxExpandableMenuFabItem {
  final Widget? trailing;
  final String? subtitle;
  final Color titleColor;
  final Color subTitleColor;
  final Color backgroundColor;
  final double? elevation;
  final String title;
  final VoidCallback onTap;

  DxExpandableMenuFabItem({
    this.trailing,
    this.subtitle,
    this.titleColor = Colors.white,
    this.subTitleColor = DxStyle.gray3,
    this.backgroundColor = Colors.blue,
    this.elevation,
    required this.title,
    required this.onTap,
  });
}
