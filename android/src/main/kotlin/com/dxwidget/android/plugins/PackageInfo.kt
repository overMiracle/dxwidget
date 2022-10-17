package com.dxwidget.android.plugins

import android.content.Context
import androidx.core.content.pm.PackageInfoCompat

/**
 * 获取版本信息
 */
class PackageInfo {

    fun  getAppVersion(applicationContext: Context): HashMap<String, String> {
        val packageManager = applicationContext.packageManager
        val info = packageManager.getPackageInfo(applicationContext.packageName, 0)
        val infoMap = HashMap<String, String>()
        infoMap
        infoMap.apply {
            put("appName", info.applicationInfo.loadLabel(packageManager).toString())
            put("packageName", applicationContext.packageName)
            put("version", info.versionName)
            put("buildNumber", PackageInfoCompat.getLongVersionCode(info).toString())
        }
        return infoMap
    }
}