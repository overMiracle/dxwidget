package com.dxwidget.android

import android.content.Context
import android.content.pm.PackageManager
import com.dxwidget.android.plugins.Install
import com.dxwidget.android.plugins.NetworkConnectivity
import com.dxwidget.android.plugins.PackageInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** DxwidgetPlugin  */
class DxwidgetPlugin : MethodCallHandler, FlutterPlugin {
    private var applicationContext: Context? = null
    private var methodChannel: MethodChannel? = null

    companion object {
        private const val CHANNEL_NAME = "com.dxwidget/channel"
    }

    /** Plugin registration.  */
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        applicationContext = null
        methodChannel!!.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "getAppVersion" -> result.success(PackageInfo().getAppVersion(applicationContext!!))
                "isNetworkAvailable" -> result.success(NetworkConnectivity().isNetworkAvailable(applicationContext))
                "installApk" -> {
                    val filePath = call.argument<String>("filePath")
                    val appId = call.argument<String>("appId")
                    try {
                        Install().installApk(filePath, appId)
                        result.success("Success")
                    } catch (e: Throwable) {
                        result.error(e.javaClass.simpleName, e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        } catch (ex: PackageManager.NameNotFoundException) {
            result.error("Name not found", ex.message, null)
        }
    }
}
