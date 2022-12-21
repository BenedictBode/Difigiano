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
        List {
            ForEach(model.users.sorted(by: User.compByPoints)) { user in
                HStack {
                    
                    user.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .clipShape(Circle())
                    Text(user.name)
                        .font( .custom("UnifrakturMaguntia", size: 40))
                    Spacer()
                    Text(String(user.points))
                        .font( .custom("UnifrakturMaguntia", size: 40))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
            .environmentObject(Model())
    }
}
