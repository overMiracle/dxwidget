package com.dxwidget.android.plugins

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build

/// github地址：https://github.com/praveen-gm/flutter_network_connectivity/blob/main/lib/flutter_network_connectivity.dart
class NetworkConnectivity : BroadcastReceiver() {

    private var connectivityListener: ConnectivityListener? = null

    override fun onReceive(context: Context?, intent: Intent?) {
        connectivityListener?.onNetworkConnectionChanged(
            isNetworkAvailable(context!!)
        )
    }

    fun setConnectivityListener(connectivityListener: ConnectivityListener) {
        this.connectivityListener = connectivityListener
    }

    interface ConnectivityListener {
        fun onNetworkConnectionChanged(isConnected: Boolean)
    }

    @Suppress("Deprecation")
    fun isNetworkAvailable(context: Context?): Boolean {
        /// Requires context to access SystemService
        if (context == null) return false

        val connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        /// Android SDK Version Q and above makes use of Network Capabilities
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val capabilities =
                connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            if (capabilities != null) {
                when {
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> {
                        return true
                    }
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> {
                        return true
                    }
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> {
                        return true
                    }
                }
            }
        } else {
            val activeNetworkInfo = connectivityManager.activeNetworkInfo
            if (activeNetworkInfo != null && activeNetworkInfo.isConnected) {
                return true
            }
        }
        return false
    }
}