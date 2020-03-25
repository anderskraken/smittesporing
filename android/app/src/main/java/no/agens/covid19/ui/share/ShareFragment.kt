package no.agens.covid19.ui.share

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.findFragment
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import kotlinx.android.synthetic.main.fragment_share.*
import kotlinx.coroutines.*
import kotlinx.coroutines.Dispatchers.Main
import no.agens.covid19.R
import no.agens.covid19.storage.LocationRepository
import org.koin.android.ext.android.inject
import kotlin.coroutines.CoroutineContext

class ShareFragment : Fragment(), OnMapReadyCallback, CoroutineScope {


    private lateinit var job: Job
    override val coroutineContext: CoroutineContext
        get() = job + Dispatchers.IO

    private val locationRepository: LocationRepository by inject()

    override fun onCreate(savedInstanceState: Bundle?) {
        job = SupervisorJob()
        super.onCreate(savedInstanceState)
    }

    override fun onDestroy() {
        super.onDestroy()
        job.cancel()
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_share, container, false)
    }

    override fun onAttachFragment(childFragment: Fragment) {
        super.onAttachFragment(childFragment)
        if (childFragment is SupportMapFragment) {
            childFragment.getMapAsync(this)
        }
    }

    override fun onMapReady(map: GoogleMap) {

        launch {

            val allLocations = locationRepository.getAllLocations()

            launch(Main) {
                allLocations.forEach {

                    // Add a marker in Sydney, Australia,
                    // and move the map's camera to the same location.
                    val location = LatLng(it.latitude, it.longitude)
                    map.addMarker(MarkerOptions().position(location)
                        .title("Your location at ${it.timestamp}"))
                }

                val lastLocation = allLocations.last()
                map.moveCamera(
                    CameraUpdateFactory.newLatLngZoom(
                        LatLng(lastLocation.latitude, lastLocation.longitude), 15.0f))
            }
        }

    }

}
