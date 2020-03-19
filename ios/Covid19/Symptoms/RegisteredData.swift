//
//  RegisteredData.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

struct RegisteredData: Codable {
    let gender: String
    let age: Int
    let inRiskGroup: Bool
    let testedPositive: Bool
    let suspectsInfection: Bool
    let inContactWithInfectedPerson: Bool
    let infectedContactDate: String?
    let beenOutsideNordic: Bool
    let returnedHomeDate: String?
    let symptoms: [String]
    
    var personaliaDesc: NSAttributedString {
        stringWithItalic(firstPart: "• \(gender), \(age), ",
            italicPart: inRiskGroup ? "" : "ikke ",
            lastPart: "i risikogruppe")
    }
    
    var suspicionDesc: NSAttributedString? {
        suspectsInfection ? NSAttributedString(string: "• Mistenker smitte") : nil
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
        let regular = [NSAttributedString.Key.font : UIFont.regular(size: 18)!] as [NSAttributedString.Key : Any]
        
        let italicText = NSMutableAttributedString(string:italicPart, attributes: italic)
        let endingText = NSMutableAttributedString(string:lastPart, attributes: regular)
        
        let result = NSMutableAttributedString(string:firstPart, attributes: regular)
        result.append(italicText)
        result.append(endingText)
        return result
    }
}
