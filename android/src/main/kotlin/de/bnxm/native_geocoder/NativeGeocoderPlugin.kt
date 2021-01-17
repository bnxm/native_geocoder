package de.bnxm.native_geocoder

import android.content.Context
import android.location.Geocoder
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

class NativeGeocoderPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private var geocoder: Geocoder? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "native_geocoder")
        channel.setMethodCallHandler(this)

        context = binding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "get_addresses" -> getAddresses(result, GeocodeRequest.parse(call.arguments))
            "is_present" -> result.success(Geocoder.isPresent())
        }
    }

    private fun getAddresses(result: Result, req: GeocodeRequest) {
        val geocoder = Geocoder(
            context,
            req.locale?.let { Locale(it) } ?: Locale.getDefault()
        )

        try {
            val addresses = geocoder.getFromLocation(req.latitude, req.longitude, req.maxResults)

            result.success(addresses.map { it.toMap() })
        } catch (e: Exception) {
            result.error("error", e.message, null)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
