//
//  Difigiano_AppApp.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI

@main
struct Difigiano_AppApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(Model())
        }
    }
}
