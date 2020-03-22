//
//  RegisteredData.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

struct FormData: Codable {
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
    
    var contaminationRisk: Bool {
        symptoms.count > 3 //Not official criteria
    }
}
