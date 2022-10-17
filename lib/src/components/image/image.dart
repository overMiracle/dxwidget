import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

/// 增强版的 img 标签，提供多种图片填充模式，支持图片懒加载、加载中提示、加载失败提示。
class DxImage extends StatelessWidget {
  const DxImage({
    Key? key,
    this.width,
    this.height,
    this.src,
    this.fit = BoxFit.fill,
    this.round = false,
    this.radius = 5,
    this.showError = true,
    this.showLoading = true,
    this.child,
    this.loadingWidget,
    this.errorWidget,
    this.onLoad,
    this.onError,
    this.onClick,
  }) : super(key: key);

  // ****************** Props ******************
  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 图片链接
  final String? src;

  /// 图片填充模式
  final BoxFit fit;

  /// 圆角大小，默认5
  final double radius;

  /// 是否显示为圆形,如果为ture，radius就无效了
  final bool round;

  /// 是否展示图片加载失败提示
  final bool showError;

  /// 是否展示图片加载失败提示
  final bool showLoading;

  /// 自定义加载中的提示内容
  final Widget? loadingWidget;

  /// 自定义加载失败时的提示内容
  final Widget? errorWidget;

  /// 自定义图片下方的内容
  final Widget? child;

  /// 图片加载完毕时触发
  final VoidCallback? onLoad;

  /// 图片加载失败时触发
  final VoidCallback? onError;

  /// 点击图片时触发
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    final DxImageThemeData themeData = DxImageTheme.of(context);

    Widget image = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildImage(themeData),
        child ?? const SizedBox.shrink(),
      ],
    );

    if (round) {
      image = ClipOval(child: image);
    } else {
      image = ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
    }

    return Semantics(image: true, excludeSemantics: false, child: image);
  }

  /// 构建图片Loading图标
  Widget _buildLoading() {
    return _DxImagePlaceHolder(
      width: width,
      height: height,
      child: loadingWidget ??
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(color: DxStyle.gray3, strokeWidth: 1),
          ),
    );
  }

  Widget _buildError() {
    return _DxImagePlaceHolder(
      width: width,
      height: height,
      child: errorWidget ??
          Image.asset(
            DxAsset.brokenImage,
            width: width,
            height: height,
            fit: BoxFit.contain,
            package: 'dxwidget',
          ),
    );
  }

  /// 构建图片内容
  Widget _buildImage(DxImageThemeData themeData) {
    if (src == null || src == '') {
      return Image.asset(DxAsset.defaultImage, width: width, height: height, fit: fit, package: 'dxwidget');
    }

    final bool isNetwork = RegExp('^https?://').hasMatch(src!);

    if (isNetwork) {
      return Image.network(
        src!,
        width: width,
        height: height,
        loadingBuilder: (_, Widget child, ImageChunkEvent? loadingProgress) {
          if (src != null && src!.isNotEmpty && loadingProgress == null) {
            return child;
          }

          return showLoading ? _buildLoading() : const SizedBox.shrink();
        },
        errorBuilder: (_, Object error, StackTrace? stackTrace) {
          return showError ? _buildError() : const SizedBox.shrink();
        },
        fit: fit,
      );
    }

    return Image.asset(src!, width: width, height: height, fit: fit);
  }
}

class _DxImagePlaceHolder extends StatelessWidget {
  const _DxImagePlaceHolder({
    Key? key,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final DxImageThemeData themeData = DxImageTheme.of(context);

    return DefaultTextStyle(
      style: TextStyle(
        color: themeData.placeholderTextColor,
        fontSize: themeData.placeholderFontSize,
      ),
      child: Container(
        width: width,
        height: height,
        color: themeData.placeholderBackgroundColor,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
