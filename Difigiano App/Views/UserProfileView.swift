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
    
    var body: some View {
        VStack {
            if let currentUser = model.currentUser {
                ProfileView(user: currentUser, usersPosts: self.model.posts.filter({$0.creatorId == currentUser.id}), hasEditingRights: true)
            }
            Button("sign out") {
                Authentication.signOut()
            }
            .padding()
        }
    }
}
