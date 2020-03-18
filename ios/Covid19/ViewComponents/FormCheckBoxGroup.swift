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
        addVertically(views: choices.map { createChoice(text: $0) })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createChoice(text: String) -> UIView {
        let container = UIView()
        let checkBox = createCheckBox(choice: text)
        let label = UILabel.body(text)
        updateCheckBox(checkBox, isSelected: false)
        
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
        return container
    }
    
    private func createCheckBox(choice: String) -> UIButton {
        let button = UIButton()
        button.addTapAnimations()
        button.layer.cornerRadius = 6
        button.add(for: .touchUpInside) {
            button.isSelected.toggle()
            if button.isSelected {
                self.selectedChoices.append(choice)
            } else {
                self.selectedChoices.removeAll(where: { $0 == choice })
            }
            self.updateCheckBox(button, isSelected: button.isSelected)
        }
        button.setImage(UIImage(named: "check"), for: .selected)
        button.tintColor = .white
        return button
    }
    
    private func updateCheckBox(_ button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? .blue : .white
        button.layer.borderColor = isSelected ? nil : .stroke
        button.layer.borderWidth = isSelected ? 0 : 2
        delegate?.didEditInput()
    }
}
