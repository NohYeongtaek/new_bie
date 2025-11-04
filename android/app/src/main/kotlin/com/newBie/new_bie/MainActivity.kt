package com.newBie.new_bie

import android.util.Log
import androidx.core.net.toFile
import gun0912.tedimagepicker.builder.TedImagePicker
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
            "com.myApp.app/image")
            .setMethodCallHandler { call, result ->
                if (call.method =="getImageUri") {
                    showImagePicker(result)
                } else {
                    result.notImplemented()
                }
            }
    }
    private fun showImagePicker(result: MethodChannel.Result) {

        TedImagePicker.with(this)
            .start { uri ->
                val file = if (uri.scheme =="content") {
                    val inputStream = contentResolver.openInputStream(uri)
                    val tempFile = File(cacheDir,"temp_image_${System.currentTimeMillis()}.png")
                    inputStream?.use { input ->
                        tempFile.outputStream().use { output  ->
                            input.copyTo(output)
                        }
                    }
                    tempFile
                } else {
                    uri.toFile()
                }
                Log.d("이미지 선택 uri", "showImagePicker - uri: $uri")
                val imageUri = uri.toString()
                result.success(file.path)
            }
    }
}
