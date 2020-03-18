package no.agens.covid19.preferences

import android.content.Context

object PreferencesRepository {

    private const val APP_PREFERENCES_NAME = "covid19_prefs"

    fun trackingActivelyDisabled(context: Context): Boolean =
        preferences(context).getBoolean(Keys.TRACKING_DISABLED, false)

    fun disableTracking(context: Context) {
        preferences(context).edit().putBoolean(Keys.TRACKING_DISABLED, true).apply()
    }

    fun enableTracking(context: Context) {
        preferences(context).edit().remove(Keys.TRACKING_DISABLED).apply()
    }

    private fun preferences(context: Context) =
        context.getSharedPreferences(APP_PREFERENCES_NAME, Context.MODE_PRIVATE)

    private object Keys {
        const val TRACKING_DISABLED = "tracking_disabled"
    }
}
