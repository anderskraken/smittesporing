//
//  UIImageView + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func tinted(_ color: UIColor?) -> UIImageView {
        tintColor = color
        return self
    }
    
    func withContentMode(_ contentMode: ContentMode) -> UIImageView {
        self.contentMode = contentMode
        return self
    }

    func withSize(_ width: CGFloat, height: CGFloat) -> UIImageView {
        snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(width)
            make.height.equalTo(height)
        }
        return self
    }
}
