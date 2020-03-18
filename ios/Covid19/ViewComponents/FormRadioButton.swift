//
//  FormRadioButton.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class FormRadioButton: UIView, FormInput {
    
    weak var delegate: FormInputDelegate?
    var value: Any? { selectedChoice }
    
    var stack = UIStackView()
    var choices: [String]
    var selectedChoice: String?
    
    init(choices: [String], delegate: FormInputDelegate) {
        self.choices = choices
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
        addChoices()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        layer.borderWidth = 2
        layer.borderColor = .stroke
        layer.cornerRadius = 6
        clipsToBounds = true
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        addFilling(stack)
        snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func addChoices() {
        for choice in choices {
            if choice != choices.first {
                stack.addArrangedSubview(createSeparator())
            }
            stack.addArrangedSubview(createChoiceButton(text: choice))
        }
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .stroke
        separator.snp.makeConstraints { make in
            make.width.equalTo(2)
        }
        return separator
    }

    private func createChoiceButton(text: String) -> UIButton {
        let button = UIButton()
        button.addFilling(UILabel.body(text))
        button.addTapAnimations()
        button.add(for: .touchUpInside) {
            self.selected(choice: text)
        }
        return button
    }
    
    private func selected(choice: String) {
        selectedChoice = choice
        updateViews()
        delegate?.didEditInput()
    }
    
    private func updateViews() {
        for button in stack.subviews.filter({ $0 is UIButton }) {
            let label = button.subviews.first as? UILabel
            let isSelected = label?.text == selectedChoice
            button.backgroundColor = isSelected ? .blue : .white
            label?.textColor = isSelected ? .white : .textBlack
        }
    }
}
