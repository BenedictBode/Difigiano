//
//  UserProfileView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 23.12.22.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject
    private var model: Model
    
    @AppStorage("firstUserProfileVisit") var firstUserProfileVisit = true
    
    var body: some View {
        VStack {
            if let currentUser = model.currentUser {
                ProfileView(user: currentUser)
            }
            Button("sign out") {
                Authentication.signOut()
            }
            .padding()
        }
        .alert("Info", isPresented: $firstUserProfileVisit) {
                    Button("OK", role: .cancel) {}
        } message: {
            Text("Zum Bearbeiten von deinem Namen oder Profilbild einfach doppelt drauf tippen.")
        }
    }
}
