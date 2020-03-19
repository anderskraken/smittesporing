//
//  InfoCard.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 19/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class InfoCard: UIView {
    
    var imageView: UIImageView!
    var label: UILabel!
    var button: MainButton?
    
    init(text: String?, image: UIImage?, imageTint: UIColor? = nil, buttonText: String? = nil, action: @escaping () -> () = {}) {
        super.init(frame: .zero)
        setupCard()
        
        imageView = UIImageView(image: image)
            .tinted(imageTint)
            .withContentMode(.scaleAspectFit)
            .withSize(56, height: 56)

        label = UILabel.body(text).lineCount(0)
        
        button = MainButton(text: buttonText ?? "", type: .secondary, action: action)

        let views = [image == nil ? nil : imageView, text == nil ? nil : label, buttonText == nil ? nil : button].compactMap({ $0 })
        let stack = UIStackView(verticalViews: views)
        stack.distribution = .fill
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.top.greaterThanOrEqualToSuperview().inset(UIEdgeInsets.margins)
            make.right.bottom.lessThanOrEqualToSuperview().inset(UIEdgeInsets.margins)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCard() {
        backgroundColor = .white
        layer.cornerRadius = 14
        layer.addShadow()
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(160)
            make.height.equalTo(0).priority(.low)
        }
    }
}
