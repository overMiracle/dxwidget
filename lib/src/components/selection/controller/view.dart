import 'package:dxwidget/src/utils/index.dart';
import 'package:flutter/material.dart';

class DxSelectionListViewController extends ChangeNotifier {
  int menuIndex;
  bool isShow; //是否显示下拉筛选列表

  double? listViewTop; //下拉筛选列表顶部坐标
  double? screenHeight;
  OverlayEntry? entry; //显示下拉筛选列表的图层

  DxSelectionListViewController({this.menuIndex = -1, this.isShow = false});

  void show(int index) {
    isShow = true;
    menuIndex = index;
    notifyListeners();
  }

  void hide() {
    isShow = false;
    entry?.remove();
    entry = null;
    notifyListeners();
  }
}

class DxSelectionViewController {
  void closeSelectionView() => DxEventBus.instance.fire(CloseSelectionViewEvent());

  void refreshSelectionTitle() => DxEventBus.instance.fire(RefreshMenuTitleEvent());
}

abstract class BaseSelectionEvent {}

class RefreshMenuTitleEvent extends BaseSelectionEvent {}

class CloseSelectionViewEvent extends BaseSelectionEvent {}
