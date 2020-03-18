//
//  Configuration.swift
//  Covid19
//
//  Created by Per Thomas Haga on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

struct Secrets {
    static var appCenterSecret: String {
        return try! Configuration.value(for: "AppCenterSecret")
    }
}
