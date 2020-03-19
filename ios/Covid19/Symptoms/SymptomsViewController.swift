//
//  SymptomsViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController, FormDelegate {
    
    lazy var registrationForm = RegistrationForm(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismisser()
        if let data = LocalDataManager.shared.data {
            showSummary(data: data)
        } else {
            setupUnregisteredView()
        }
    }
    
    func setupUnregisteredView() {
        addTitle("Symptomer")
        
        let info = InfoBadge(text: "Du har ikke lagt inn noe informasjon.", image: UIImage(named: "person"), tint: .darkGray)
        addCenteredWithMargin(info)
        
        let registerButton = MainButton(text: "Registrer Informasjon", type: .primary, action: registerTapped)
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets.horizontal)
            make.top.equalTo(info.snp.bottom).offset(20)
        }
    }
    
    func setupForm() {
        addTitle("Registrer informasjon")
        let titleView = view.subviews.first!
        view.addSubview(registrationForm)
        registrationForm.showPage(1)
        registrationForm.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
        }
    }
    
    func setupSummary(data: RegisteredData) {
        addTitle("Oppsummering")
        let titleView = view.subviews.first!
        let scrollView = FadingScrollView(fadingEdges: .vertical)
        
        let message = InfoBadge(text: "Du må holde deg i hjemmekarantene frem til og med 28. mars.",
                             image: UIImage(named: "home"),
                             tint: .blue)
        

        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.horizontal)
            make.top.equalTo(titleView.snp.bottom).offset(24)
        }
        
        let editButton = MainButton(text: "Registrer endring", type: .primary) {
            self.registerTapped()
        }
        
        let shareButton = MainButton(text: "Del data", type: .secondary) {
            
        }
        
        let stack = UIStackView()
        stack.addVertically(views: message, SummaryView(data: data), editButton, shareButton)
        scrollView.addFilling(stack, insets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    private func registerTapped() {
        view.removeAllSubviews()
        setupForm()
    }
    
    func showSummary(data: RegisteredData) {
        view.removeAllSubviews()
        setupSummary(data: data)
    }
    
    func cancelRegistration() {
        view.removeAllSubviews()
        if let data = LocalDataManager.shared.data {
            showSummary(data: data)
        } else {
            setupUnregisteredView()
        }
    }
}
