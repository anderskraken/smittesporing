//
//  UIViewController + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addTitle(_ title: String) {
        let titleView = UIView()
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(UIEdgeInsets.safeMargins)
            make.height.equalTo(40)
        }
        
        let title = UILabel.title(title)
        titleView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.top.greaterThanOrEqualToSuperview()
            make.right.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func addCenteredWithMargin(_ view: UIView) {
        self.view.addCenteredWithMargin(view)
    }
}
