//
//  ShareViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    let infoText = """
    Alle opplysninger blir lagret sikkert på din telefon.

    Det er først hvis du får COVID-19-smitte du kan sende inn dine data.
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTitle("Del data")
        
        let info = UILabel.body(infoText)
        addCenteredWithMargin(info)
    }
}
