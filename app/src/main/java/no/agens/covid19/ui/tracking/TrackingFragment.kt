package no.agens.covid19.ui.tracking

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.fragment_tracking.*
import no.agens.covid19.CheckLocationPermissionsListener
import no.agens.covid19.MessageBus
import no.agens.covid19.R
import no.agens.covid19.messages.RequestLocationPermissions

class TrackingFragment : Fragment() {

    private var checkLocationPermissionListener: CheckLocationPermissionsListener? = null
    private lateinit var homeViewModel: HomeViewModel

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
            buttonActivateTracking.isEnabled = false
            MessageBus.publish(RequestLocationPermissions())
        }
    }

    override fun onResume() {
        buttonActivateTracking.isEnabled = true
        super.onResume()
    }

    fun setCheckLocationPermissionListener(listener: CheckLocationPermissionsListener) {
        this.checkLocationPermissionListener = listener
    }

    fun locationPermissionsGranted() {

        buttonActivateTracking.setText(R.string.tracking_button_is_active)
        buttonActivateTracking.setBackgroundColor(resources.getColor(R.color.tracking_active, context!!.theme))
    }
}
