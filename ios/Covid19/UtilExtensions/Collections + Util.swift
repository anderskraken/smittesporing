//
//  Collections + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

extension Array {
    func splitToGroups(of groupSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: Swift.max(groupSize, 1)).map {
            Array(self[$0 ..< Swift.min($0 + Swift.max(groupSize, 1), self.count)])
        }
    }
}
