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

class LocationTrackingManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
    weak var delegate: LocationTrackingDelegate?
    
    private(set) var trackingStartedTimeStamp: Date? = LocalStorageManager.getTrackingStartedTimeStamp()
    private(set) var trackingEnabled = LocalStorageManager.getTrackingEnabled()
    
    var locations: [CLLocation] {
        LocalStorageManager.getLocations()
    }

    init(delegate: LocationTrackingDelegate) {
        self.delegate = delegate
        super.init()
        locationManager.delegate = self
    }
    
    private func setTracking(enabled: Bool) {
        trackingEnabled = enabled
        trackingStartedTimeStamp = enabled ? Date() : nil
        LocalStorageManager.save(trackingEnabled: enabled, timeStamp: trackingStartedTimeStamp)
        delegate?.updateViews()
    }

    func disableTracking() {
        locationManager.stopMonitoringSignificantLocationChanges()
        setTracking(enabled: false)
    }

    func enableTracking() {
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways:
            startMySignificantLocationChanges()
        case .restricted, .denied, .authorizedWhenInUse:
            delegate?.showSettingsDialog()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default:
            return
        }
    }
    
    func startMySignificantLocationChanges() {
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
            delegate?.showSignificantLocationUnavailableDialog()
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.allowsBackgroundLocationUpdates = true
        setTracking(enabled: true)
    }
}

extension LocationTrackingManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if !trackingEnabled {
                startMySignificantLocationChanges()
            }
        } else if trackingEnabled {
            disableTracking()
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LocalStorageManager.save(locations: locations)
    }
}
