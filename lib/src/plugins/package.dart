import 'dart:async';

import 'package:flutter/services.dart';

/// Application metadata. Provides application bundle information on iOS and
/// application package information on Android.
class DxPackagePlugin {
  static const MethodChannel _channel = MethodChannel('com.dxwidget/channel');

  static DxPackageItem? _packageInfo;

  /// Retrieves package information from the platform.
  /// The result is cached.
  static Future<DxPackageItem> getAppVersion() async {
    if (_packageInfo != null) {
      return _packageInfo!;
    }

    final resultMap = await _channel.invokeMethod('getAppVersion');
    return DxPackageItem(
      appName: resultMap['appName'],
      packageName: resultMap['packageName'],
      version: resultMap['version'],
      buildNumber: resultMap['buildNumber'],
    );
  }
}

class DxPackageItem {
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

  /// Constructs an instance with the given values for testing. [DxPackageItem]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  ///
  /// See [fromPlatform] for the right API to get a [DxPackageItem]
  /// that's actually populated with real data.
  DxPackageItem({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    this.installerStore,
  });
}
