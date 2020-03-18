//
//  UIColor + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var darkBlue:    UIColor { UIColor(red: 0.024, green: 0.106, blue: 0.227, alpha: 1) }
    static var blue:        UIColor { UIColor(red: 0.087, green: 0.364, blue: 0.775, alpha: 1) }
    static var darkGray:    UIColor { UIColor(red: 0.420, green: 0.467, blue: 0.529, alpha: 1) }
    static var gray:        UIColor { UIColor(red: 0.816, green: 0.847, blue: 0.886, alpha: 1) }
    static var lightGray:   UIColor { UIColor(red: 0.910, green: 0.937, blue: 0.976, alpha: 1) }
    
    static var green:       UIColor { UIColor(red: 0.000, green: 0.610, blue: 0.100, alpha: 1) }
    static var stroke:      UIColor { UIColor(red: 0.820, green: 0.850, blue: 0.890, alpha: 1) }
    static var textBlack:   UIColor { UIColor(red: 0.020, green: 0.110, blue: 0.230, alpha: 1) }
}

extension CGColor {
    
    static var stroke: CGColor { UIColor.stroke.cgColor }
    static var blue: CGColor { UIColor.blue.cgColor }
    static var textBlack: CGColor { UIColor.textBlack.cgColor }
}
