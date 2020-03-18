//
//  UIFont + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIFont {
    static func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Barlow-Regular", size: size)
    }

    static func medium(size: CGFloat) -> UIFont? {
        return UIFont(name: "Barlow-Medium", size: size)
    }

    static func semiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Barlow-SemiBold", size: size)
    }

    static func italic(size: CGFloat) -> UIFont? {
        return UIFont(name: "Barlow-Italic", size: size)
    }
}



//MARK: This makes Barlow the default system font - Source: https://stackoverflow.com/a/40484460

struct AppFontName {
    static let regular = "Barlow-Regular"
    static let bold = "Barlow-Bold"
    static let italic = "Barlow-Italic"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    static var isOverrided: Bool = false

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }

    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontObliqueUsage":
            fontName = AppFontName.italic
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    class func overrideInitialize() {
        guard self == UIFont.self, !isOverrided else { return }

        // Avoid method swizzling run twice and revert to original initialize function
        isOverrided = true

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }

        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
