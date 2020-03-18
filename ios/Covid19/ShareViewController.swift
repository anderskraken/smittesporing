//
//  ShareViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    let info = """
    Alle opplysninger blir lagret sikkert på din telefon.

    Det er først hvis du får COVID-19-smitte du kan sende inn dine data.
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel.title("Del data")
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(UIEdgeInsets.margins)
        }
        
        let label = UILabel(info)
            .aligned(.center)
            .withFont(UIFont.regular(size: 18))
            .colored(.textBlack)
            .lineCount(0)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.margins.equalTo(UIEdgeInsets.horizontal)
        }
    }
}
