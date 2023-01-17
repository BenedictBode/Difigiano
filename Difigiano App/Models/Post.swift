//
//  Post.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import CoreLocation
import SwiftUI

class Post: Identifiable, ObservableObject, Equatable {
    
    static let defaultImage = UIImage(named: "Difigiano")!
    var id: UUID = UUID()
    var creatorId: String
    var location: Location
    var dist: Int // distance to closest post at creation in meter
    var descrition: String?
    var imageURL: URL
    var previewImageURL: URL
    
    var timestamp: Date = Date()
    
    enum RewardClass {
        case toClose
        case ground
        case newRegion
        case newCity
    }
    
    var points: Int {
        switch rewardClass {
        case .toClose:
            return 0
        case .ground:
            return 1
        case .newRegion:
            return 3
        case .newCity:
            return 10
        }
    }
    
    var color: Color {
        Post.color(for: rewardClass)
    }
    
    var rewardClass: RewardClass {
        Post.calcRewardClass(dist: dist)
    }
    
    static func calcRewardClass(dist: Int) -> RewardClass {
        if dist < 15 {
            return .toClose
        } else if dist <= 1000 {
            return .ground
        } else if dist <= 50000 {
            return .newRegion
        } else {
            return .newCity
        }
    }
    
    static func color(for rewardClass: RewardClass) -> Color {
        switch rewardClass {
        case .toClose:
            return Color(.black)
        case .ground:
            return Color("postClassColor1")
        case .newRegion:
            return Color("postClassColor2")
        case .newCity:
            return Color("postClassColor3")
        }
    }
    
    func asDictonary() -> NSDictionary {
        [
            "id": id.uuidString,
            "creator-id": creatorId,
            "location": location.asDictonary(),
            "descrition": descrition ?? "",
            "timestamp": timestamp.timeIntervalSince1970,
            "previewImageURL": previewImageURL.absoluteString,
            "imageURL": imageURL.absoluteString,
            "dist": dist
        ]
    }
    
    init(from dict: NSDictionary) throws {
        guard let idStringValue = dict["id"] as? String,
              let idValue = UUID(uuidString: idStringValue),
                let creatorIdValue = dict["creator-id"] as? String,
                let locationDictValue = dict["location"] as? NSDictionary,
                let descritionValue = dict["descrition"] as? String,
                let timestampValue = dict["timestamp"] as? TimeInterval,
                let previewImageURLStringValue = dict["previewImageURL"] as? String,
                let imageURLStringValue = dict["imageURL"] as? String,
                let previewImageURLValue = URL(string: previewImageURLStringValue),
                let imageURLValue = URL(string: imageURLStringValue),
                let distValue = dict["dist"] as? Int
        else {
            throw ParsingError.invalidFormat
        }
         
        id = idValue
        creatorId = creatorIdValue
        location = try Location(from: locationDictValue)
        descrition = descritionValue
        timestamp = Date(timeIntervalSince1970: timestampValue)
        imageURL = imageURLValue
        previewImageURL = previewImageURLValue
        dist = distValue
    }
    
    init(id: UUID, creatorId: String, location: Location, imageURL: URL, previewImageURL: URL, dist: Int) {
        self.id = id
        self.creatorId = creatorId
        self.location = location
        self.imageURL = imageURL
        self.previewImageURL = previewImageURL
        self.dist = dist
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
}



