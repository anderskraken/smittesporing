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
        if let data = LocalStorageManager.formData {
            showSummary(data: data)
        } else {
            setupUnregisteredView()
        }
    }
    
    func setupUnregisteredView() {
        addTitle("Symptomer")
        
        let info = InfoBadge.noInfoRegistered
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
    
    func setupSummary(data: FormData) {
        addTitle("Oppsummering")
        let titleView = view.subviews.first!
        let scrollView = FadingScrollView(fadingEdges: .vertical)
        let message = getMessage(data: data)

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
        
        let stack = UIStackView(verticalViews: message, SummaryView(data: data), editButton, shareButton)
        scrollView.addFilling(stack, insets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    private func getMessage(data: FormData) -> InfoBadge {
        if data.symptoms.count > 3 { //Not official criteria
            return InfoBadge.symptomsWarning
        } else if data.beenOutsideNordic || data.inContactWithInfectedPerson {
            
            let returnedDate = Date.fromDatePicker(string: data.returnedHomeDate ?? "")
            let contactDate = Date.fromDatePicker(string: data.infectedContactDate ?? "")
            
            if let lastDate = [returnedDate, contactDate].compactMap({$0}).sorted().last,
                let quaranteenDate = lastDate.addingDays(14) {
                return InfoBadge.quaranteen(date: quaranteenDate)
            } else if !data.beenOutsideNordic {
                return InfoBadge.quaranteenContact
            } else if !data.inContactWithInfectedPerson {
                return InfoBadge.quaranteenTravel
            } else {
                return InfoBadge.quaranteenNoDate
            }
        } else {
            return InfoBadge.keepStayingSafe
        }
    }
    
    private func registerTapped() {
        view.removeAllSubviews()
        setupForm()
    }
    
    func showSummary(data: FormData) {
        view.removeAllSubviews()
        setupSummary(data: data)
    }
    
    func cancelRegistration() {
        view.removeAllSubviews()
        if let data = LocalStorageManager.formData {
            showSummary(data: data)
        } else {
            setupUnregisteredView()
        }
    }
}
