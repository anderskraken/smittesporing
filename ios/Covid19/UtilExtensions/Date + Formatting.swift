//
//  Date + Formatting.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 19/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

extension Date {
    
    private static var localFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }
    
    private static var datePickerFormatter: DateFormatter {
        let formatter = Date.localFormatter
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var datePickerString: String {
        return Date.datePickerFormatter.string(from: self)
    }
    
    static func fromDatePicker(string: String) -> Date? {
        return datePickerFormatter.date(from: string)
    }

    var prettyString: String {
        let cal = Calendar.current
        let formatter = Date.localFormatter
        formatter.dateFormat = "HH.mm"
        let time = formatter.string(from: self)

        if cal.isDateInToday(self) {
            return "i dag kl. \(time)"
        } else if cal.isDateInYesterday(self) {
            return "i går kl. \(time)"
        }
        
        formatter.dateFormat = "dd.MMM"
        let date = formatter.string(from: self)
        return "\(date) kl. \(time)"
    }
    
    var dateTimeString: String {
        let formatter = Date.localFormatter
        formatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
        return formatter.string(from: self)
    }

    var shortDateString: String {
        let formatter = Date.localFormatter
        formatter.dateFormat = "dd. MMMM"
        return formatter.string(from: self)
    }
}
