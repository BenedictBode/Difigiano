//
//  ContentView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI

struct LeaderBoardView: View {
    
    @EnvironmentObject
    private var model: Model
    
    var body: some View {
        VStack {
            Text(String(model.users.count) + "🥷")
                .font(.title)
            
            List {
                ForEach(model.users.sorted(by: Contributor.compByPoints)) { user in
                    NavigationLink(destination: ProfileView(user: user,
                                                            usersPosts: self.model.posts.filter({$0.creatorId == user.id})).environmentObject(model))
                    {
                        HStack {
                            DifigianoAsyncImage(width: 50, imageURL: user.imageURL)
                            Text(user.name)
                                .font(.headline)
                            Spacer()
                            Text(String(user.points))
                                .font(.title)
                            Text("P")
                                .font( .custom("UnifrakturMaguntia", size: 30))
                                .foregroundColor(Color("difigianoGreen"))
                        }
                    }
                }
            }
        }
    }
}
