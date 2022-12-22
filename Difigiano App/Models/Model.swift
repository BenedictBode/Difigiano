//
//  MainModel.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import MapKit
import FirebaseAuth
import FirebaseStorage

class Model: ObservableObject {
    
    init () {
        subscribeToSignedIn()
        subscribeToPosts()
    }
    
    @Published var posts: [Post] = []
    
    @Published var isSignedIn: Bool = Auth.auth().currentUser?.uid != nil
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published var users = [Contributor(name: "Amelie"), Contributor(name: "Amalie"), Contributor(name: "Fella"), Contributor(name: "Bene")]
    
    func subscribeToSignedIn() {
        Authentication.auth.addStateDidChangeListener() { auth, user in
            self.isSignedIn = Auth.auth().currentUser?.uid != nil
        }
    }
    
    func subscribeToPosts() {
        DataStorage.ref.child("posts").observeSingleEvent(of: .value, with: { snapshot in
            guard let postsDict = snapshot.value as? NSDictionary else {
                return
            }
            var updatedPosts: [Post] = []
            for (_, postDict) in postsDict {
                if postDict is NSDictionary {
                    do {
                        try updatedPosts.append(Post(from: postsDict))
                    } catch {
                        print("something wrong with a post")
                    }
                }
            }
            self.posts = updatedPosts
        }) { error in
            print(error.localizedDescription)
        }
    }
}
