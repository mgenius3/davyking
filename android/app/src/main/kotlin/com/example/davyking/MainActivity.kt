package com.example.davyking

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle
import android.webkit.WebView

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            WebView.setWebContentsDebuggingEnabled(true) // Enable debugging for WebView
        }
    }
}