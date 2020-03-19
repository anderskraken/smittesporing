//
//  InfoBadge.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class InfoBadge: UIStackView {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    init(text: String, image: UIImage?, imageTint: UIColor? = nil) {
        super.init(frame: .zero)
        
        imageView = UIImageView(image: image)
            .tinted(imageTint)
            .withContentMode(.scaleAspectFit)
            .withSize(56, height: 56)

        label = UILabel.body(text)
        
        addVertically(views: imageView, label)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String?) {
        label.text = text
    }
    
    func set(image: UIImage, tint: UIColor? = nil) {
        imageView.image = image
        imageView.tintColor = tint
    }

    func set(tint: UIColor?) {
        imageView.tintColor = tint
    }
}
