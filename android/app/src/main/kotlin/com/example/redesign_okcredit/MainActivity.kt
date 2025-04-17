package com.example.credo

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        // Create the notification channel for Android 8.0 (Oreo) and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = getString(com.example.credo.R.string.default_notification_channel_id) // Get the channel ID from strings.xml
            val channelName = "Default Notifications" // Name of the notification channel
            val importance = NotificationManager.IMPORTANCE_DEFAULT // Set the importance level

            val channel = NotificationChannel(channelId, channelName, importance)

            // Register the channel with the system
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
}