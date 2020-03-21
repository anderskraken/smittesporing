//
//  LocalStorageManager.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 19/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import CoreLocation

class LocalStorageManager {
    
    static let FORM_DATA_KEY = "FormData"
    static let TRACKING_ENABLED_KEY = "TrackingEnabled"
    static let TRACKING_TIME_KEY = "TrackingTime"
    static let LOCATIONS_KEY = "Locations"

    private static var defaults = UserDefaults.standard
    
    private init() { }
        
    static var formData: FormData? {
        set { save(formData: newValue) }
        get { getFormData() }
    }

    static func save(formData: FormData?) {
        if let encoded = formData?.encode() {
            defaults.set(encoded, forKey: FORM_DATA_KEY)
        }
    }

    static func getFormData() -> FormData? {
        if let value = defaults.value(forKey: FORM_DATA_KEY) as? Data {
            return FormData.decode(from: value)
        } else {
            return nil
        }
    }
    
    static func save(trackingEnabled: Bool?, timeStamp: Date?) {
        defaults.set(trackingEnabled, forKey: TRACKING_ENABLED_KEY)
        if let time = timeStamp {
            defaults.set(time.timeIntervalSince1970, forKey: TRACKING_TIME_KEY)
        } else {
            defaults.removeObject(forKey: TRACKING_TIME_KEY)
        }
    }

    static func getTrackingEnabled() -> Bool {
        return defaults.bool(forKey: TRACKING_ENABLED_KEY)
    }

    static func getTrackingStartedTimeStamp() -> Date? {
        let trackingTimeStamp = defaults.double(forKey: TRACKING_TIME_KEY) as TimeInterval
        return trackingTimeStamp == 0 ? nil : Date(timeIntervalSince1970: trackingTimeStamp)
    }
    
    static func save(locations: [CLLocation]) {
        var allLocations = getLocations()
        
        //Avoid duplicating cached values. Might need more thorough filtering
        let newLocations = locations.filter {
            $0.timestamp != allLocations.last?.timestamp
        }
        
        allLocations.append(contentsOf: newLocations)
        defaults.setValue(allLocations.map({ $0.encode() }), forKey: LOCATIONS_KEY)
    }

    static func getLocations() -> [CLLocation] {
        return defaults.mutableArrayValue(forKey: LOCATIONS_KEY).compactMap {
            if let data = $0 as? Data {
                return CLLocation.decode(from: data)
            } else {
                return nil
            }
        }
    }
    
    static func deleteLocations() {
        defaults.removeObject(forKey: LOCATIONS_KEY)
    }
}

extension FormData {
    
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        }
        catch let error {
            print("Could not encode data: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func decode(from jsonData: Data) -> FormData? {
        do {
            let decoded = try JSONDecoder().decode(FormData.self, from: jsonData)
            return decoded
        }
        catch let error {
            print("Could not decode data: \(error.localizedDescription)")
            return nil
        }
    }
}
