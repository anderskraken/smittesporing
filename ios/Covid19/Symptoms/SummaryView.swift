//
//  SummaryView.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class SummaryView: UIView {
    
    let symptomsView = UIStackView()
    let data: FormData
    
    init(data: FormData) {
        self.data = data
        super.init(frame: .zero)
        setup(data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ data: FormData) {
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
    
    func createSection(title: String, infos: [NSAttributedString?]) -> UIView {
        let titleLabel = UILabel(title).withFont(UIFont.semiBold(size: 14)).colored(.blue)
        let labels = UIStackView(spacing: 2, verticalViews: infos.compactMap({ $0 }).map({
            UILabel($0).colored(.textBlack).lineCount(0)
        }))
        return UIStackView(spacing: 8, verticalViews: titleLabel, labels)
    }

    func createSymptomsSection(title: String, symptoms: [String]) -> UIView {
        let titleLabel = UILabel(title).withFont(UIFont.semiBold(size: 14)).colored(.blue)
        return UIStackView(spacing: 8, verticalViews: titleLabel, symptomsView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSymptoms()
    }
    
    private func layoutSymptoms() {
        symptomsView.removeAllSubviews()
        
        if data.symptoms.isEmpty {
            let emptyLabel = UILabel.body("Ingen").aligned(.left)
            symptomsView.addVertically(views: emptyLabel)
            return
        }
        
        let maxWidth = symptomsView.frame.width
        var rowWidth = CGFloat(0)
        var rows = [UIView()]
        for symptom in data.symptoms {
            let tag = UILabel.tag(symptom)
            let width = tag.intrinsicContentSize.width + 20 + 8
            if rowWidth + width < maxWidth {
                add(tag: tag, to: rows.last!)
                rowWidth += width
            } else {
                rows.append(UIView())
                add(tag: tag, to: rows.last!)
                rowWidth = tag.intrinsicContentSize.width
            }
        }
        symptomsView.addVertically(spacing: 8, views: rows)
    }
    
    private func add(tag: UILabel, to row: UIView) {
        let last = row.subviews.last
        row.addSubview(tag)
        tag.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.bottom.lessThanOrEqualToSuperview()
            make.width.lessThanOrEqualToSuperview()
            if let last = last {
                make.left.equalTo(last.snp.right).offset(8)
            } else {
                make.left.equalToSuperview()
            }
        }
    }
}

extension FormData {
    var personaliaDesc: NSAttributedString {
        stringWithItalic(firstPart: "• \(gender), \(age), ",
            italicPart: inRiskGroup ? "" : "ikke ",
            lastPart: "i risikogruppe")
    }
    
    var suspicionDesc: NSAttributedString? {
        suspectsInfection ? stringWithItalic(firstPart: "• Mistenker smitte", italicPart: "", lastPart: "") : nil
    }
    
    var testedDesc: NSAttributedString {
        stringWithItalic(firstPart: "• Har ",
                         italicPart: testedPositive ? "" : "ikke ",
                         lastPart: "tested positivt")
    }
    
    var provenInfectionDesc: NSAttributedString {
        stringWithItalic(firstPart: "• Har ",
                         italicPart: testedPositive ? "" : "ikke ",
                         lastPart: "fått påvist smitte")
    }
    
    var contactDesc: NSAttributedString {
        stringWithItalic(firstPart: "• Har ",
                         italicPart: inContactWithInfectedPerson ? "" : "ikke ",
                         lastPart: "vært i kontakt med person som har testet positivt for COVID-19")
    }
    
    var travelDesc: NSAttributedString {
        stringWithItalic(firstPart: "• Har ",
                         italicPart: beenOutsideNordic ? "" : "ikke ",
                         lastPart: "vært utenfor Norden de siste 14 dagene")
    }
    
    func stringWithItalic(firstPart: String, italicPart: String, lastPart: String) -> NSAttributedString {
        let italic = [NSAttributedString.Key.font : UIFont.italic(size: 18)!] as [NSAttributedString.Key : Any]
        let regular = [NSAttributedString.Key.font : UIFont.medium(size: 18)!] as [NSAttributedString.Key : Any]
        
        let italicText = NSMutableAttributedString(string:italicPart, attributes: italic)
        let endingText = NSMutableAttributedString(string:lastPart, attributes: regular)
        
        let result = NSMutableAttributedString(string:firstPart, attributes: regular)
        result.append(italicText)
        result.append(endingText)
        return result
    }
}
