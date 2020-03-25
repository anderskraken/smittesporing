//
//  ShareViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit
import MapKit

class ShareViewController: UIViewController {

    let infoText = """
    Alle opplysninger blir lagret sikkert på din telefon.

    Det er først hvis du får COVID-19-smitte du kan sende inn dine data.
    """
    
    let scrollView = FadingScrollView(fadingEdges: .vertical)
    
    lazy var infoLabel = UILabel.body(infoText)
    lazy var shareButton = MainButton(text: "Del data", type: .primary) {
        self.toggleViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = createTitle("Del data")
        
        addCenteredWithMargin(infoLabel)
        
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.margins)
        }
        
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.bottom.equalTo(shareButton.snp.top)
            make.left.right.equalToSuperview()
        }
        
        scrollView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
///We'll keep this enabled for now, for testing purposes
//        let cannotShareData = LocalStorageManager.getFormData()?.contaminationRisk != true
//        shareButton.isHidden = cannotShareData
//        if cannotShareData && !scrollView.isHidden {
//            toggleViews()
//        }
    }
    
    private func toggleViews() {
        if scrollView.isHidden {
            printShareData()
        }
        shareButton.set(type: scrollView.isHidden ? .secondary : .primary)
        shareButton.setTitle(scrollView.isHidden ? "Tilbake" : "Del data", for: .normal)
        scrollView.isHidden.toggle()
        infoLabel.isHidden.toggle()
    }
    
    private func printShareData() {
        var views = [UILabel.title3("FormData:")] as [UIView]

        if let form = LocalStorageManager.getFormData() {
            let mirroredForm = Mirror(reflecting: form)
            let formString = mirroredForm.children.map { field in
                "\(field.label?.capitalized ?? ""): \(field.value)"
            }.joined(separator: "\n")
            views.append(UILabel.bodySmall(formString).aligned(.left))
        } else {
            views.append(UILabel.bodySmall("Ikke oppgitt").aligned(.left))
        }
        
        let locations = LocalStorageManager.getLocations()
        let map = getMap(locations: locations)
        let locationLabels = locations.map {
            let lat = String(format: "%.10f", $0.coordinate.latitude)
            let long = String(format: "%.10f", $0.coordinate.longitude)
            return UILabel.bodySmall("\($0.timestamp.dateTimeString):\nLatitude: \(lat)\nLongitude: \(long)").aligned(.left)
        } as [UILabel]
        
        views.append(UILabel.title3("Movements:"))
        views.append(map)
        if locations.isEmpty {
            views.append(UILabel.bodySmall("Ingen bevegelser registrert").aligned(.left))
        } else {
            views.append(MainButton(text: "Slett lokasjonsdata", type: .secondary, action: showDeleteDialog))
            views.append(contentsOf: locationLabels)
        }
        scrollView.removeAllSubviews()
        scrollView.addFilling(UIStackView(spacing: 10, verticalViews: views), insets: UIEdgeInsets.margins)
    }
    
    private func getMap(locations: [CLLocation]) -> MKMapView {
        let map = MKMapView()
        map.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
                
        let annotations = locations.map { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.timestamp.prettyString.capitalizedFirstLetter
            return annotation
            } as [MKAnnotation]
        
        map.addAnnotations(annotations)
        map.showAnnotations(annotations, animated: false)
        return map
    }
    
    internal func showDeleteDialog() {
        let alertController = UIAlertController(title: "Slette data",
                                                message: "Er du sikker på at du vil slette lokasjonsdata?",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Slett", style: .default) { (_) -> Void in
            LocalStorageManager.deleteLocations()
            self.printShareData()
        }
        let cancelAction = UIAlertAction(title: "Acbryt", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true)
    }

}
