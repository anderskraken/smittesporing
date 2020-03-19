//
//  UIView + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIView {
    
    func addFilling(_ view: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(insets)
            if let stack = view as? UIStackView { //StackViews needs width/height
                if stack.axis == .horizontal {
                    make.height.equalToSuperview().inset(insets)
                } else {
                    make.width.equalToSuperview().inset(insets)
                }
            }
        }
    }

    func addCenteredWithMargin(_ view: UIView) {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.leftMargin.rightMargin.equalTo(UIEdgeInsets.horizontal)
        }
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

extension CALayer {
    func addShadow(height: CGFloat = 1, radius: CGFloat = 3, opacity: Float = 0.15) {
        shadowOffset = CGSize(width: 0, height: height)
        shadowRadius = radius
        shadowOpacity = opacity
        shadowColor = UIColor.black.cgColor
    }
}
