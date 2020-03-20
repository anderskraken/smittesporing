//
//  RegistrationForm.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

protocol FormDelegate: NSObject {
    func showSummary(data: FormData)
    func cancelRegistration()
}


class RegistrationForm: UIView, FormInputDelegate {
    
    weak var delegate: FormDelegate?
    
    let progressBar = UIProgressView(progressViewStyle: .bar)
    let mainContent = FadingScrollView(fadingEdges: .vertical)
    let mainStack = UIStackView()
    let bottomContent = UIView()
    
    lazy var continueButton = MainButton(text: "Avbryt", type: .primary, action: nextPage)
    lazy var backButton = MainButton(text: "Tilbake", type: .secondary, action: previousPage)
    
    lazy var genderInput = FormInputSection(title: "Biologisk kjønn",
                                            input: FormRadioButton(choices: ["Mann", "Kvinne", "Ikke oppgi"], delegate: self))
    
    lazy var ageInput = FormInputSection(title: "Alder",
                                         input: FormTextField(placeholder: "Skriv inn alder", type: .numberPad, delegate: self))
    
    lazy var inRiskGroupInput = FormInputSection(title: "Er du i en risikogruppe?",
                                                 input: FormRadioButton(choices: ["Ja", "Nei"], delegate: self))
    
    lazy var testedPositiveInput = FormInputSection(title: "Har du fått påvist smitte av COVID-19?",
                                                    input: FormRadioButton(choices: ["Ja", "Nei"], delegate: self))
    
    lazy var suspectsInfectionInput = FormInputSection(title: "Har du mistanke om at du er smittet?",
                                                       input: FormRadioButton(choices: ["Ja", "Nei"], delegate: self))
    
    lazy var inContactWithInfectedPersonInput = FormInputSection(title: "Har du vært i kontakt med noen som har blitt smittet av COVID-19 de siste 14 dagene?",
                                                                 input: FormRadioButton(choices: ["Ja", "Nei / Vet ikke"], delegate: self))
    
    lazy var infectedContactDateInput = FormInputSection(title: "Når var du i kontakt med smittede?",
                                                         input: FormDatePicker(delegate: self))
    
    lazy var beenOutsideNordicInput = FormInputSection(title: "Har du vært utenfor Norden de siste 14 dagene?",
                                                       input: FormRadioButton(choices: ["Ja", "Nei"], delegate: self))
    
    lazy var returnedHomeDateInput = FormInputSection(title: "Når kom du til Norge?",
                                                      input: FormDatePicker(delegate: self))
    
    lazy var symptomsInput = FormInputSection(title: "Opplever du noen av følgende symptomer nå?",
                                              input: FormCheckBoxGroup(choices: ["Tørrhoste",
                                                                                 "Slitenhet eller utmattelse",
                                                                                 "Feber",
                                                                                 "Tung pust",
                                                                                 "Muskelsmerter",
                                                                                 "Diaré",
                                                                                 "Mistet smak eller luktesans"], delegate: self))
    
    var currentPage = 0
    
    init(delegate: FormDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupProgressBar()
        setupContent()
        nextPage()
        mainContent.addFilling(mainStack)
        initializeFields(with: LocalDataManager.shared.formData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 24, left: .margin, bottom: 0, right: .margin))
        }
        
        addSubview(mainContent)
        mainContent.showsVerticalScrollIndicator = false
        mainContent.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets.margins)
            make.top.equalTo(progressBar.snp.bottom).offset(CGFloat.margin)
        }
        
        addSubview(bottomContent)
        bottomContent.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(mainContent.snp.bottom)
        }
        
        let buttonContainer = setupButtons()
        bottomContent.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.margins)
        }
    }
    
    private func setupButtons() -> UIView {
        let buttonContainer = UIStackView()
        buttonContainer.axis = .horizontal
        buttonContainer.spacing = 7
        buttonContainer.distribution = .fillEqually
        buttonContainer.alignment = .fill
        buttonContainer.add(views: backButton, continueButton)
        return buttonContainer
    }
    
    private func setupProgressBar() {
        progressBar.progressTintColor = .blue
        progressBar.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        progressBar.layer.cornerRadius = 4.5
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(9)
        }
    }
    
    func nextPage() {
        if currentPage < 3 {
            showPage(currentPage + 1)
        } else {
            saveData()
        }
        didEditInput()
        mainContent.contentOffset = .zero
    }
    
    func previousPage() {
        if currentPage > 1 {
            showPage(currentPage - 1)
        } else {
            delegate?.cancelRegistration()
        }
        didEditInput()
        mainContent.contentOffset = .zero
    }
    
    func showPage(_ pageNumber: Int) {
        currentPage = pageNumber
        mainStack.removeAllSubviews()
        backButton.setTitle(currentPage == 1 ? "Avbryt" : "Tilbake", for: .normal)
        continueButton.setTitle(currentPage == 3 ? "Lagre informasjon" : "Neste", for: .normal)
        switch currentPage {
        case 1:
            progressBar.setProgress(0.025, animated: false)
            mainStack.addVertically(views: UILabel.title2("Om deg"), genderInput, ageInput, inRiskGroupInput, testedPositiveInput)
        case 2:
            progressBar.setProgress(0.5, animated: false)
            let optionalSuspicion = testedPositiveInput.value as? String == "Ja" ? nil : suspectsInfectionInput
            let optionalContactDate = inContactWithInfectedPersonInput.value as? String == "Ja" ? infectedContactDateInput : nil
            let optionalReturnDate = beenOutsideNordicInput.value as? String == "Ja" ? returnedHomeDateInput : nil
            mainStack.addVertically(views: UILabel.title2("Mulige smittekilder"), optionalSuspicion, inContactWithInfectedPersonInput, optionalContactDate, beenOutsideNordicInput, optionalReturnDate)
        default:
            progressBar.setProgress(1, animated: false)
            mainStack.addVertically(views: UILabel.title2("Symptomer"), symptomsInput, UIView(), UILabel.bodySmall("Hvis symptomene dine endrer seg, bør du registrere en endring."))
        }
    }
    
    func didEditInput() {
        if currentPage == 2 { showPage(2) } //Update conditional views
        
        let currentInputs = mainStack.subviews.compactMap { $0 as? FormInputSection }
        let hasEmptyInputs = currentInputs.contains(where: { $0.value == nil })
        toggleContinueButton(enabled: !hasEmptyInputs)
    }
    
    func toggleContinueButton(enabled: Bool) {
        continueButton.isEnabled = enabled
        continueButton.alpha = enabled ? 1 : 0.5
    }
    
    func initializeFields(with data: FormData?) {
        if let data = data {
            genderInput.set(value: data.gender)
            ageInput.set(value: data.age)
            inRiskGroupInput.set(value: data.inRiskGroup)
            testedPositiveInput.set(value: data.testedPositive)
            suspectsInfectionInput.set(value: data.suspectsInfection)
            inContactWithInfectedPersonInput.set(value: data.inContactWithInfectedPerson)
            infectedContactDateInput.set(value: data.infectedContactDate)
            beenOutsideNordicInput.set(value: data.beenOutsideNordic)
            returnedHomeDateInput.set(value: data.returnedHomeDate)
            symptomsInput.set(value: data.symptoms)
        }
    }
    
    func saveData() {
        let data = FormData(gender: genderInput.value as! String,
                            age: Int(ageInput.value as! String) ?? 0,
                            inRiskGroup: inRiskGroupInput.valueIsYes,
                            testedPositive: testedPositiveInput.valueIsYes,
                            suspectsInfection: suspectsInfectionInput.valueIsYes,
                            inContactWithInfectedPerson: inContactWithInfectedPersonInput.valueIsYes,
                            infectedContactDate: inContactWithInfectedPersonInput.valueIsYes ? infectedContactDateInput.value as? String : nil,
                            beenOutsideNordic: beenOutsideNordicInput.valueIsYes,
                            returnedHomeDate: beenOutsideNordicInput.valueIsYes ? returnedHomeDateInput.value as? String : nil,
                            symptoms: symptomsInput.value as! [String])
        LocalDataManager.shared.formData = data
        delegate?.showSummary(data: data)
    }
}
