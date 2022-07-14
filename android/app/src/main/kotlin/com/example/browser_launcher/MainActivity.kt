package com.example.browser_launcher

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.ContentResolver
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import kotlin.error
import java.io.BufferedReader

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sample.flutter.dev/battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result -> if(call.method == "getFilePath"){
              val filePath = getFilePath()

              if(filePath != null && filePath != ""){
                result.success(filePath)
              } else {
                result.error("UNAVAILABLE", "File path not available", null)
              }
            }
            else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }

    return batteryLevel
  }

  private fun getFilePath(): String? {
    var intent = getIntent()
    if(intent == null){
      return "Intent is set to null"
    } else {
      val data = intent.getData()
      val filePath = data?.getPath()
      return "$filePath"
    }
  }

  private fun checkFileOpening(intent: Intent) : String? {
    if (intent.action == Intent.ACTION_VIEW && (intent.scheme == ContentResolver.SCHEME_FILE
                    || intent.scheme == ContentResolver.SCHEME_CONTENT)) {

        val text = intent.data?.let {
            contentResolver.openInputStream(it)?.bufferedReader()?.use(BufferedReader::readText) 
        }
        return text;
    }
    return null
  }
}
