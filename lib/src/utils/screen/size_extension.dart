import 'dart:math';

import 'package:flutter/material.dart';

import 'util.dart';

extension SizeExtension on num {
  ///[DxScreenUtil.setWidth]
  double get w => DxScreenUtil().setWidth(this);

  ///[DxScreenUtil.setHeight]
  double get h => DxScreenUtil().setHeight(this);

  ///[DxScreenUtil.radius]
  double get r => DxScreenUtil().radius(this);

  ///[DxScreenUtil.setSp]
  double get sp => DxScreenUtil().setSp(this);

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get sm => min(toDouble(), sp);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => DxScreenUtil().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => DxScreenUtil().screenHeight * this;

  ///[DxScreenUtil.setHeight]
  Widget get verticalSpace => DxScreenUtil().setVerticalSpacing(this);

  ///[DxScreenUtil.setVerticalSpacingFromWidth]
  Widget get verticalSpaceFromWidth => DxScreenUtil().setVerticalSpacingFromWidth(this);

  ///[DxScreenUtil.setWidth]
  Widget get horizontalSpace => DxScreenUtil().setHorizontalSpacing(this);

  ///[DxScreenUtil.radius]
  Widget get horizontalSpaceRadius => DxScreenUtil().setHorizontalSpacingRadius(this);

  ///[DxScreenUtil.radius]
  Widget get verticalSpacingRadius => DxScreenUtil().setVerticalSpacingRadius(this);
}

extension EdgeInsetsExtension on EdgeInsets {
  /// Creates adapt insets using r [SizeExtension].
  EdgeInsets get r => copyWith(
        top: top.r,
        bottom: bottom.r,
        right: right.r,
        left: left.r,
      );
}

extension BorderRaduisExtension on BorderRadius {
  /// Creates adapt BorderRadius using r [SizeExtension].
  BorderRadius get r => copyWith(
        bottomLeft: bottomLeft.r,
        bottomRight: bottomRight.r,
        topLeft: topLeft.r,
        topRight: topRight.r,
      );
}

extension RaduisExtension on Radius {
  /// Creates adapt Radius using r [SizeExtension].
  Radius get r => Radius.elliptical(x.r, y.r);
}

extension BoxConstraintsExtension on BoxConstraints {
  /// Creates adapt BoxConstraints using r [SizeExtension].
  BoxConstraints get r => copyWith(
        maxHeight: maxHeight.r,
        maxWidth: maxWidth.r,
        minHeight: minHeight.r,
        minWidth: minWidth.r,
      );

  /// Creates adapt BoxConstraints using h-w [SizeExtension].
  BoxConstraints get hw => copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.w,
        minHeight: minHeight.h,
        minWidth: minWidth.w,
      );
}
