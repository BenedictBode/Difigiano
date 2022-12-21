//
//  MainView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject
    private var model: Model
    
    var body: some View {
        TabView{
            LeaderBoardView()
                .tabItem {
                    Label("leaderboard", image: "leaderboard")
                }
                .environmentObject(model)
            
            MapView()
                .tabItem {
                    Label("map", image: "pin")
                }
                .environmentObject(model)
            
            ProfileView()
                .tabItem {
                    Label("profile", image: "profile")
                }
                .environmentObject(model)
            
            ProfileView()
                .tabItem {
                    Label("shop", image: "bag")
                }
                .environmentObject(model)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Model())
    }
}
