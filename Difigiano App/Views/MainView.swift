//
//  MainView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI
import FirebaseAuth
import Tabify

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject
    private var model: Model
    
    var body: some View {
        
        if model.isSignedIn {
            NavigationView {
                Tabify(selectedItem: $model.tabSelection){
                    
                    FeedView()
                        .tabItem(for: TabifyItems.home)
                    
                    MapView()
                        .tabItem(for: TabifyItems.map)
                    
                    UploadView()
                        .tabItem(for: TabifyItems.camera)
                    
                    LeaderBoardView()
                        .tabItem(for: TabifyItems.leaderboard)
                    
                    UserProfileView()
                        .tabItem(for: TabifyItems.profile)
                    
                }
                .barStyle(style: CustomTabifyBarStyle(colorScheme: _colorScheme))
                .itemStyle(style: CustomTabifyItemStyle())
            }
            
        } else {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Model())
    }
}
