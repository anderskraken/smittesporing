//
//  Date + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 21/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

extension Date {

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    func addingDays(_ count: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: count, to: self)
    }
}
