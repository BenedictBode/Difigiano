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
    
    var id: UUID
    var creator: Contributor
    var location: Location
    var imageURL: URL? = URL(string: "https://hws.dev/paul.jpg")
    var descrition: String? = "my best post so far"
    
}


