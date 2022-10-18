package com.dxwidget.android

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import com.dxwidget.android.plugins.NetworkConnectivity
import com.dxwidget.android.plugins.PackageInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.io.FileNotFoundException

/** DxwidgetPlugin  */
class DxwidgetPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {

    companion object {
        const val installRequestCode = 1234
        private const val CHANNEL_NAME = "com.dxwidget/channel"
    }

    private var apkFile: File? = null
    private var appId: String? = null
    private var pluginBinding: ActivityPluginBinding? = null
    private var currentActivity: Activity? = null
    private var activityResultListener = PluginRegistry.ActivityResultListener { requestCode, resultCode, data ->

        if (resultCode == Activity.RESULT_OK && requestCode == installRequestCode) {
            install24(pluginBinding?.activity, apkFile, appId)
            true
        } else {
            false
        }
    }
    private var applicationContext: Context? = null
    private var methodChannel: MethodChannel? = null



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
                        installApk(filePath, appId)
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


    ///////////////////// 以下是安装apk的代码//////////////////////////////////////////////////////////////////
    private fun installApk(filePath: String?, currentAppId: String?) {
        if (filePath == null) throw NullPointerException("fillPath is null!")
        val activity: Activity =
            pluginBinding?.activity ?: throw NullPointerException("context is null!")

        val file = File(filePath)
        if (!file.exists()) throw FileNotFoundException("$filePath is not exist! or check permission")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            if (canRequestPackageInstalls(activity)) install24(activity, file, currentAppId)
            else {
                showSettingPackageInstall(activity)
                apkFile = file
                appId = currentAppId
            }
        } else {
            installBelow24(activity, file)
        }
    }
    private fun showSettingPackageInstall(activity: Activity) { // todo to test with android 26
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
            intent.data = Uri.parse("package:" + activity.packageName)
            activity.startActivityForResult(intent, installRequestCode)
        } else {
            throw RuntimeException("VERSION.SDK_INT < O")
        }

    }

    private fun canRequestPackageInstalls(activity: Activity): Boolean {
        return Build.VERSION.SDK_INT <= Build.VERSION_CODES.O || activity.packageManager.canRequestPackageInstalls()
    }

    private fun installBelow24(context: Context, file: File?) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val uri = Uri.fromFile(file)
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        context.startActivity(intent)
    }

    /**
     * android24及以上安装需要通过 ContentProvider 获取文件Uri，
     * 需在应用中的AndroidManifest.xml 文件添加 provider 标签，
     * 并新增文件路径配置文件 res/xml/provider_path.xml
     * 在android 6.0 以上如果没有动态申请文件读写权限，会导致文件读取失败，你将会收到一个异常。
     * 插件中不封装申请权限逻辑，是为了使模块功能单一，调用者可以引入独立的权限申请插件
     */
    private fun install24(context: Context?, file: File?, appId: String?) {
        if (context == null) throw NullPointerException("context is null!")
        if (file == null) throw NullPointerException("file is null!")
        if (appId == null) throw NullPointerException("appId is null!")
        val intent = Intent(Intent.ACTION_VIEW)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        val uri: Uri = FileProvider.getUriForFile(context, "$appId.fileProvider.install", file)
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        context.startActivity(intent)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        pluginBinding = binding
        startListeningToActivity(binding.activity)
        registerListeners()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        stopListening()
        deregisterListeners()
    }

    private fun startListeningToActivity(
        activity: Activity
    ) {
        currentActivity = activity
    }

    private fun registerListeners() {
        pluginBinding?.addActivityResultListener(activityResultListener)
    }

    private fun deregisterListeners() {
        pluginBinding?.removeActivityResultListener(activityResultListener)
    }


    private fun stopListening() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        currentActivity = null

    }

}
