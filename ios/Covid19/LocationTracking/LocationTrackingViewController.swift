//
//  LocationTrackingViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTrackingViewController: UIViewController, LocationTrackingDelegate {

    var trackingButton: MainButton!
    var titleLabel: UIView!
    var statusIcon = UIButton()
    var statusLabel = UILabel.bodySmall("").aligned(.left)
    var scrollView = FadingScrollView(fadingEdges: .vertical)
    var centerStack = UIStackView()
    let trackingDisabledContainer = UIView()

    lazy var manager = LocationTrackingManager(delegate: self)
    
    var trackingEnabled: Bool {
        manager.trackingEnabled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateViews()
        LocalStorageManager.deleteLocations()
    }
    
    override func viewDidLayoutSubviews() {
        if titleLabel.frame.minY < UIEdgeInsets.safeAreaTop {
            titleLabel.snp.remakeConstraints { make in
                make.top.left.equalToSuperview().inset(UIEdgeInsets.safeMargins)
                make.height.equalTo(40)
            }
        }
        centerContent()
    }
    
    private func centerContent() {
        scrollView.layoutIfNeeded()
        let offset = (scrollView.frame.height - centerStack.frame.maxY) / 2
        scrollView.contentInset = UIEdgeInsets(top: max(.margin, offset), left: .margin, bottom: .margin, right: .margin)
    }

    private func setupViews() {
        titleLabel = createTitle("Bevegelser")
        view.addSubview(statusIcon)
        statusIcon.setImage(UIImage(named: "location"), for: .normal)
        statusIcon.add(for: .touchUpInside, manager.disableTracking)
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
        let inactiveBadge = InfoBadge.locationDisabled
        let trackingButton = MainButton(text: "Aktiver sporing", type: .primary, action: manager.enableTracking)
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
    
    private func showTrackingInfo() {
        if let timeStamp = manager.trackingStartedTimeStamp {
            if !timeStamp.isToday {
                if let lastLocation = manager.locations.last, !lastLocation.timestamp.isToday {
                    addScrollingContent(views: InfoCard.notMovedCard)
                } else {
                    addScrollingContent(views: InfoCard.stayHomeCard)
                }
            } else {
                addScrollingContent(views: InfoCard.trackingEnabledCard, InfoCard.stayHomeCard)
            }
        } else {
            addScrollingContent(views: InfoCard.trackingEnabledCard, InfoCard.stayHomeCard)
        }
        addDebugGesture()
    }
    
    private func addScrollingContent(views: UIView...) {
        centerStack.removeAllSubviews()
        centerStack.addVertically(views: views)
    }
    
    internal func updateViews() {
        let timeStamp = manager.trackingStartedTimeStamp?.prettyString
        statusLabel.text = trackingEnabled ? timeStamp != nil ? "Aktiv siden \(timeStamp!)" : "Sporing er aktivert" : "Sporing er ikke aktivert."
        statusIcon.tintColor = trackingEnabled ? .blue : .stroke
        trackingDisabledContainer.isHidden = trackingEnabled
        scrollView.isHidden = !trackingEnabled
        if trackingEnabled {
            showTrackingInfo()
        }
    }
    
    internal func showSettingsDialog() {
        let alertController = UIAlertController(title: "Trenger tilgang til posisjon",
                                                message: "Du kan gi tilgang til posisjonen din i innstillinger, for å registrere dine bevegelser.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Instillinger", style: .default) { (_) -> Void in
            guard let bundleId = Bundle.main.bundleIdentifier,
                let settingsUrl = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: "Acbryt", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true)
    }

    internal func showSignificantLocationUnavailableDialog() {
        let alertController = UIAlertController(title: "Kunne ikke starte bevegelsessporing.",
                                                message: "Din enhet støtter dessverre ikke lokasjonssporing.",
                                                preferredStyle: .alert)
        
        let dissmissAction = UIAlertAction(title: "Jeg forstår", style: .default, handler: nil)
        alertController.addAction(dissmissAction)
        present(alertController, animated: true)
    }

    private func addDebugGesture() {
        let gesture = UIRotationGestureRecognizer(target: self, action: #selector(debugPrintLocations))
        scrollView.subviews.first?.subviews.first?.addGestureRecognizer(gesture)
    }
    
    @objc private func debugPrintLocations(sender: UIRotationGestureRecognizer) {
        if sender.rotation > .pi / 2 {
            sender.isEnabled = false
            let locationLabels = LocalStorageManager.getLocations().map({
                let lat = String(format: "%.10f", $0.coordinate.latitude)
                let long = String(format: "%.10f", $0.coordinate.longitude)
                return UILabel.bodySmall("\($0.timestamp.prettyString.capitalized): \(lat), \(long)")
            }) as [UILabel]
            centerStack.removeAllSubviews()
            centerStack.addVertically(views: locationLabels)
        }
    }
}
