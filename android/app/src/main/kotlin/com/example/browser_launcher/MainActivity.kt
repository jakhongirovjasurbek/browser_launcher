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
import android.Manifest
import android.content.ContentUris
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.DocumentsContract
import android.provider.MediaStore
import java.io.*
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sample.flutter.dev/path"
    private val INTENT_CHANNEL = "sample.flutter.dev/intentPath"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result -> if(call.method == "getFilePath"){
              // val filePath = getFilePath()
              var intent = getIntent()
              if(intent != null){
                val data = intent.getData()
                if(data != null){

                  val filePath = getAbsolutePath(this.context,data)
                  if(filePath != null){

                    result.success(filePath)
                } else {
                  result.error("UNAVAILABLE", "File path not available", null)
                }
               
                } else {
                  result.error("UNAVAILABLE", "File path not available", null)
                }
              } else {
                result.error("UNAVAILABLE", "File path not available", null)
              }
            }
            else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL).setMethodCallHandler {
          call, result -> if(call.method == "getIntentPath"){
            val uriString = call.argument<Any>("uri") as String
            val uri = Uri.parse(uriString)
            val filePath = getIntentPathOnShare(this.context, uri)
            if(filePath != null){

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
      return "$data"
      // val filePath = data?.getPath()
      // return "$filePath"
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


  private fun getAbsolutePath(context: Context, uri: Uri): String? {
    val context = this.context;

    var intent = getIntent()
    if(intent != null){
      val uri = intent.getData()
      if(uri != null){

    val isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT

    // DocumentProvider
    if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
        // ExternalStorageProvider
        if ("com.android.externalstorage.documents" == uri.authority) {
            val docId = DocumentsContract.getDocumentId(uri)
            val split = docId.split(":".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
            val type = split[0]

            if ("primary".equals(type, ignoreCase = true)) {
                return Environment.getExternalStorageDirectory().toString() + "/" + split[1]
            }

            // TODO handle non-primary volumes
        } else if ("com.android.providers.downloads.documents" == uri.authority) {

            val id = DocumentsContract.getDocumentId(uri)
            val contentUri = ContentUris.withAppendedId(
                    Uri.parse("content://downloads/public_downloads"), java.lang.Long.valueOf(id))

            return getDataColumn(context, contentUri, null, null)
        } else if ("com.android.providers.media.documents" == uri.authority) {
            val docId = DocumentsContract.getDocumentId(uri)
            val split = docId.split(":".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
            val type = split[0]

            var contentUri: Uri? = null
            when (type) {
                "image" -> contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                "video" -> contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                "audio" -> contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
            }

            if (contentUri == null) return null

            val selection = "_id=?"
            val selectionArgs = arrayOf(split[1])
            return getDataColumn(context, contentUri, selection, selectionArgs)
        }// MediaProvider
        // DownloadsProvider
    } else if ("content".equals(uri.scheme, ignoreCase = true)) {
        return getDataColumn(context, uri, null, null)
    }

    return uri.path
      } else {
        return null
      }
    } else {
      return null
    }
    
}

private fun getIntentPathOnShare(context: Context, uri: Uri): String? {

  val isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT

  // DocumentProvider
  if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
      // ExternalStorageProvider
      if ("com.android.externalstorage.documents" == uri.authority) {
          val docId = DocumentsContract.getDocumentId(uri)
          val split = docId.split(":".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
          val type = split[0]

          if ("primary".equals(type, ignoreCase = true)) {
              return Environment.getExternalStorageDirectory().toString() + "/" + split[1]
          }

          // TODO handle non-primary volumes
      } else if ("com.android.providers.downloads.documents" == uri.authority) {

          val id = DocumentsContract.getDocumentId(uri)
          val contentUri = ContentUris.withAppendedId(
                  Uri.parse("content://downloads/public_downloads"), java.lang.Long.valueOf(id))

          return getDataColumn(context, contentUri, null, null)
      } else if ("com.android.providers.media.documents" == uri.authority) {
          val docId = DocumentsContract.getDocumentId(uri)
          val split = docId.split(":".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
          val type = split[0]

          var contentUri: Uri? = null
          when (type) {
              "image" -> contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
              "video" -> contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
              "audio" -> contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
          }

          if (contentUri == null) return null

          val selection = "_id=?"
          val selectionArgs = arrayOf(split[1])
          return getDataColumn(context, contentUri, selection, selectionArgs)
      }// MediaProvider
      // DownloadsProvider
  } else if ("content".equals(uri.scheme, ignoreCase = true)) {
      return getDataColumn(context, uri, null, null)
  }

  return uri.path
  
}
fun getDataColumn(context: Context, uri: Uri?, selection: String?, selectionArgs: Array<String>?): String? {
  var cursor: Cursor? = null
  val column = "_data"
  val projection = arrayOf(column)
  try {
      if(uri != null){
        cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,null)
      if (cursor != null && cursor.moveToFirst()) {
          val column_index: Int = cursor.getColumnIndexOrThrow(column)
          return cursor.getString(column_index)
      }
      }
  } finally {
      if (cursor != null) cursor.close()
  }
  return null
}
}
