//
//  profileView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject
    private var model: Model
    
    var body: some View {
        Button(action: {
            Authentication.signOut()
        }, label: {
            Text("sign out")
        })
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(Model())
    }
}
