import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 三角角标组件
/// github地址：https://github.com/SM-SHIFAT/banner_listtile
/// 注意：这个组件只能用在stack组件中，因为有定位
class DxTriangleCornerBanner extends StatelessWidget {
  ///Banner position will be set [Left or Right] by value [false or true]
  final bool positionRight;

  ///Set banner size.
  ///Height & Width will be 1:1 aspect ratio.
  final double? bannerSize;

  ///Text that shown on the banner.
  final String text;

  final double textSize;

  ///Banner text color. [bannerTextColor = Colors.red]
  final Color textColor;

  ///Banner foreground color.
  final Color bannerColor;
  const DxTriangleCornerBanner({
    Key? key,
    this.positionRight = true,
    this.bannerSize,
    this.text = '',
    this.textSize = 12,
    this.textColor = Colors.white,
    this.bannerColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: positionRight == false ? 0 : null,
      right: positionRight == true ? 0 : null,
      child: ClipPath(
        clipper: _BannerClipper(positionRight),
        child: Container(
          decoration: BoxDecoration(color: bannerColor),
          height: bannerSize == null
              ? 40
              : bannerSize! >= 80
                  ? 80
                  : bannerSize! <= 40
                      ? 40.0
                      : bannerSize!, //40
          width: bannerSize == null
              ? 40
              : bannerSize! >= 80
                  ? 80
                  : bannerSize! <= 40
                      ? 40.0
                      : bannerSize!,
          child: Align(
            alignment: positionRight == false ? Alignment.topLeft : Alignment.topRight,
            child: Transform.rotate(
              angle: positionRight == false ? -math.pi / 4 : math.pi / 4,
              child: SizedBox(
                height: bannerSize == null
                    ? 30
                    : bannerSize! >= 80
                        ? (30.0 * 80.0) / 40.0
                        : bannerSize! <= 40
                            ? (30.0 * 40.0) / 40.0
                            : (30.0 * bannerSize!) / 40.0, //30
                width: bannerSize == null
                    ? 30
                    : bannerSize! >= 80
                        ? (30.0 * 80.0) / 40.0
                        : bannerSize! <= 40
                            ? (30.0 * 40.0) / 40.0
                            : (30.0 * bannerSize!) / 40.0,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2, top: 2, left: 2, bottom: 4),
                    child: Text(
                      text,
                      style: TextStyle(color: textColor, fontSize: bannerSize == null ? 12 : bannerSize! / 4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Custom banner container shape
class _BannerClipper extends CustomClipper<Path> {
  final bool? side;

  _BannerClipper(this.side);

  @override
  Path getClip(Size size) {
    var path = Path();

    if (side == null || side == true) {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.lineTo(size.width, 0);
      path.lineTo(0, size.height);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
