//
//  MainView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI
import FirebaseAuth
struct MainView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @State private var tabSelection = 1
    
    var body: some View {
        
        if model.isSignedIn {
            NavigationView {
                TabView(selection: $tabSelection){
                    
                    MapView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "map.fill")
                            }
                        }
                        .toolbarColorScheme(.light, for: .tabBar)
                        .tag(1)
                    
                    FeedView(tabSelection: $tabSelection)
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "scroll")
                            }
                        }
                        .tag(0)
                    
                    UploadView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "camera.fill")
                            }
                        }
                        .tag(2)
                    
                    LeaderBoardView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "crown.fill")
                            }
                        }
                        .tag(3)
                    
                    UserProfileView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "person.fill")
                            }
                        }
                        .tag(4)
                }
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
