//
//  AuthenticationViewModel.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class Authentication {
    
    static let shared = Authentication()
    
    static let auth = Auth.auth()
    
    static func signIn() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                Authentication.authenticateUser(for: user, with: error)
            }
        } else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            // 5
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                
                
                self.authenticateUser(for: result?.user, with: error)
            }
        }
    }
    
    static func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let user = user else {
            return
        }
        
        guard let idToken = user.idToken else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
        
        // 3
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            print(result!.user.uid)
            
            
            guard let result = result, let additionalinfo = result.additionalUserInfo else {
                print("no result while trying to authenticate user")
                return
            }
            
            if additionalinfo.isNewUser {
                if let imageURL = user.profile?.imageURL(withDimension: 200),
                   let displayname = result.user.displayName  {
                    let newContributor = Contributor(id: result.user.uid, points: 0, name: displayname, imageURL: imageURL, timestamp: Date())
                    DataStorage.persistToStorage(contributor: newContributor)
                } else {
                    print("could not fetch some user inforamtion")
                }
            }
            
        }
        
    }
    
    static func signOut() {
        // 1
        GIDSignIn.sharedInstance.signOut()
        
        do {
            // 2
            try Auth.auth().signOut()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
