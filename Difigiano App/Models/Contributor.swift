//
//  User.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import SwiftUI

struct Contributor: Codable, Identifiable {
    
    var id: UUID = UUID()
    var points: Int = Int.random(in: 0...100)
    var name: String
    var isAdmin: Bool = false
    var imageURL: URL? = URL(string: "https://hws.dev/paul.jpg")
    var posts: [Post] = []
    
    static func compByPoints(user1: Contributor, user2: Contributor) -> Bool {
        user1.points > user2.points
    }
}
