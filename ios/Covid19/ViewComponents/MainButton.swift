//
//  MainButton.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class MainButton: UIButton {
    
    init(text: String, type: MainButtonType, action: @escaping () -> ()) {
        super.init(frame: .zero)
        add(for: .touchUpInside, action)
        addTapAnimations()
        set(type: type)
        
        titleLabel?.font = UIFont.semiBold(size: 18)
        setTitle(text, for: .normal)
        layer.cornerRadius = 6
        
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(type: MainButtonType) {
        setTitleColor(type.textColor, for: .normal)
        backgroundColor = type.backgroundColor
        layer.borderColor = type.borderColor
        layer.borderWidth = type.borderWidth
    }
}

enum MainButtonType {
    case primary
    case secondary
    case activated
    
    var textColor: UIColor { self == .secondary ? .blue : .white }
    
    var borderColor: CGColor? { self == .secondary ? UIColor.blue.cgColor : nil }
    
    var borderWidth: CGFloat { self == .secondary ? 2 : 0 }
    
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return .blue
        case .secondary:
            return .white
        case .activated:
            return .green
        }
    }
}
