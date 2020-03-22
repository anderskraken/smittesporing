//
//  SharingManager.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 22/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import CoreLocation

class SharingManager {
    
    static func getShareData() -> EncodableData? {
        let locations = LocalStorageManager.getLocations().map({ $0.encodable })
        guard let form = LocalStorageManager.getFormData() else {
            return nil
        }
        return EncodableData(formData: form, movements: locations)
    }
    
    static func getDataBlob() -> String? {
        return getShareData()?.encode()
    }
}

struct EncodableData {
    let formData: FormData
    let movements: [EncodableLocation]
}

struct EncodableLocation: Codable {
    let timeStamp: String
    let latitude: Double
    let longitude: Double
}

extension EncodableData: Codable {
    
    func encode() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        catch let error {
            print("Could not encode data: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func decode(from jsonData: Data) -> EncodableData? {
        do {
            let decoded = try JSONDecoder().decode(EncodableData.self, from: jsonData)
            return decoded
        }
        catch let error {
            print("Could not decode data: \(error.localizedDescription)")
            return nil
        }
    }
}

extension CLLocation {
    var encodable: EncodableLocation {
        EncodableLocation(timeStamp: timestamp.dateTimeString,
                          latitude: coordinate.latitude,
                          longitude: coordinate.longitude)
    }
}
