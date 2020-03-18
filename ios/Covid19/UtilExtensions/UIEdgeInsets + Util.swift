//
//  UIEdgeInsets + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    static var safeArea: UIEdgeInsets? { UIApplication.shared.keyWindow?.safeAreaInsets }
    
    static var safeAreaTop: CGFloat { safeArea?.top ?? 0 }
    
    static var safeAreaBottom: CGFloat { safeArea?.bottom ?? 0 }

    static var safeMargins: UIEdgeInsets { UIEdgeInsets(top: safeAreaTop + 24, left: .margin, bottom: safeAreaBottom + 24, right: .margin) }
    
    static var horizontal: UIEdgeInsets { UIEdgeInsets(top: 0, left: .margin, bottom: 0, right: .margin) }
    
    static var margins: UIEdgeInsets { UIEdgeInsets(top: .margin, left: .margin, bottom: .margin, right: .margin) }
}

extension CGFloat {
    static var margin: CGFloat { 20 }
}
