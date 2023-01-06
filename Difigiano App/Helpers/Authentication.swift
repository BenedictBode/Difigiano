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
    
    static func GoogleSignIn() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
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
                
                self.authenticateUser(for: credential)
            }
        } else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            // 5
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    return
                }
                
                guard let idToken = user.idToken else {
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
                
                self.authenticateUser(for: credential, imageURL: user.profile?.imageURL(withDimension: 200), displayName: user.profile?.name)
            }
        }
    }
    
    static func authenticateUser(for credential: AuthCredential, imageURL: URL? = nil, displayName: String? = nil) {

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
                if let displayname = displayName  {
                    let newContributor = Contributor(id: result.user.uid, points: 0, name: displayname, imageURL: imageURL ?? URL(filePath: "profile-avatar"), timestamp: Date())
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
