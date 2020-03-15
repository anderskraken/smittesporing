package no.agens.covid19

import android.Manifest
import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.VersionedPackage
import android.os.Build
import android.os.Bundle
import com.google.android.material.bottomnavigation.BottomNavigationView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import no.agens.covid19.ui.tracking.TrackingFragment
import timber.log.Timber

class MainActivity : AppCompatActivity(), CheckLocationPermissionsListener {

    companion object {
        const val ACCESS_LOCATION_PERMISSION_REQUEST_CODE = 42
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val navView: BottomNavigationView = findViewById(R.id.nav_view)

        val navController = findNavController(R.id.nav_host_fragment)
        // Passing each menu ID as a set of Ids because each
        // menu should be considered as top level destinations.
//        val appBarConfiguration = AppBarConfiguration(setOf(
//            R.id.navigation_home, R.id.navigation_dashboard))
//        setupActionBarWithNavController(navController, appBarConfiguration)
        navView.setupWithNavController(navController)
    }

    override fun onAttachFragment(fragment: Fragment) {
        super.onAttachFragment(fragment)
        if(fragment is NavHostFragment) {
            val trackingFragment = fragment.childFragmentManager.findFragmentById(R.id.fragment_tracking) as TrackingFragment
            trackingFragment.setCheckLocationPermissionListener(this)
        }
    }

    override fun checkLocationPermissions() {
        val permissionAccessCoarseLocationApproved = ActivityCompat
            .checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) ==
                PackageManager.PERMISSION_GRANTED

        if (permissionAccessCoarseLocationApproved && Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val backgroundLocationPermissionApproved = ActivityCompat
                .checkSelfPermission(this, Manifest.permission.ACCESS_BACKGROUND_LOCATION) ==
                    PackageManager.PERMISSION_GRANTED

            if (backgroundLocationPermissionApproved) {
                // App can access location both in the foreground and in the background.
                // Start your service that doesn't have a foreground service type
                // defined.
            } else {
                // App can only access location in the foreground. Display a dialog
                // warning the user that your app must have all-the-time access to
                // location in order to function properly. Then, request background
                // location.
                ActivityCompat.requestPermissions(this,
                    arrayOf(Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                    ACCESS_LOCATION_PERMISSION_REQUEST_CODE
                )
            }
        } else {
            // App doesn't have access to the device's location at all. Make full request
            // for permission.
            ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                ACCESS_LOCATION_PERMISSION_REQUEST_CODE
            )
        }
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>,
        grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == ACCESS_LOCATION_PERMISSION_REQUEST_CODE) {
            val granted = grantResults[0] == PackageManager.PERMISSION_GRANTED
            if (granted) {
                Timber.d("We have location access!")
                val trackingFragment =
                    supportFragmentManager.findFragmentById(R.id.fragment_tracking) as TrackingFragment
                trackingFragment.locationPermissionsGranted()
            } else {
                AlertDialog.Builder(this)
                    .setTitle(R.string.dialog_require_location_title)
                    .setMessage(R.string.dialog_require_location_message)
                    .setNegativeButton(R.string.generic_no) { dialog, _ -> dialog.dismiss() }
                    .setPositiveButton(R.string.generic_yes) { dialog, _ ->
                        dialog.dismiss()
                        checkLocationPermissions()
                    }.show()
            }
        }
    }

}
