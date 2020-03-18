//
//  LocationTrackingViewController.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class LocationTrackingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let title = UILabel.title("Bevegelser")
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(UIEdgeInsets.margins)
        }
    }
}
