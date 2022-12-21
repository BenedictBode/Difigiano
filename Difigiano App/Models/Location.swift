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
}
