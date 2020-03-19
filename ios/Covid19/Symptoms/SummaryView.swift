//
//  SummaryView.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class SummaryView: UIView {
    
    init(data: RegisteredData) {
        super.init(frame: .zero)
        setup(data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ data: RegisteredData) {
        backgroundColor = .lightGray
        layer.cornerRadius = 6
        let stack = UIStackView()
        addFilling(stack, insets: .margins)
        stack.addVertically(
            spacing: 30,
            views: createSection(title: "Om deg", infos: [data.personaliaDesc, data.testedDesc, data.provenInfectionDesc]),
                    createSection(title: "Mulige smittekilder", infos: [data.suspicionDesc, data.contactDesc, data.travelDesc]),
                    createSymptomsSection(title: "Symptomer", symptoms: data.symptoms)
        )
    }
    
    func createSection(title: String, infos: [String?]) -> UIView {
        let sectionTitle = UILabel(title).withFont(UIFont.semiBold(size: 14)).colored(.blue)
        let infoString = infos.compactMap({ $0 }).map({ "• \($0)" }).joined(separator: "\n")
        let infolabel = UILabel(infoString).withFont(UIFont.regular(size: 18)).colored(.textBlack)
        let sectionView = UIStackView()
        sectionView.addVertically(spacing: 8, views: sectionTitle, infolabel)
        return sectionView
    }

    func createSymptomsSection(title: String, symptoms: [String]) -> UIView {
        var rows = symptoms.splitToGroups(of: 3).map { group in
            let tagStack = UIStackView()
            tagStack.axis = .horizontal
            tagStack.distribution = .equalSpacing
            tagStack.alignment = .leading
            tagStack.spacing = 8
            tagStack.add(views: group.map { UILabel.tag($0) })
            return tagStack
        } as [UIView]
        
        rows.insert(UILabel(title).withFont(UIFont.semiBold(size: 14)).colored(.blue), at: 0)
        
        let sectionView = UIStackView()
        sectionView.addVertically(spacing: 8, views: rows)
        return sectionView
    }
}
