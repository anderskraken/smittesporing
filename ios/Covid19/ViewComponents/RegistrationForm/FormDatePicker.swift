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
        iconView.isUserInteractionEnabled = false
        iconView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14))
        }
        rightView = iconView
        rightViewMode = .always
        
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        inputAccessoryView = createDoneToolbar()
        inputView = datePicker
        addTapAnimations()
    }
    
    func dateChanged(date: Date) {
        text = date.datePickerString
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
    
    private func createDoneToolbar() -> UIToolbar {
        let doneButton = UIBarButtonItem(title: "Ferdig", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endEditing(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.black
        toolbar.sizeToFit()
        toolbar.setItems([ spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }
}
