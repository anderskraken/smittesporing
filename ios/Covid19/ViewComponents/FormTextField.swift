//
//  FormTextField.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class FormTextField: UITextField, FormInput, UITextFieldDelegate {
    
    weak var formInputDelegate: FormInputDelegate?
    var value: Any? { text?.isEmpty != false ? nil : text }
    
    init(placeholder: String, type: UIKeyboardType, delegate: FormInputDelegate) {
        self.formInputDelegate = delegate
        super.init(frame: .zero)
        self.delegate = self
        setup(placeholder: placeholder, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(placeholder: String, type: UIKeyboardType) {
        self.placeholder = placeholder
        font = UIFont.medium(size: 18)
        keyboardType = .numberPad
        textColor = .textBlack
        backgroundColor = .white
        layer.borderWidth = 2
        layer.borderColor = .stroke
        layer.cornerRadius = 6
        snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        formInputDelegate?.didEditInput()
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

