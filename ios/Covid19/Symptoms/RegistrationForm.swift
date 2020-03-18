//
//  RegistrationForm.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class RegistrationForm: UIView {
   
    var mainContent = UIScrollView()
    var bottomContent = UIView()
    var continueButton: MainButton!
    var firstPage = UIView()
    var secondPage = UIView()
    var thirdPage = UIView()
    
    init() {
        super.init(frame: .zero)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        addSubview(mainContent)
        mainContent.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }

        addSubview(bottomContent)
        bottomContent.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(mainContent.snp.bottom)
        }

        continueButton = MainButton(text: "Neste", type: .primary, action: {})
        bottomContent.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.margins)
        }
    }
}
