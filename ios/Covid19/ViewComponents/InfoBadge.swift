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

//MARK: Static badges

extension InfoBadge {
    
    static let locationDisabled = InfoBadge(text: "Sporing er ikke aktiv.",
                                            image: UIImage(named: "location"),
                                            imageTint: .stroke)
    
    static let noInfoRegistered = InfoBadge(text: "Du har ikke lagt inn noe informasjon.",
                                            image: UIImage(named: "person"),
                                            imageTint: .darkGray)

    static let symptomsWarning = InfoBadge(text: "Dine symptomer kan tyde på at du har Covid-19.",
                                            image: UIImage(named: "warning"))

    static let keepStayingSafe = InfoBadge(text: "Hold avstand fra andre for å unngå å bli smittet.",
                                            image: UIImage(named: "thumbsUp"),
                                            imageTint: .blue)

    static let quaranteenNoDate = InfoBadge(text: "Du må holde deg i hjemmekarantene frem til og med 14 dager etter at du var i utlandet eller i kontakt med noen med påvist COVID-19.",
                                            image: UIImage(named: "home"),
                                            imageTint: .blue)

    static let quaranteenContact = InfoBadge(text: "Du må holde deg i hjemmekarantene frem til og med 14 dager etter at du var i kontakt med noen med påvist COVID-19.",
                                            image: UIImage(named: "home"),
                                            imageTint: .blue)

    static let quaranteenTravel = InfoBadge(text: "Du må holde deg i hjemmekarantene frem til og med 14 dager etter at du var i utlandet.",
                                            image: UIImage(named: "home"),
                                            imageTint: .blue)

    static func quaranteen(date: Date) -> InfoBadge {
        return InfoBadge(text: "Du må holde deg i hjemmekarantene frem til og med \(date.shortDateString).",
                  image: UIImage(named: "home"),
                  imageTint: .blue)
    }
}
