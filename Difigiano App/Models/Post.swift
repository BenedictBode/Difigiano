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
    var creator: User
    var location: Location
    var imageName: String = "default-post"
    var descrition: String? = "my best post so far"
}


