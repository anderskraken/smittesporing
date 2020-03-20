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
        
        button = MainButton(text: buttonText ?? "", type: .primary, action: action)

        let views = [image == nil ? nil : imageView, text == nil ? nil : label, buttonText == nil ? nil : button].compactMap({ $0 })
        let stack = UIStackView(verticalViews: views)
        stack.distribution = .fill
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.top.greaterThanOrEqualToSuperview().inset(UIEdgeInsets.margins)
            make.right.bottom.lessThanOrEqualToSuperview().inset(UIEdgeInsets.margins)
            make.width.equalToSuperview().inset(UIEdgeInsets.horizontal)
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

//MARK: Static cards

extension InfoCard {
    static let trackingEnabledCard = InfoCard(text: "Smittesporing er aktivert. Takk for at du bidrar!",
                        image: UIImage(named: "tada"),
                        imageTint: .blue)
    
    static let stayHomeCard = InfoCard(text: "Det viktigste du kan gjøre er å holde avstand fra andre.",
                        image: UIImage(named: "hand"),
                        imageTint: .blue)

    static let notMovedCard = InfoCard(text: "Du har ikke beveget deg utenfor hjemmet ditt i dag!",
                        image: UIImage(named: "house"))

    static let riskDetectedCard = InfoCard(text: "Du har vært på et sted hvor mange har blitt smittet.",
                        image: UIImage(named: "warning"),
                        buttonText: "Mer informasjon")
}
