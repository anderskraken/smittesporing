//
//  UIStackView + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func setupVertical() {
        axis = .vertical
        spacing = 20
        alignment = .center
        distribution = .equalSpacing
    }
    
    func addVertically(views: UIView...) {
        setupVertical()
        for view in views {
            addArrangedSubview(view)
        }
    }
}
