//
//  LoginView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import CryptoKit
import _AuthenticationServices_SwiftUI


struct LoginView: View {
    
 @State var currentNonce: String?

  var body: some View {
    VStack {
      // 2
      Image("uncle sam")
        .resizable()
        .aspectRatio(contentMode: .fit)
    
      // 3
      GoogleSignInButton()
        .padding()
        .frame(height: 50)
        .onTapGesture {
            Authentication.GoogleSignIn()
        }
        
        SignInWithAppleButton() { request in
            request.requestedScopes = [.fullName, .email]
            let nonce = randomNonceString()
            self.currentNonce = nonce
            request.nonce = sha256(nonce)
        } onCompletion: { result in
            if case .failure(let failure) = result {
                print(failure.localizedDescription)
            } else if case .success(let success) = result {
                if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                    guard let nonce = currentNonce else {
                        fatalError("login callback without login request")
                    }
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        print("unable to fetch identity token")
                        return
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("unable to serialise token String from data" + appleIDToken.debugDescription)
                        return
                    }
                    
                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                    Authentication.authenticateUser(for: credential, displayName: appleIDCredential.fullName?.givenName ?? "Harry Potter")
                }
            }
        }
        .frame(height: 40)
        .padding()
        
        Spacer()
        
        Text("von Bene Bode")
            .font(.caption)
    }
  }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
