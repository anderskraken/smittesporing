package no.agens.covid19.ui.tracking

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.fragment_tracking.*
import no.agens.covid19.*

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
        buttonActivateTracking.isEnabled = false
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

        val theme = context!!.theme

        buttonActivateTracking.isEnabled = true
        buttonActivateTracking.setText(R.string.tracking_button_is_active)
        buttonActivateTracking.setBackgroundColor(
            resources.getColor(R.color.button_green, theme))
        trackingIcon.setImageDrawable(
            resources.getDrawable(R.drawable.tracking_arrow_active, theme))
        textTrackingState.text = resources.getString(R.string.tracking_is_active)

        val intent = Intent(context, LocationTrackerService::class.java)
        if (AppInfo.isOreoOrNewer()) {
            context!!.startForegroundService(intent)
        } else {
            context!!.startService(intent)
        }
        buttonActivateTracking.setOnClickListener {
            disableTracking()
        }
    }

    private fun disableTracking() {
        val theme = context!!.theme
        buttonActivateTracking.setText(R.string.tracking_activate_tracking_button_text)
        buttonActivateTracking.setOnClickListener { activateTracking() }
        buttonActivateTracking.setBackgroundColor(resources.getColor(R.color.colorPrimary, theme))
        trackingIcon.setImageDrawable(
            resources.getDrawable(R.drawable.tracking_arrow_disabled, theme))
        context!!.stopService(Intent(context, LocationTrackerService::class.java))
    }

}
