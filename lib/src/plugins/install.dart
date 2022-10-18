import 'dart:async';

import 'package:flutter/services.dart';

/// 安装软件包插件
class DxInstallPlugin {
  static const MethodChannel _channel = MethodChannel('com.dxwidget/channel');

  /// for Android : install apk by its file absolute path;
  /// if the target platform is higher than android 24:
  /// a [appId] is required
  /// (the caller's applicationId which is defined in build.gradle)
  static Future<String?> installApk(String filePath, String appId) async {
    Map<String, String> params = {'filePath': filePath, 'appId': appId};
    return await _channel.invokeMethod('installApk', params);
  }

  /// for iOS: go to app store by the url
  static Future<String?> gotoAppStore(String urlString) async {
    // Map<String, String> params = {'urlString': urlString};
    // return await _channel.invokeMethod('gotoAppStore', params);
    return '';
  }
}
