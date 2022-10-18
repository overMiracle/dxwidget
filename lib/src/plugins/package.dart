import 'dart:async';

import 'package:flutter/services.dart';

/// Application metadata. Provides application bundle information on iOS and
/// application package information on Android.
class DxPackagePlugin {
  DxPackagePlugin._();
  static const MethodChannel _channel = MethodChannel('com.dxwidget/channel');

  static DxPackageInfo? _packageInfo;

  /// Retrieves package information from the platform.
  /// The result is cached.
  static Future<DxPackageInfo> getAppVersion() async {
    if (_packageInfo != null) {
      return _packageInfo!;
    }

    final resultMap = await _channel.invokeMethod('getAppVersion');
    return DxPackageInfo(
      appName: resultMap['appName'],
      packageName: resultMap['packageName'],
      version: resultMap['version'],
      buildNumber: resultMap['buildNumber'],
    );
  }
}

class DxPackageInfo {
  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  final String buildNumber;

  /// The installer store. Indicates through which store this application was installed.
  final String? installerStore;

  /// Constructs an instance with the given values for testing. [DxPackageInfo]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  DxPackageInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    this.installerStore,
  });
}
