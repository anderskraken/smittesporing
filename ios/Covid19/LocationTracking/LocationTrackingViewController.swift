//
//  LocationTrackingViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTrackingViewController: UIViewController, CLLocationManagerDelegate {

    var trackingButton: MainButton!
    var infoBadge: InfoBadge!
    var locationManager: CLLocationManager?
    
    var trackingActive = false {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        addTitle("Bevegelser")
    }
    
    private func setupViews() {
        infoBadge = InfoBadge(text: "Sporing er ikke aktiv.", image: UIImage(named: "location"), tint: .darkGray)
        addCenteredWithMargin(infoBadge)

        trackingButton = MainButton(text: "Aktiver sporing", type: .primary, action: toggleTracking)
        view.addSubview(trackingButton)
        trackingButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets.horizontal)
        }

        let bottomInfo = UILabel.bodySmall("Lokasjonsdata lagres lokalt inntil du velger å dele disse.")
        view.addSubview(bottomInfo)
        bottomInfo.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.margins)
            make.top.equalTo(trackingButton.snp.bottom).offset(10)
        }
    }
    
    private func updateViews() {
        trackingButton.set(type: trackingActive ? .activated : .primary)
        trackingButton.setTitle(trackingActive ? "Sporing aktiv" : "Aktiver sporing", for: .normal)
        infoBadge.set(tint: trackingActive ? .blue : .darkGray)
        infoBadge.set(text: trackingActive
            ? "Sporing er aktiv. Det viktigste du kan gjøre er å holde avstand fra andre."
            : "Sporing er ikke aktiv.")
    }
    
    private func toggleTracking() {
        if trackingActive {
            trackingActive = false
        } else {
            enableTracking()
        }
    }
    private func enableTracking() {
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            trackingActive = true
        case .restricted, .denied:
            present(getSettingsDialog(), animated: true, completion: nil)
        case .notDetermined:
            requestLocationPermission()
        default:
            return
        }
    }
        
    private func requestLocationPermission() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    trackingActive = true
                }
            }
        }
    }

    private func getSettingsDialog() -> UIAlertController {
        let alertController = UIAlertController(title: "Trenger tilgang til posisjon", message: "Du kan gi tilgang til posisjonen din i innstillinger, for å registrere dine bevegelser.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Instillinger", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: "Acbryt", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        return alertController
    }
}
