//
//  Post.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import CoreLocation
import SwiftUI

struct Post: Codable, Identifiable {
    
    var id: UUID = UUID()
    var creatorId: UUID
    var location: Location
    var imageURL: URL? {
        URL(string: "https://firebasestorage.googleapis.com/v0/b/difigiano-24e34.appspot.com/o/postImages%" + id.uuidString + "?alt=media&token=a6654dda-fcf7-451c-be6d-7dfee5c7c4ae")
    }
    var descrition: String? = "my best post so far"
    var timestamp: Date = Date()
    
    func asDictonary() -> NSDictionary {
        [
            "id": id.uuidString,
            "creator-id": creatorId.uuidString,
            "location": location.asDictonary(),
            "descrition": descrition ?? "",
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
    
    init(from dict: NSDictionary) throws {
        guard let idStringValue = dict["id"] as? String,
                let creatorIdStringValue = dict["creator-id"] as? String,
                let idValue = UUID(uuidString: idStringValue),
                let creatorIdValue = UUID(uuidString: creatorIdStringValue),
                let locationDictValue = dict["location"] as? NSDictionary,
                let descritionValue = dict["location"] as? String,
                let timestampValue = dict["timestamp"] as? TimeInterval else {
            throw ParsingError.invalidFormat
        }
         
        
        id = idValue
        creatorId = creatorIdValue
        location = try Location(from: locationDictValue)
        descrition = descritionValue
        timestamp = Date(timeIntervalSince1970: timestampValue)
    }
    
    init(creatorId: UUID, location: Location) {
        self.creatorId = creatorId
        self.location = location
    }
}


