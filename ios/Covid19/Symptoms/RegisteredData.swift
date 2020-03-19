//
//  RegisteredData.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

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
    
    var personaliaDesc: String {
        "\(gender), \(age), \(inRiskGroup ? "" : "ikke ")i risikogruppe"
    }
    
    var suspicionDesc: String? {
        suspectsInfection ? "Mistenker smitte" : nil
    }
    
    var testedDesc: String {
        "Har \(testedPositive ? "" : "ikke ")tested positivt"
    }
    
    var provenInfectionDesc: String {
        "Har \(testedPositive ? "" : "ikke ")fått påvist smitte"
    }
    
    var contactDesc: String {
        "Har \(inContactWithInfectedPerson ? "" : "ikke ")vært i kontakt med person som har testet positivt for COVID-19"
    }

    var travelDesc: String {
        "Har \(beenOutsideNordic ? "" : "ikke ")vært utenfor Norden de siste 14 dagene"
    }
}
