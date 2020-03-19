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
    var checkBoxes = [String: UIButton]()

    init(choices: [String], delegate: FormInputDelegate) {
        self.choices = choices
        self.delegate = delegate
        super.init(frame: .zero)
        choices.forEach { checkBoxes[$0] = createCheckBox(choice: $0) }
        addVertically(views: choices.map { createChoice($0) })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createChoice(_ choice: String) -> UIView {
        let container = UIButton()
        let label = UILabel.body(choice).aligned(.left)
        let checkBox = checkBoxes[choice]!
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
            make.right.lessThanOrEqualToSuperview()
        }
        container.add(for: .touchUpInside) {
            self.tapped(choice)
        }
        return container
    }
    
    private func createCheckBox(choice: String) -> UIButton {
        let button = UIButton()
        button.addTapAnimations()
        button.layer.cornerRadius = 6
        button.setImage(UIImage(named: "check"), for: .selected)
        button.tintColor = .white
        button.add(for: .touchUpInside) {
            self.tapped(choice)
        }
        return button
    }
    
    private func tapped(_ choice: String) {
        if let checkBox = checkBoxes[choice] {
            let isSelected = !checkBox.isSelected
            updateCheckBox(checkBox, isSelected: isSelected)
            if isSelected {
                selectedChoices.append(choice)
            } else {
                selectedChoices.removeAll(where: { $0 == choice })
            }
        }
        delegate?.didEditInput()
    }
    
    private func updateCheckBox(_ button: UIButton, isSelected: Bool) {
        button.isSelected = isSelected
        button.backgroundColor = isSelected ? .blue : .white
        button.layer.borderColor = isSelected ? nil : .stroke
        button.layer.borderWidth = isSelected ? 0 : 2
    }
    
    func setSelected(choices: [String]) {
        self.selectedChoices = choices.filter { self.choices.contains($0) }
        for choice in choices {
            if let checkbox = checkBoxes[choice] {
                updateCheckBox(checkbox, isSelected: true)
            }
        }
        delegate?.didEditInput()
    }
}
