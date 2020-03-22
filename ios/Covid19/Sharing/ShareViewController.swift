//
//  ShareViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

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
        let cannotShareData = LocalStorageManager.getFormData()?.contaminationRisk != true
        shareButton.isHidden = cannotShareData
        if cannotShareData && !scrollView.isHidden {
            toggleViews()
        }
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
        var labels = [UILabel.title3("FormData:")]

        if let form = LocalStorageManager.getFormData() {
            let mirroredForm = Mirror(reflecting: form)
            let formString = mirroredForm.children.map { field in
                "\(field.label?.capitalized ?? ""): \(field.value)"
            }.joined(separator: "\n")
            labels.append(UILabel.bodySmall(formString).aligned(.left))
        } else {
            labels.append(UILabel.bodySmall("Ikke oppgitt").aligned(.left))
        }
        
        let locationLabels = LocalStorageManager.getLocations().map {
            let lat = String(format: "%.10f", $0.coordinate.latitude)
            let long = String(format: "%.10f", $0.coordinate.longitude)
            return UILabel.bodySmall("\($0.timestamp.dateTimeString):\nLatitude: \(lat)\nLongitude: \(long)").aligned(.left)
        } as [UILabel]
        
        labels.append(UILabel.title3("Movements:"))
        labels.append(contentsOf: locationLabels)
        
        scrollView.removeAllSubviews()
        scrollView.addFilling(UIStackView(spacing: 10, verticalViews: labels), insets: UIEdgeInsets.margins)
    }
}
