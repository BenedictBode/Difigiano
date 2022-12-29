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
                            Group {
                                Text(String(user.points))
                                    .font(.system(size: 25))
                                    .bold()
                                Text("D")
                                    .font( .custom("UnifrakturMaguntia", size: 30))
                                    .foregroundColor(Color("difigianoGreen"))
                            }
                        }
                    }
                }
            }
            if model.currentUser?.isAdmin ?? false {
                Button() {
                    recalculatePoints()
                } label: {
                    Text("recalculate points")
                        .padding()
                }
            }
        }
    }
    
    func recalculatePoints() {
        for (i, user) in model.users.enumerated() {
            let userPoints = model.posts.filter({$0.creatorId == user.id}).map(\.points).reduce(0, +)
            if userPoints != user.points {
                var user = user
                user.points = userPoints
                model.users[i] = user
                DataStorage.persistToStorage(contributor: user)
            }
            
        }
    }
}
