import 'dart:async';

import 'package:flutter/services.dart';

class DxConnectivityPlugin {
  static const MethodChannel _channel = MethodChannel('com.dxwidget/channel');

  /// Retrieves package information from the platform.
  /// The result is cached.
  static Future<bool> isNetworkAvailable() async {
    return await _channel.invokeMethod('isNetworkAvailable');
  }
}
