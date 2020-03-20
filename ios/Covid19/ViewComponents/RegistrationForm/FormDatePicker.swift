//
//  FormDatePicker.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class FormDatePicker: UITextField, FormInput, UITextFieldDelegate {
    
    let datePicker = UIDatePicker()
    
    weak var formInputDelegate: FormInputDelegate?
    
    var value: Any? { text?.isEmpty != false ? nil : text }
    
    override var text: String? {
        didSet { formInputDelegate?.didEditInput() }
    }
    
    init(delegate: FormInputDelegate) {
        self.formInputDelegate = delegate
        super.init(frame: .zero)
        self.delegate = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.placeholder = "Velg dato"
        font = UIFont.medium(size: 18)
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

        let icon = UIImageView(image: UIImage(named: "calendar")).tinted(.darkGray)
        let iconView = UIView()
        iconView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14))
        }
        rightView = iconView
        rightViewMode = .always

        datePicker.datePickerMode = .date
        inputView = datePicker
        
        datePicker.add(for: .valueChanged) {
            self.dateChanged(date: self.datePicker.date)
        }
    }
    
    func dateChanged(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        text = formatter.string(from: date)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dateChanged(date: datePicker.date)
        formInputDelegate?.didEditInput()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

