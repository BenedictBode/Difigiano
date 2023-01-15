//
//  TabifyItems.swift
//  Difigiano
//
//  Created by Benedikt Geisberger on 12.01.23.
//

import Foundation
import Tabify

enum TabifyItems: Int, TabifyItem {
    case home = 0
    case map
    case camera
    case leaderboard
    case profile
    
    var icon: String {
        switch self {
            case .home: return "scroll.fill"
            case .map: return "map.fill"
            case .camera: return "camera.fill"
            case .leaderboard: return "crown.fill"
            case .profile: return "person.fill"
        }
    }
    
    var title: String {
        switch self {
            case .home: return "Feed"
            case .map: return "Map"
            case .camera: return "Create"
            case .leaderboard: return "Leaderboard"
            case .profile: return "Profile"
        }
    }
}
