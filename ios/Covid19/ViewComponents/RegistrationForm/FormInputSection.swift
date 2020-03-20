//
//  FormInputSection.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

protocol FormInput: UIView {
    var value: Any? { get }
}

protocol FormInputDelegate: NSObject {
    func didEditInput()
}

class FormInputSection: UIStackView {
    
    let input: FormInput
    
    var value: Any? { input.value }
    
    var valueIsYes: Bool { (input.value as? String)?.lowercased() == "ja" }
    
    init(title: String, input: FormInput) {
        self.input = input
        super.init(frame: .zero)
        addVertically(spacing: 12, views: UILabel.title3(title), input)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(value: Any?) {
        guard let value = value else { return }
        
        if let input = input as? FormRadioButton {
            if let bool = value as? Bool {
                input.setBoolValue(bool)
            } else {
                input.selectedChoice = value as? String
            }
        } else if let input = input as? FormTextField {
            if let intValue = value as? Int {
                input.text = String(intValue)
            } else if let stringValue = value as? String {
                input.text = stringValue
            }
        } else if let input = input as? FormDatePicker {
            if let stringValue = value as? String {
                input.text = stringValue
            }
        } else if let input = input as? FormCheckBoxGroup {
            if let choicesValue = value as? [String] {
                input.setSelected(choices: choicesValue)
            }
        }
    }
}
