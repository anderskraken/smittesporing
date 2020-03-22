package no.agens.covid19.ui.information.Symptoms

import android.content.Context
import android.content.SharedPreferences
import androidx.lifecycle.LiveData
import kotlinx.serialization.json.Json

const val SYMPTOMTS_KEY = "userSymptoms"
const val SYMPTOMS_SHARED_PREFS = "smittesporing_prefs"

class SymptomsViewModel(context: Context) : SharedPreferenceLiveData<Symptoms?>(
    context.getSharedPreferences(SYMPTOMS_SHARED_PREFS, Context.MODE_PRIVATE), SYMPTOMTS_KEY
) {
    override fun getValueFromPreferences(key: String): Symptoms? {
        val json = sharedPrefs.getString(key, null)
        return if (json != null) {
            Json.parse(Symptoms.serializer(), json)
        } else {
            null
        }
    }
}

/**
 * Thankju, Internet: https://stackoverflow.com/a/53028546/5892676
 */
abstract class SharedPreferenceLiveData<T>(
    val sharedPrefs: SharedPreferences,
    val key: String
) : LiveData<T>() {

    private val preferenceChangeListener =
        SharedPreferences.OnSharedPreferenceChangeListener { sharedPreferences, key ->
            if (key == this.key) {
                value = getValueFromPreferences(key)
            }
        }

    abstract fun getValueFromPreferences(key: String): T?

    override fun onActive() {
        super.onActive()
        value = getValueFromPreferences(key)
        sharedPrefs.registerOnSharedPreferenceChangeListener(preferenceChangeListener)
    }

    override fun onInactive() {
        sharedPrefs.unregisterOnSharedPreferenceChangeListener(preferenceChangeListener)
        super.onInactive()
    }
}