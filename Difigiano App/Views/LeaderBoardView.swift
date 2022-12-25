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
                .font( .custom("UnifrakturMaguntia", size: 30))
            
            
            List {
                ForEach(model.users.sorted(by: Contributor.compByPoints)) { user in
                    HStack {
                        DifigianoAsyncImage(width: 50, imageURL: user.imageURL)
                        Text(user.name)
                            .font( .custom("UnifrakturMaguntia", size: 30))
                        Spacer()
                        Text(String(user.points))
                            .font( .custom("UnifrakturMaguntia", size: 30))
                        Text("P")
                            .font( .custom("UnifrakturMaguntia", size: 30))
                            .foregroundColor(Color("difigianoGreen"))
                    }
                }
            }
        }
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
            .environmentObject(Model())
    }
}
