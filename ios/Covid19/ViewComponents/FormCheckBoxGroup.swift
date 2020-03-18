//
//  FormCheckBoxGroup.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class FormCheckBoxGroup: UIStackView, FormInput {
    
    weak var delegate: FormInputDelegate?
    var value: Any? { selectedChoices }
    
    var choices: [String]
    var selectedChoices = [String]()
    
    init(choices: [String], delegate: FormInputDelegate) {
        self.choices = choices
        self.delegate = delegate
        super.init(frame: .zero)
        addVertically(views: choices.map { createChoice($0) })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createChoice(_ choice: String) -> UIView {
        let container = UIButton()
        let checkBox = createCheckBox(choice: choice)
        let label = UILabel.body(choice)
        updateCheckBox(checkBox, isSelected: false)
        
        container.addTapAnimations()
        container.addSubview(checkBox)
        container.addSubview(label)
        
        checkBox.snp.makeConstraints { make in
            make.height.lessThanOrEqualToSuperview()
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        label.snp.makeConstraints { make in
            make.height.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalTo(checkBox.snp.right).offset(10)
        }
        container.add(for: .touchUpInside) {
            self.tapped(checkbox: checkBox, for: choice)
        }
        return container
    }
    
    private func createCheckBox(choice: String) -> UIButton {
        let button = UIButton()
        button.addTapAnimations()
        button.layer.cornerRadius = 6
        button.add(for: .touchUpInside) {
            self.tapped(checkbox: button, for: choice)
        }
        button.setImage(UIImage(named: "check"), for: .selected)
        button.tintColor = .white
        return button
    }
    
    private func tapped(checkbox: UIButton, for choice: String) {
        let isSelected = !checkbox.isSelected
        updateCheckBox(checkbox, isSelected: isSelected)
        if isSelected {
            selectedChoices.append(choice)
        } else {
            selectedChoices.removeAll(where: { $0 == choice })
        }
        delegate?.didEditInput()
    }
    
    private func updateCheckBox(_ button: UIButton, isSelected: Bool) {
        button.isSelected = isSelected
        button.backgroundColor = isSelected ? .blue : .white
        button.layer.borderColor = isSelected ? nil : .stroke
        button.layer.borderWidth = isSelected ? 0 : 2
        delegate?.didEditInput()
    }
}
