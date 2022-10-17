// The MIT License (MIT)
//
// Copyright (c) 2020 nslogx
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import 'package:dxwidget/src/components/toast/index.dart';
import 'package:dxwidget/src/components/toast/toast.dart';
import 'package:flutter/material.dart';

class DxToastTheme {
  /// color of indicator
  static Color get indicatorColor => DxToast.instance.style == DxToastStyle.custom
      ? DxToast.instance.indicatorColor!
      : DxToast.instance.style == DxToastStyle.dark
          ? Colors.white.withOpacity(0.85)
          : Colors.black;

  /// progress color of loading
  static Color get progressColor => DxToast.instance.style == DxToastStyle.custom
      ? DxToast.instance.progressColor!
      : DxToast.instance.style == DxToastStyle.dark
          ? Colors.white
          : Colors.black;

  /// background color of loading
  static Color get backgroundColor => DxToast.instance.style == DxToastStyle.custom
      ? DxToast.instance.backgroundColor!
      : DxToast.instance.style == DxToastStyle.dark
          ? Colors.black54
          : Colors.white;

  /// boxShadow color of loading
  static List<BoxShadow>? get boxShadow =>
      DxToast.instance.style == DxToastStyle.custom ? DxToast.instance.boxShadow ?? [const BoxShadow()] : null;

  /// font color of status
  static Color get textColor => DxToast.instance.style == DxToastStyle.custom
      ? DxToast.instance.textColor!
      : DxToast.instance.style == DxToastStyle.dark
          ? Colors.white
          : Colors.black;

  /// mask color of loading
  static Color maskColor(DxToastMaskType? maskType) {
    maskType ??= DxToast.instance.maskType;
    return maskType == DxToastMaskType.custom
        ? DxToast.instance.maskColor!
        : maskType == DxToastMaskType.black
            ? Colors.black26
            : Colors.transparent;
  }

  /// loading animation
  static DxToastAnimation get loadingAnimation {
    DxToastAnimation animation;
    switch (DxToast.instance.animationStyle) {
      case DxToastAnimationStyle.custom:
        animation = DxToast.instance.customAnimation!;
        break;
      case DxToastAnimationStyle.offset:
        animation = DxToastOffsetAnimation();
        break;
      case DxToastAnimationStyle.scale:
        animation = DxToastScaleAnimation();
        break;
      default:
        animation = DxToastOpacityAnimation();
        break;
    }
    return animation;
  }

  /// font size of status
  static double get fontSize => DxToast.instance.fontSize;

  /// size of indicator
  static double get indicatorSize => DxToast.instance.indicatorSize;

  /// width of progress indicator
  static double get progressWidth => DxToast.instance.progressWidth;

  /// width of indicator
  static double get lineWidth => DxToast.instance.lineWidth;

  /// loading indicator type
  static DxToastIndicatorType get indicatorType => DxToast.instance.indicatorType;

  /// toast position
  static DxToastPosition get toastPosition => DxToast.instance.toastPosition;

  /// toast position
  static AlignmentGeometry alignment(DxToastPosition? position) => position == DxToastPosition.bottom
      ? AlignmentDirectional.bottomCenter
      : (position == DxToastPosition.top ? AlignmentDirectional.topCenter : AlignmentDirectional.center);

  /// display duration
  static Duration get displayDuration => DxToast.instance.displayDuration;

  /// animation duration
  static Duration get animationDuration => DxToast.instance.animationDuration;

  /// contentPadding of loading
  static EdgeInsets get contentPadding => DxToast.instance.contentPadding;

  /// padding of status
  static EdgeInsets get textPadding => DxToast.instance.textPadding;

  /// textAlign of status
  static TextAlign get textAlign => DxToast.instance.textAlign;

  /// textStyle of status
  static TextStyle? get textStyle => DxToast.instance.textStyle;

  /// radius of loading
  static double get radius => DxToast.instance.radius;

  /// should dismiss on user tap
  static bool? get dismissOnTap => DxToast.instance.dismissOnTap;

  static bool ignoring(DxToastMaskType? maskType) {
    maskType ??= DxToast.instance.maskType;
    return DxToast.instance.userInteractions ?? (maskType == DxToastMaskType.none ? true : false);
  }
}
