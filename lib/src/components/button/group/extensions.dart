import 'package:flutter/material.dart';

import 'defined.dart';

/// Make [MainAxisAlignment] from [DxGroupButtonMainAlignment]
extension DxGroupButtonMainAxis on DxGroupButtonMainAlignment {
  MainAxisAlignment toAxis() {
    switch (this) {
      case DxGroupButtonMainAlignment.center:
        return MainAxisAlignment.center;
      case DxGroupButtonMainAlignment.end:
        return MainAxisAlignment.end;
      case DxGroupButtonMainAlignment.start:
        return MainAxisAlignment.start;
      case DxGroupButtonMainAlignment.spaceAround:
        return MainAxisAlignment.spaceAround;
      case DxGroupButtonMainAlignment.spaceBetween:
        return MainAxisAlignment.spaceBetween;
      case DxGroupButtonMainAlignment.spaceEvenly:
        return MainAxisAlignment.spaceEvenly;
    }
  }
}

/// Make [CrossAxisAlignment] from [DxGroupButtonCrossAlignment]
extension DxGroupButtonRunAxis on DxGroupButtonCrossAlignment {
  CrossAxisAlignment toAxis() {
    switch (this) {
      case DxGroupButtonCrossAlignment.center:
        return CrossAxisAlignment.center;
      case DxGroupButtonCrossAlignment.end:
        return CrossAxisAlignment.end;
      case DxGroupButtonCrossAlignment.start:
        return CrossAxisAlignment.start;
    }
  }
}

/// Make [WrapAlignment] from [MainGroupAlignment]
extension DxGroupButtonMainWrap on DxGroupButtonMainAlignment {
  WrapAlignment toWrap() {
    switch (this) {
      case DxGroupButtonMainAlignment.center:
        return WrapAlignment.center;
      case DxGroupButtonMainAlignment.end:
        return WrapAlignment.end;
      case DxGroupButtonMainAlignment.start:
        return WrapAlignment.start;
      case DxGroupButtonMainAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case DxGroupButtonMainAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case DxGroupButtonMainAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }
}

/// Make [WrapCrossAlignment] from [CrossGroupAlignment]
extension DxGroupButtonCrossWrap on DxGroupButtonCrossAlignment {
  WrapCrossAlignment toWrap() {
    switch (this) {
      case DxGroupButtonCrossAlignment.center:
        return WrapCrossAlignment.center;
      case DxGroupButtonCrossAlignment.end:
        return WrapCrossAlignment.end;
      case DxGroupButtonCrossAlignment.start:
        return WrapCrossAlignment.start;
    }
  }
}

/// Make [WrapAlignment] from [GroupRunAlignment]
extension DxGroupButtonRunWrap on DxGroupButtonRunAlignment {
  WrapAlignment toWrap() {
    switch (this) {
      case DxGroupButtonRunAlignment.center:
        return WrapAlignment.center;
      case DxGroupButtonRunAlignment.end:
        return WrapAlignment.end;
      case DxGroupButtonRunAlignment.start:
        return WrapAlignment.start;
      case DxGroupButtonRunAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case DxGroupButtonRunAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case DxGroupButtonRunAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }
}
