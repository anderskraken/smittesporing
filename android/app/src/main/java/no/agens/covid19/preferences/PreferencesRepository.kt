package no.agens.covid19.preferences

import android.content.Context
import java.util.*

object PreferencesRepository {

    private const val APP_PREFERENCES_NAME = "covid19_prefs"

    fun trackingActivelyDisabled(context: Context): Boolean =
        preferences(context).getBoolean(Keys.TRACKING_DISABLED, false)

    fun disableTracking(context: Context) {
        preferences(context).edit().putBoolean(Keys.TRACKING_DISABLED, true).apply()
    }

    fun enableTracking(context: Context) {
        preferences(context).edit()
            .putLong(Keys.TRACKING_ENABLED_TIMESTAMP, System.currentTimeMillis()).apply()
        preferences(context).edit().remove(Keys.TRACKING_DISABLED).apply()
    }

    fun getTrackingEnabledTimestamp(context: Context): Date {
        return Date(preferences(context).getLong(Keys.TRACKING_ENABLED_TIMESTAMP, 0))
    }

    private fun preferences(context: Context) =
        context.getSharedPreferences(APP_PREFERENCES_NAME, Context.MODE_PRIVATE)

    private object Keys {
        const val TRACKING_DISABLED = "tracking_disabled"
        const val TRACKING_ENABLED_TIMESTAMP = "tracking_enabled_timestamp"
    }
}
