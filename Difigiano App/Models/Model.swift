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
        subscribeToUsers()
    }
    
    @Published var currentUser: Contributor?
    
    @Published var posts: [Post] = []
        
    @Published var isSignedIn: Bool = Auth.auth().currentUser?.uid != nil
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.13, longitude: 11.58), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published var users: [Contributor] = []
    
    var uid: String?
    
    func subscribeToSignedIn() {
        Authentication.auth.addStateDidChangeListener() { auth, user in
            if let uid = Auth.auth().currentUser?.uid {
                self.isSignedIn = true
                self.uid = uid
            } else {
                self.isSignedIn = false
            }
        }
    }
    
    func subscribeToUsers() {
        DataStorage.database.reference(withPath: "users").observe(.value, with: { snapshot in
            guard let usersDict = snapshot.value as? NSDictionary else {
                return
            }
            var updatedUsers: [Contributor] = []
            for (_, postDictValue) in usersDict {
                if let userDict = postDictValue as? NSDictionary {
                    do {
                        try updatedUsers.append(Contributor(from: userDict))
                    } catch {
                        print("something wrong with a user")
                    }
                }
            }
            self.users = updatedUsers
            
            if let uid = self.uid, let currentUser = self.users.first(where: {$0.id == uid}) {
                self.currentUser = currentUser
            } else {
                print("could not find user in users??!")
            }
            
            print("updated users now " + String(self.users.count))
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func subscribeToPosts() {
        DataStorage.database.reference(withPath: "posts").observe(.value, with: { snapshot in
            guard let postsDict = snapshot.value as? NSDictionary else {
                return
            }
            var updatedPosts: [Post] = []
            for (_, postDictValue) in postsDict {
                if let postDict = postDictValue as? NSDictionary {
                    do {
                        try updatedPosts.append(Post(from: postDict))
                    } catch {
                        print("something wrong with a post")
                    }
                }
            }
            self.posts = updatedPosts
            print("updated posts now " + String(self.posts.count))
        }) { error in
            print(error.localizedDescription)
        }
    }
}
