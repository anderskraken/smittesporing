package no.agens.covid19

import android.app.*
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.Looper
import com.google.android.gms.location.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import no.agens.covid19.storage.LocationRepository
import no.agens.covid19.storage.domain.Location
import org.koin.android.ext.android.inject
import timber.log.Timber
import java.text.SimpleDateFormat
import java.util.*
import kotlin.coroutines.CoroutineContext

class LocationTrackerService : Service(), CoroutineScope {

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationRequest: LocationRequest
    private lateinit var locationCallback: LocationCallback

    private val locationRepository: LocationRepository by inject()

    private lateinit var job: Job

    override val coroutineContext: CoroutineContext
        get() = job + Dispatchers.IO

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        job = Job()
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


                launch {
                    val formatter = SimpleDateFormat.getDateTimeInstance()
                    locationResult.locations.forEach { location ->

                        val lastLocation = locationRepository.getLast()
                        val distanceToLast = android.location.Location("Last point").apply {
                            latitude = lastLocation.latitude
                            longitude = lastLocation.longitude
                            altitude = lastLocation.altitude
                        }.distanceTo(location)

                        if (distanceToLast > DISTANCE_SAVE_THRESHOLD) {

                            Timber.d(
                                "Distance to last location is $distanceToLast meters. Saving it!")

                            locationRepository.addLocations(
                                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {

                                    Location(longitude = location.longitude,
                                        latitude = location.latitude,
                                        altitude = location.altitude,
                                        timestamp = formatter.format(Date()),
                                        horizontalAccuracy = location.accuracy)
                                } else {
                                    Location(longitude = location.longitude,
                                        latitude = location.latitude,
                                        timestamp = formatter.format(Date()),
                                        altitude = location.altitude,
                                        horizontalAccuracy = location.accuracy,
                                        bearingAccuracy = location.bearingAccuracyDegrees,
                                        verticalAccuracy = location.verticalAccuracyMeters)
                                })
                        } else {
                            Timber.d(
                                "Distance between last location and new is $distanceToLast meters. Will not be stored because it's less than $DISTANCE_SAVE_THRESHOLD meters")
                        }
                    }
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
        job.cancel()
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
            .setSmallIcon(R.drawable.tracking_arrow_active)
            .setContentIntent(pendingIntent)
            .setTicker(getText(R.string.background_notification_message))
            .build()
    }

    companion object {
        const val CHANNEL_ID: String = "${BuildConfig.APPLICATION_ID}_general"
        const val SERVICE_ID = 424242
        const val DISTANCE_SAVE_THRESHOLD = 5.0
    }

}