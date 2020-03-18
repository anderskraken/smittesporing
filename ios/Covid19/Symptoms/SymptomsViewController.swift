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
        setupUnregisteredView()
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
        registrationForm.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
        }
    }
    
    private func registerTapped() {
        view.removeAllSubviews()
        setupForm()
    }
    
    func registered(data: RegisteredData) {
        print(data)
    }
}
