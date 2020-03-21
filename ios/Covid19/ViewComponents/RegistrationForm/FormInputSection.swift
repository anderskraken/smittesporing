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

    init(title: String, linkText: String, trailingText: String, linkPath: String, input: FormInput) {
        self.input = input
        super.init(frame: .zero)
        let titleView = getTitleView(title: title, linkText: linkText, trailingText: trailingText, linkPath: linkPath)
        addVertically(spacing: 10, views: titleView, input)
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
    
    private func getTitleView(title: String, linkText: String, trailingText: String, linkPath: String) -> UIView {
        let titleLabel = UILabel.title3(title)
        let trailingLabel = UILabel.title3(trailingText)
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: linkText, attributes: underlineAttribute)
        let linkLabel = UILabel.title3(title)
        linkLabel.attributedText = underlineAttributedString

        let link = UIButton()
        link.addTapAnimations()
        link.addFilling(linkLabel)
        if let url = URL(string: linkPath) {
            link.add(for: .touchUpInside) {
                if let window = UIApplication.shared.keyWindow {
                    if let root = window.rootViewController {
                        root.present(WebViewViewController(url: url), animated: true)
                    }
                }
            }
        }
        
        let container = UIView()
        container.addSubview(titleLabel)
        container.addSubview(link)
        container.addSubview(trailingLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        link.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
        }
        trailingLabel.snp.makeConstraints { make in
            make.left.equalTo(linkLabel.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        return container
    }
    
}
