//
//  LoginView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn


struct LoginView: View {

  var body: some View {
    VStack {
      Spacer()

      // 2
      Image("Difigiano")
        .resizable()
        .aspectRatio(contentMode: .fit)

      Spacer()

      // 3
      GoogleSignInButton()
        .padding()
        .onTapGesture {
            Authentication.signIn()
        }
    }
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
