//
//  String + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 23/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

extension String {
    var capitalizedFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = capitalizedFirstLetter
    }
}
