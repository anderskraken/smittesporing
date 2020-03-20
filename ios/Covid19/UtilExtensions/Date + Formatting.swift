//
//  Date + Formatting.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 19/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

extension Date {
    var prettyString: String {
        let cal = Calendar.current        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        formatter.dateFormat = "HH.mm"
        let time = formatter.string(from: self)

        if cal.isDateInToday(self) {
            return "i dag kl. \(time)"
        } else if cal.isDateInYesterday(self) {
            return "i går kl. \(time)"
        }
        
        formatter.dateFormat = "yyyy dd.MMM"
        let date = formatter.string(from: self)
        return "\(date) kl. \(time)"
    }
}
