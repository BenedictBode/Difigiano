//
//  Location.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import CoreLocation

struct Location: Codable {
    
    var latitude: Double
    var longitude: Double
    
    var cllocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func asDictonary() -> NSDictionary {
        [
            "latitude": longitude,
            "longitude": latitude
        ]
    }
    
    init(from dict: NSDictionary) throws {
        guard let latitudeValue = dict["latitude"] as? Double,
              let longitudeValue = dict["longitude"] as? Double else {
            throw ParsingError.invalidFormat
        }
        latitude = latitudeValue
        longitude = longitudeValue
    }
    
    init(latitude: Double, longitude: Double)  {
        self.latitude = latitude
        self.longitude = longitude
    }
}
