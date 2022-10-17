import Flutter
import UIKit

public class SwiftDxwidgetPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.dxwidget/channel", binaryMessenger: registrar.messenger())
    let instance = SwiftDxwidgetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "getAppVersion":
            getAppVersion(result: result)
        case "isNetworkAvailable":
            isNetworkAvailable(result: result)
        default:
            result(FlutterMethodNotImplemented)
    }
  }
}


// 获取App版本
private func getAppVersion(result: FlutterResult) {
     let appStoreReceipt = Bundle.main.appStoreReceiptURL?.path
     let installerStore = appStoreReceipt?.contains("CoreSimulator") ?? false
                    ? "com.apple.simulator"
                    : appStoreReceipt?.contains("sandboxReceipt") ?? false
                        ? "com.apple.testflight"
                        : "com.apple"
    result([
        "appName": Bundle.main.object(
        forInfoDictionaryKey: "CFBundleDisplayName") ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? NSNull(),
        "packageName": Bundle.main.bundleIdentifier ?? NSNull(),
        "version": Bundle.main.object(
        forInfoDictionaryKey: "CFBundleShortVersionString") ?? NSNull(),
        "buildNumber": Bundle.main.object(
        forInfoDictionaryKey: "CFBundleVersion") ?? NSNull(),
        "installerStore": installerStore
    ])
}

// 检查网络
private func isNetworkAvailable(result: FlutterResult) {
    private let queue = DispatchQueue.global()
	private let monitor: NWPathMonitor = NWPathMonitor()
    monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                return true;
            } else {
                return false;
            }
        }
}