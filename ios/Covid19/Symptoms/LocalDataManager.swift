//
//  LocalDataManager.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 19/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import Foundation

class LocalDataManager {
    
    final let DATA_KEY = "LocalData"
    final let TRACKING_KEY = "LocalData"
    
    static let shared = LocalDataManager()

    private init() { }
    
    var data: RegisteredData? {
        set { saveLocal(data: newValue) }
        get { getLocalData() }
    }

    var trackingEnabled: Bool {
        set { saveLocal(trackingEnabled: newValue) }
        get { getTracking() }
    }

    func saveLocal(data: RegisteredData?) {
        let defaults = UserDefaults.standard
        if let encoded = data?.encode() {
            defaults.set(encoded, forKey: DATA_KEY)
        }
    }

    func getLocalData() -> RegisteredData? {
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: DATA_KEY) as? Data {
            return RegisteredData.decode(from: value)
        } else {
            return nil
        }
    }
    
    func saveLocal(trackingEnabled: Bool?) {
        let defaults = UserDefaults.standard
        defaults.set(trackingEnabled, forKey: TRACKING_KEY)
    }

    func getTracking() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: TRACKING_KEY)
    }
}

extension RegisteredData {
    
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
    
    static func decode(from jsonData: Data) -> RegisteredData? {
        let jsonDecoder = JSONDecoder()
        do {
            let decoded = try jsonDecoder.decode(RegisteredData.self, from: jsonData)
            return decoded
        }
        catch let error {
            print("Could not decode data: \(error.localizedDescription)")
            return nil
        }
    }
}
