//
//  UIView + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIView {
    
    func addCenteredWithMargin(_ view: UIView) {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leftMargin.rightMargin.equalTo(UIEdgeInsets.horizontal)
        }
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
