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
}
