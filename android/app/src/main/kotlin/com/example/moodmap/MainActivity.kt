package com.example.moodmap

import io.flutter.embedding.android.FlutterActivity
import com.google.android.gms.maps.MapsInitializer

class MainActivity: FlutterActivity() {
    MapsInitializer.initialize(this)
}