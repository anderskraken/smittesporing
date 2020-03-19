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
    var locationManager: CLLocationManager?
    var statusIcon = UIButton()
    var statusLabel = UILabel.bodySmall("")
    var centerStack = UIStackView()
    var bottomInfo = UIView()
    var trackingTime: Date? = LocalDataManager.shared.getTrackingTime()
    
    var trackingActive = LocalDataManager.shared.getTracking() {
        didSet {
            trackingTime = trackingActive ? Date() : nil
            LocalDataManager.shared.saveLocal(trackingEnabled: trackingActive, time: trackingTime)
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateViews()
    }
    
    override func viewDidLayoutSubviews() {
        let title = createTitle("Bevegelser")
        statusIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalTo(title.snp.right).offset(10)
            make.centerY.equalTo(title)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(title)
        }
    }
    
    private func setupViews() {
        view.addSubview(statusLabel)
        view.addSubview(statusIcon)
        statusIcon.setImage(UIImage(named: "location"), for: .normal)
        statusIcon.add(for: .touchUpInside) {
            self.trackingActive = false
        }
        
        centerStack.clipsToBounds = false
        addCenteredWithMargin(centerStack)

        trackingButton = MainButton(text: "Aktiver sporing", type: .primary, action: toggleTracking)
        view.addSubview(trackingButton)
        trackingButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets.horizontal)
        }

        bottomInfo = UILabel.bodySmall("Lokasjonsdata lagres lokalt inntil du velger å dele disse.")
        view.addSubview(bottomInfo)
        bottomInfo.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.margins)
            make.top.equalTo(trackingButton.snp.bottom).offset(10)
        }
    }
    
    private func updateViews() {
        trackingButton.set(type: trackingActive ? .activated : .primary)
        trackingButton.setTitle(trackingActive ? "Sporing aktiv" : "Aktiver sporing", for: .normal)
        statusLabel.text = trackingActive ? "Aktiv siden \(trackingTime?.prettyString ?? "")" : "Sporing er ikke aktivert."
        statusIcon.tintColor = trackingActive ? .blue : .stroke
        bottomInfo.isHidden = trackingActive
        trackingButton.isHidden = trackingActive
        if trackingActive {
            showTrackingInfo()
        } else {
            showTrackingDisabledInfo()
        }
    }
    
    private func showTrackingDisabledInfo() {
        centerStack.removeAllSubviews()
        let info = InfoBadge(text: "Sporing er ikke aktiv.", image: UIImage(named: "location"), imageTint: .stroke)
        centerStack.addVertically(views: info)
    }

    private func showTrackingInfo() {
        centerStack.removeAllSubviews()
        let activatedInfo = InfoCard(text: "Smittesporing er aktivert. Takk for at du bidrar!",
                            image: UIImage(named: "tada"), imageTint: .blue)
        let stayHomeInfo = InfoCard(text: "Det viktigste du kan gjøre er å holde avstand fra andre.",
                            image: UIImage(named: "hand"), imageTint: .blue)
        centerStack.addVertically(views: activatedInfo, stayHomeInfo)
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
