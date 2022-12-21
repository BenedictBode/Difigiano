//
//  User.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    
    var id: UUID = UUID()
    var points: Int = Int.random(in: 0...100)
    var name: String
    var isAdmin: Bool = false
    var imageName: String = "default-profile-pic"
    var posts: [Post] = []
    
    var image: Image {
        Image(imageName)
    }
    
    static func compByPoints(user1: User, user2: User) -> Bool {
        user1.points > user2.points
    }
}
