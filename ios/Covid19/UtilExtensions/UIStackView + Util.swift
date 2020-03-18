//
//  UIStackView + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func setupVertical(spacing: CGFloat = 20) {
        self.spacing = spacing
        axis = .vertical
        alignment = .center
        distribution = .equalSpacing
    }
    
    func addVertically(spacing: CGFloat = 20, views: UIView?...) {
        addVertically(spacing: spacing, views: views.compactMap { $0 })
    }
    
    func addVertically(spacing: CGFloat = 20, views: [UIView]) {
        setupVertical(spacing: spacing)
        add(views: views)
    }
    
    func add(views: UIView...) {
        add(views: views)
    }
    
    func add(views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
            view.snp.makeConstraints { make in
                if axis == .vertical {
                    make.width.equalToSuperview()
                } else {
                    make.height.equalToSuperview()
                }
            }
        }
    }
}
