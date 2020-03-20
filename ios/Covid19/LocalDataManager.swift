//
//  LocalDataManager.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 19/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

class LocalDataManager {
    
    final let FORM_DATA_KEY = "FormData"
    final let TRACKING_ENABLED_KEY = "TrackingEnabled"
    final let TRACKING_TIME_KEY = "TrackingTime"

    static let shared = LocalDataManager()

    private init() { }
    
    var formData: FormData? {
        set { saveLocal(formData: newValue) }
        get { getLocalFormData() }
    }

    func saveLocal(formData: FormData?) {
        let defaults = UserDefaults.standard
        if let encoded = formData?.encode() {
            defaults.set(encoded, forKey: FORM_DATA_KEY)
        }
    }

    func getLocalFormData() -> FormData? {
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: FORM_DATA_KEY) as? Data {
            return FormData.decode(from: value)
        } else {
            return nil
        }
    }
    
    func saveLocal(trackingEnabled: Bool?, time: Date?) {
        let defaults = UserDefaults.standard
        defaults.set(trackingEnabled, forKey: TRACKING_ENABLED_KEY)
        if let time = time {
            defaults.set(time.timeIntervalSince1970, forKey: TRACKING_TIME_KEY)
        } else {
            defaults.removeObject(forKey: TRACKING_TIME_KEY)
        }
    }

    func getTracking() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: TRACKING_ENABLED_KEY)
    }

    func getTrackingTime() -> Date? {
        let defaults = UserDefaults.standard
        let trackingTime = defaults.double(forKey: TRACKING_TIME_KEY) as TimeInterval
        return trackingTime == 0 ? nil : Date(timeIntervalSince1970: trackingTime)
    }
}

extension FormData {
    
    func encode() -> Data? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            return jsonData
        }
        catch let error {
            print("Could not encode data: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func decode(from jsonData: Data) -> FormData? {
        let jsonDecoder = JSONDecoder()
        do {
            let decoded = try jsonDecoder.decode(FormData.self, from: jsonData)
            return decoded
        }
        catch let error {
            print("Could not decode data: \(error.localizedDescription)")
            return nil
        }
    }
}
