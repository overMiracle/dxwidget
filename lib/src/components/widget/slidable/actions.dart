import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

/// Signature for [DxCustomSlidableAction.onPressed].
typedef SlidableActionCallback = void Function(BuildContext context);

const int _kFlex = 1;
const Color _kBackgroundColor = Colors.white;
const bool _kAutoClose = true;

/// Represents an action of an [DxActionPane].
class DxCustomSlidableAction extends StatelessWidget {
  /// Creates a [DxCustomSlidableAction].
  ///
  /// The [flex], [backgroundColor], [autoClose] and [child] arguments must not
  /// be null.
  ///
  /// The [flex] argument must also be greater than 0.
  const DxCustomSlidableAction({
    Key? key,
    this.isDisabled = false,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    this.borderRadius = BorderRadius.zero,
    required this.onPressed,
    required this.child,
  })  : assert(flex > 0),
        super(key: key);

  /// 是否禁用
  final bool isDisabled;

  /// {@template slidable.actions.flex}
  /// The flex factor to use for this child.
  ///
  /// The amount of space the child's can occupy in the main axis is
  /// determined by dividing the free space according to the flex factors of the
  /// other [DxCustomSlidableAction]s.
  /// {@contemplate}
  final int flex;

  /// {@template slidable.actions.backgroundColor}
  /// The background color of this action.
  ///
  /// Defaults to [Colors.white].
  /// {@contemplate}
  final Color backgroundColor;

  /// {@template slidable.actions.foregroundColor}
  /// The foreground color of this action.
  ///
  /// Defaults to [Colors.black] if [background]'s brightness is
  /// [Brightness.light], or to [Colors.white] if [background]'s brightness is
  /// [Brightness.dark].
  /// {@contemplate}
  final Color? foregroundColor;

  /// {@template slidable.actions.autoClose}
  /// Whether the enclosing [DxSlidable] will be closed after [onPressed]
  /// occurred.
  /// {@contemplate}
  final bool autoClose;

  /// {@template slidable.actions.onPressed}
  /// Called when the action is tapped or otherwise activated.
  ///
  /// If this callback is null, then the action will be disabled.
  /// {@contemplate}
  final SlidableActionCallback? onPressed;

  /// {@template slidable.actions.borderRadius}
  /// The borderRadius of this action
  ///
  /// Defaults to [BorderRadius.zero].
  /// {@contemplate}
  final BorderRadius borderRadius;

  /// Typically the action's icon or label.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final effectiveForegroundColor = foregroundColor ??
        (ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.light ? Colors.black : Colors.white);

    Widget button = OutlinedButton(
      onPressed: () => _handleTap(context),
      style: OutlinedButton.styleFrom(
        splashFactory: isDisabled ? NoSplash.splashFactory : null,
        foregroundColor: effectiveForegroundColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        side: BorderSide.none,
      ),
      child: child,
    );

    if (isDisabled) button = Opacity(opacity: 0.3, child: button);
    return Expanded(flex: flex, child: SizedBox.expand(child: button));
  }

  void _handleTap(BuildContext context) {
    if (isDisabled) {
      DxToast.show('暂无权限');
      return;
    }
    onPressed?.call(context);
    if (autoClose) {
      DxSlidable.of(context)?.close();
    }
  }
}

/// An action for [DxSlidable] which can show an icon, a label, or both.
class DxSlidableAction extends StatelessWidget {
  /// Creates a [DxSlidableAction].
  ///
  /// The [flex], [backgroundColor], [autoClose] and [spacing] arguments
  /// must not be null.
  ///
  /// You must set either an [icon] or a [label].
  ///
  /// The [flex] argument must also be greater than 0.
  const DxSlidableAction({
    Key? key,
    this.isShow = true,
    this.isDisabled = false,
    this.flex = _kFlex,
    this.color = _kBackgroundColor,
    this.textColor = Colors.white,
    this.autoClose = _kAutoClose,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label,
    this.borderRadius = BorderRadius.zero,
  })  : assert(flex > 0),
        assert(icon != null || label != null),
        super(key: key);

  /// 灰色
  const DxSlidableAction.grey({
    Key? key,
    this.isShow = true,
    this.isDisabled = false,
    this.flex = _kFlex,
    this.color = DxStyle.$CCCCCC,
    this.textColor = Colors.white,
    this.autoClose = _kAutoClose,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label = '编辑',
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  /// 危险
  const DxSlidableAction.danger({
    Key? key,
    this.isShow = true,
    this.isDisabled = false,
    this.flex = _kFlex,
    this.color = DxStyle.red,
    this.textColor = Colors.white,
    this.autoClose = _kAutoClose,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label = '删除',
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  /// 主题浅色，浅蓝
  const DxSlidableAction.primary({
    Key? key,
    this.isShow = true,
    this.isDisabled = false,
    this.flex = _kFlex,
    this.color = DxStyle.$6791FA,
    this.textColor = Colors.white,
    this.autoClose = _kAutoClose,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label = '编辑',
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  /// 主题深色，深蓝
  const DxSlidableAction.primaryDark({
    Key? key,
    this.isShow = true,
    this.isDisabled = false,
    this.flex = _kFlex,
    this.color = DxStyle.$3660C8,
    this.textColor = Colors.white,
    this.autoClose = _kAutoClose,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label = '编辑',
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  /// 警告
  const DxSlidableAction.warning({
    Key? key,
    this.isShow = true,
    this.isDisabled = false,
    this.flex = _kFlex,
    this.color = DxStyle.orange,
    this.textColor = Colors.white,
    this.autoClose = _kAutoClose,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label = '编辑',
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  /// 是否显示
  final bool isShow;

  /// 是否禁用
  final bool isDisabled;

  /// {@macro slidable.actions.flex}
  final int flex;

  /// {@macro slidable.actions.backgroundColor}
  final Color color;

  /// {@macro slidable.actions.foregroundColor}
  final Color textColor;

  /// {@macro slidable.actions.autoClose}
  final bool autoClose;

  /// {@macro slidable.actions.onPressed}
  final SlidableActionCallback? onPressed;

  /// An icon to display above the [label].
  final IconData? icon;

  /// The space between [icon] and [label] if both set.
  ///
  /// Defaults to 4.
  final double spacing;

  /// A label to display below the [icon].
  final String? label;

  /// Padding of the OutlinedButton
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    if (isShow == false) return const SizedBox.shrink();
    final children = <Widget>[];

    if (icon != null) {
      children.add(Icon(icon));
    }

    if (label != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: spacing));
      }
      children.add(Text(label!, overflow: TextOverflow.fade));
    }

    final child = children.length == 1
        ? children.first
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [...children.map((child) => Flexible(child: child))],
          );

    return DxCustomSlidableAction(
      isDisabled: isDisabled,
      borderRadius: borderRadius,
      onPressed: onPressed,
      autoClose: autoClose,
      backgroundColor: color,
      foregroundColor: textColor,
      flex: flex,
      child: child,
    );
  }
}
