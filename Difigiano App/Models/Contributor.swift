//
//  User.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import SwiftUI

struct Contributor: Hashable, Identifiable, Equatable {
    
    var id: String
    var points: Int = Int.random(in: 0...100)
    var name: String
    var isAdmin: Bool = false
    var imageURL: URL = URL(string: "https://hws.dev/paul.jpg")!
    var timestamp: Date
    var posts: [Post] = []
    
    func calculateLikes(likes: [String:[String]]) -> Int {
        posts.compactMap {likes[$0.id.uuidString]?.count}.reduce(0, +)
    }
    
    static func compByPoints(user1: Contributor, user2: Contributor) -> Bool {
        user1.points > user2.points
    }
    
    func asDictonary() -> NSDictionary {
        [
            "id": id,
            "points": points,
            "name": name,
            "isAdmin": isAdmin,
            "imageURL": imageURL.absoluteString,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
    
    init(from dict: NSDictionary) throws {
        guard let idValue = dict["id"] as? String,
              let pointsValue = dict["points"] as? Int,
              let nameValue = dict["name"] as? String,
              let isAdminValue = dict["isAdmin"] as? Bool,
              let imageURLStringValue = dict["imageURL"] as? String,
              let imageURLValue = URL(string: imageURLStringValue),
              let timeintervalSince1970Value = dict["timestamp"] as? Double
        else {
            throw ParsingError.invalidFormat
        }
        
        id = idValue
        name = nameValue
        points = pointsValue
        isAdmin = isAdminValue
        imageURL = imageURLValue
        timestamp = Date(timeIntervalSince1970: timeintervalSince1970Value)
    }
    
    init(id: String, points: Int, name: String, imageURL: URL, timestamp: Date) {
        self.id = id
        self.points = points
        self.name = name
        self.imageURL = imageURL
        self.timestamp = timestamp
    }
    
    static func == (lhs: Contributor, rhs: Contributor) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
