package no.agens.covid19

import android.app.*
import android.content.Intent
import android.os.IBinder
import android.os.Looper
import com.google.android.gms.location.*
import timber.log.Timber

class LocationTrackerService : Service() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationRequest: LocationRequest
    private lateinit var locationCallback: LocationCallback

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()

        startForeground(SERVICE_ID, buildNotification())

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(applicationContext)

        locationRequest = LocationRequest.create()
        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        locationRequest.interval = 30_000

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult?) {
                if (locationResult == null) {
                    return
                }

                locationResult.locations.forEach { location ->
                    Timber.d("received location: ${location.latitude}, ${location.longitude}")
                }
            }
        }

        fusedLocationClient.requestLocationUpdates(locationRequest,
            locationCallback,
            Looper.getMainLooper())

        Timber.d("LocationTrackerService is running in the background.")

    }

    override fun onDestroy() {
        super.onDestroy()

        fusedLocationClient.removeLocationUpdates(locationCallback)
        Timber.d("LocationTrackerService is shutting down.")
    }

    private fun buildNotification(): Notification {
        if (AppInfo.isOreoOrNewer()) {
            val name = getString(R.string.channel_name)
            val descriptionText = getString(R.string.channel_description)
            val importance = NotificationManager.IMPORTANCE_MIN
            val channel = NotificationChannel(CHANNEL_ID, name, importance)
            channel.description = descriptionText
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)

        }

        val pendingIntent: PendingIntent =
            Intent(this, MainActivity::class.java).let { notificationIntent ->
                PendingIntent.getActivity(this, 0, notificationIntent, 0)
            }


        val builder = if (AppInfo.isOreoOrNewer()) Notification.Builder(this,
            CHANNEL_ID) else Notification.Builder(this)
        return builder
            .setContentTitle(getText(R.string.background_notification_title))
            .setContentText(getText(R.string.background_notification_message))
            .setSmallIcon(R.drawable.ic_launcher_background)
            .setContentIntent(pendingIntent)
            .setTicker(getText(R.string.background_notification_message))
            .build()
    }

    companion object {
        const val CHANNEL_ID: String = "${BuildConfig.APPLICATION_ID}_general"
        const val SERVICE_ID = 424242
    }
}