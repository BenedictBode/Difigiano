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
    
    var body: some View {
        
        if model.isSignedIn {
            NavigationView {
                TabView{
                    MapView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "map.fill")
                            }
                        }
                        .environmentObject(model)
                        .toolbarColorScheme(.light, for: .tabBar)
                    
                    LeaderBoardView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "crown.fill")
                            }
                        }
                        .environmentObject(model)
                    
                    UploadView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "camera.fill")
                            }
                        }
                        .environmentObject(model)
                    
                    /*ShopView()
                     .tabItem {
                     Label {
                     } icon: {
                     Image(systemName: "bag.fill")
                     }
                     }
                     .environmentObject(model)*/
                    
                    UserProfileView()
                        .tabItem {
                            Label {
                            } icon: {
                                Image(systemName: "person.fill")
                            }
                        }
                        .environmentObject(model)
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
