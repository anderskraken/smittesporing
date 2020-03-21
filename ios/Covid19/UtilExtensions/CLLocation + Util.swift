//
//  CLLocation + Util.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 21/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import CoreLocation
import MapKit

extension CLLocation {
    func getAddress(onComplete: @escaping (String?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
            if let error = error {
                print("reverse geodcode fail: \(error.localizedDescription)")
            }
            
            if let pm = placemarks?.first {
                let address = [pm.thoroughfare, pm.subThoroughfare, pm.subLocality, pm.postalCode, pm.locality]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                onComplete(address)
            } else {
                onComplete(nil)
            }
        }
    }
}

extension CLLocation: Encodable {
    
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        }
        catch let error {
            print("Could not encode data: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func decode(from jsonData: Data) -> CLLocation? {
        do {
            let decoded = try JSONDecoder().decode(LocationWrapper.self, from: jsonData)
            return decoded.location
        }
        catch let error {
            print("Could not decode data: \(error.localizedDescription)")
            return nil
        }
    }

    public enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case horizontalAccuracy
        case verticalAccuracy
        case speed
        case course
        case timestamp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(speed, forKey: .speed)
        try container.encode(course, forKey: .course)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

public struct LocationWrapper: Decodable {
    var location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CLLocation.CodingKeys.self)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let altitude = try container.decode(CLLocationDistance.self, forKey: .altitude)
        let horizontalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .horizontalAccuracy)
        let verticalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .verticalAccuracy)
        let speed = try container.decode(CLLocationSpeed.self, forKey: .speed)
        let course = try container.decode(CLLocationDirection.self, forKey: .course)
        let timestamp = try container.decode(Date.self, forKey: .timestamp)
        
        let location = CLLocation(coordinate: CLLocationCoordinate2DMake(latitude, longitude), altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, speed: speed, timestamp: timestamp)
        
        self.init(location: location)
    }
}
