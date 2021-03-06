//
//  UILabel + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func title(_ text: String?) -> UILabel {
        return UILabel(text)
            .withFont(UIFont.medium(size: 28), maxSize: 32)
            .colored(.textBlack)
    }

    static func title2(_ text: String?) -> UILabel {
        return UILabel(text)
            .withFont(UIFont.medium(size: 23))
            .colored(.textBlack)
    }

    static func title3(_ text: String?) -> UILabel {
        return UILabel(text)
            .withFont(UIFont.medium(size: 16))
            .colored(.textBlack)
    }

    static func body(_ text: String?) -> UILabel {
        return UILabel(text)
            .withFont(UIFont.medium(size: 18))
            .colored(.textBlack)
            .aligned(.center)
            .lineCount(0)
    }

    static func bodySmall(_ text: String?) -> UILabel {
        return UILabel(text)
            .withFont(UIFont.medium(size: 14))
            .colored(.textBlack)
            .aligned(.center)
            .lineCount(0)
    }
    
    static func tag(_ text: String?) -> UILabel {
        let label = UILabel(text)
            .withFont(UIFont.semiBold(size: 14))
            .colored(.white)
            .aligned(.center)
            .lineCount(0)
        label.backgroundColor = .blue
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
            make.width.equalTo(label.intrinsicContentSize.width + 20).priority(.medium)
        }
        return label
    }

    convenience init(_ attributedText: NSAttributedString?) {
        self.init(frame: .zero)
        self.attributedText = attributedText
        numberOfLines = 0
    }

    convenience init(_ text: String?) {
        self.init(frame: .zero)
        self.text = text
        numberOfLines = 0
    }
    
    func lineCount(_ numberOfLines: Int) -> UILabel {
        self.numberOfLines = numberOfLines
        return self
    }

    func colored(_ color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    
    func aligned(_ alignment: NSTextAlignment) -> UILabel {
        self.textAlignment = alignment
        return self
    }

    func withFont(_ font: UIFont?, maxSize: CGFloat? = nil) -> UILabel {
        self.font = font
        return scaledFont(max: maxSize)
    }

    func scaledFont(max: CGFloat? = nil) -> UILabel {
        if let max = max {
            self.font = UIFontMetrics.default.scaledFont(for: self.font, maximumPointSize: max)
        } else {
            self.font = UIFontMetrics.default.scaledFont(for: self.font)
        }
        
        self.adjustsFontForContentSizeCategory = true
        return self
    }
}
