//
//  LocationTrackingManager.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 21/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import CoreLocation

protocol LocationTrackingDelegate: NSObject {
    func updateViews()
    func showSettingsDialog()
    func showSignificantLocationUnavailableDialog()
}

class LocationTrackingManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    weak var delegate: LocationTrackingDelegate?
    
    private(set) var trackingStartedTimeStamp: Date? = LocalStorageManager.getTrackingStartedTimeStamp()

    private(set) var trackingEnabled = LocalStorageManager.getTrackingEnabled() {
        didSet {
            trackingStartedTimeStamp = trackingEnabled ? Date() : nil
            LocalStorageManager.save(trackingEnabled: trackingEnabled, timeStamp: trackingStartedTimeStamp)
            delegate?.updateViews()
        }
    }

    init(delegate: LocationTrackingDelegate) {
        self.delegate = delegate
        super.init()
        locationManager.delegate = self
    }
    
    func disableTracking() {
        locationManager.stopMonitoringSignificantLocationChanges()
        trackingEnabled = false
    }

    func enableTracking() {
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            startMySignificantLocationChanges()
        case .restricted, .denied:
            delegate?.showSettingsDialog()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            startMySignificantLocationChanges()
        }
    }
    
    func startMySignificantLocationChanges() {
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
            delegate?.showSignificantLocationUnavailableDialog()
            return
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringSignificantLocationChanges()
        trackingEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LocalStorageManager.save(locations: locations)
    }
}
