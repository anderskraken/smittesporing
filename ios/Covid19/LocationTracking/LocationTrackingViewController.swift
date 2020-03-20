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
    var titleLabel: UIView!
    var statusIcon = UIButton()
    var statusLabel = UILabel.bodySmall("").aligned(.left)
    var scrollView = FadingScrollView(fadingEdges: .vertical)
    var centerStack = UIStackView()
    var bottomInfo = UIView()
    var trackingTime: Date? = LocalDataManager.shared.getTrackingTime()
    let trackingDisabledContainer = UIView()

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
        titleLabel.snp.remakeConstraints { make in
            make.top.left.equalToSuperview().inset(UIEdgeInsets.safeMargins)
            make.height.equalTo(40)
        }
        centerContent()
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        centerContent()
//    }
    
    private func centerContent() {
        scrollView.layoutIfNeeded()
        let offset = (scrollView.frame.height - centerStack.frame.maxY) / 2
        scrollView.contentInset = UIEdgeInsets(top: max(.margin, offset), left: .margin, bottom: .margin, right: .margin)
    }

    private func setupViews() {
        titleLabel = createTitle("Bevegelser")
        view.addSubview(statusIcon)
        statusIcon.setImage(UIImage(named: "location"), for: .normal)
        statusIcon.add(for: .touchUpInside) { self.trackingActive = false }
        statusIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleLabel)
        }
        
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets.margins
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom)
        }
        
        scrollView.addSubview(centerStack)
        centerStack.clipsToBounds = false
        centerStack.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(UIEdgeInsets.margins)
            make.left.right.top.bottom.equalToSuperview()
        }
        
        setupTrackingDisabledViews()
    }
    
    private func setupTrackingDisabledViews() {
        let inactiveBadge = InfoBadge(text: "Sporing er ikke aktiv.", image: UIImage(named: "location"), imageTint: .stroke)
        let trackingButton = MainButton(text: "Aktiver sporing", type: .primary, action: toggleTracking)
        let bottomInfo = UILabel.bodySmall("Lokasjonsdata lagres lokalt inntil du velger å dele disse.")
        let badgeContainer = UIView()
        
        view.addSubview(trackingDisabledContainer)
        trackingDisabledContainer.addSubview(badgeContainer)
        trackingDisabledContainer.addSubview(trackingButton)
        trackingDisabledContainer.addSubview(bottomInfo)
        trackingDisabledContainer.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.margins)
        }
        
        badgeContainer.addSubview(inactiveBadge)
        badgeContainer.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(trackingButton.snp.top)
        }

        inactiveBadge.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(CGFloat.margin)
            make.bottom.lessThanOrEqualToSuperview().inset(-CGFloat.margin)
            make.center.equalToSuperview().priority(.low)
            make.width.equalToSuperview()
        }

        trackingButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        bottomInfo.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(trackingButton.snp.bottom).offset(10)
        }
    }


    private func updateViews() {
        statusLabel.text = trackingActive ? "Aktiv siden \(trackingTime?.prettyString ?? "")" : "Sporing er ikke aktivert."
        statusIcon.tintColor = trackingActive ? .blue : .stroke
        trackingDisabledContainer.isHidden = trackingActive
        scrollView.isHidden = !trackingActive
        if trackingActive {
            showTrackingInfo()
        }
    }
    
    private func showTrackingInfo() {
//        addScrollingContent(views: InfoCard.trackingEnabledCard, InfoCard.stayHomeCard, InfoCard.notMovedCard, InfoCard.riskDetectedCard)
        addScrollingContent(views: InfoCard.trackingEnabledCard, InfoCard.stayHomeCard)
    }
    
    private func addScrollingContent(views: UIView...) {
        centerStack.removeAllSubviews()
        centerStack.addVertically(views: views)
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
