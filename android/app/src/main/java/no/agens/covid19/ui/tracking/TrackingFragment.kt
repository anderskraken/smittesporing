package no.agens.covid19.ui.tracking

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.View.VISIBLE
import android.view.ViewGroup
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.fragment_tracking.*
import no.agens.covid19.*
import no.agens.covid19.preferences.PreferencesRepository

class TrackingFragment : Fragment() {


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return inflater.inflate(R.layout.fragment_tracking, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        buttonActivateTracking.setOnClickListener {
            activateTracking()
        }
    }

    private fun activateTracking() {
        val context = this.context ?: return
        buttonActivateTracking.isEnabled = false
        PreferencesRepository.enableTracking(context)
        MessageBus.publish(RequestLocationPermissions)
    }

    override fun onResume() {
        buttonActivateTracking.isEnabled = true
        super.onResume()

        val permissionAccessFineLocationApproved = ActivityCompat
            .checkSelfPermission(context!!, Manifest.permission.ACCESS_FINE_LOCATION) ==
                PackageManager.PERMISSION_GRANTED

        val permissionAccessBackgroundApproved =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) ActivityCompat
                .checkSelfPermission(context!!,
                    Manifest.permission.ACCESS_BACKGROUND_LOCATION) == PackageManager.PERMISSION_GRANTED else true

        if (permissionAccessBackgroundApproved && permissionAccessFineLocationApproved) {
            locationPermissionsGranted()
        } else {
            requireContext().stopService(Intent(context, LocationTrackerService::class.java))
        }

        MessageBus.onBusChanged(this) {
            when (it) {
                is LocationAccessGranted -> {
                    locationPermissionsGranted()
                }
            }
        }
    }

    private fun locationPermissionsGranted() {

        val context = this.context ?: return

        if (PreferencesRepository.trackingActivelyDisabled(context)) {
            return
        }
        val theme = context.theme

        containerTrackingNotActive.apply {
            animate().alpha(0f).setDuration(500).start()
        }

        containerCards.alpha = 0f
        containerCards.visibility = VISIBLE
        containerCards.apply {
            animate().alpha(1f).setDuration(500).start()
        }

        imageTrackingHeaderIcon.setImageDrawable(
            resources.getDrawable(R.drawable.tracking_arrow_active, theme))
        textTrackingState.text = resources.getString(R.string.tracking_is_active)

        val intent = Intent(context, LocationTrackerService::class.java)
        if (AppInfo.isOreoOrNewer()) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }

        // TODO add tracking active card to recycler view
    }

    private fun disableTracking() {
        val context = this.context ?: return
        val theme = context.theme

        PreferencesRepository.disableTracking(context)

        buttonActivateTracking.setText(R.string.tracking_activate_tracking_button_text)
        buttonActivateTracking.setOnClickListener { activateTracking() }
        buttonActivateTracking.setBackgroundColor(resources.getColor(R.color.colorPrimary, theme))
        trackingIcon.setImageDrawable(
            resources.getDrawable(R.drawable.tracking_arrow_disabled, theme))
        context.stopService(Intent(context, LocationTrackerService::class.java))
    }

}
