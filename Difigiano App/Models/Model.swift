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

import Combine

class Model: ObservableObject {
    
    init () {
        subscribeToSignedIn()
        subscribeToPosts()
        subscribeToUsers()
        subscribeToLikes()
    }
    
    @Published var tabSelection: TabifyItems = .home
    
    @Published var currentUser: Contributor?
    
    @Published var posts: [Post] = []
        
    @Published var isSignedIn: Bool = Auth.auth().currentUser?.uid != nil
        
    @Published var users: [Contributor] = []
    
    @Published var likes: [String:[String]] = [:]
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.45), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
            
    var locationManager = LocationManager()
    var uid: String?
        
    func subscribeToSignedIn() {
        Authentication.auth.addStateDidChangeListener() { auth, user in
            if let uid = Auth.auth().currentUser?.uid {
                self.isSignedIn = true
                self.uid = uid
                self.updateCurrentUser()
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
            
            self.mapPostsToUsers()
            
            self.updateCurrentUser()
            }) { error in
            print(error.localizedDescription)
        }
    }
    
    func updateCurrentUser() {
        if let uid = self.uid, let currentUser = self.users.first(where: {$0.id == uid}) {
            self.currentUser = currentUser
        } else {
            self.currentUser = nil
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
                        let post = try Post(from: postDict)
                        updatedPosts.append(post)
                    } catch {
                        print("something wrong with a post")
                    }
                }
            }
            
            self.posts = updatedPosts
            
            self.mapPostsToUsers()
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func subscribeToLikes() {
        DataStorage.database.reference(withPath: "likes").observe(.value, with: { snapshot in
            guard let updatedLikedBy = snapshot.value as? Dictionary<String, [String]> else {
                return
            }
            self.likes = updatedLikedBy
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func mapPostsToUsers() {
        let postsByCreatorId = Dictionary(grouping: self.posts, by: \.creatorId)
        self.users = self.users.map { user in
            var user = user
            user.posts = postsByCreatorId[user.id] ?? []
            return user
        }
    }
    
    func likePressed(post: Post) {
        if let currentUser = currentUser, post.creatorId != currentUser.id {
            var likes = likes[post.id.uuidString] ?? []
            if likes.contains(where: { $0 == currentUser.id })
            {
                likes.removeAll { $0 == currentUser.id }
            } else {
                likes.append(currentUser.id)
            }
            DataStorage.database.reference(withPath: "likes").child(post.id.uuidString).setValue(likes)
        }
    }
    
    func delete(post: Post) {
        if var creator = users.first(where: {post.creatorId == $0.id}) {
            creator.points -= post.points
            DataStorage.persistToStorage(contributor: creator)
        }
        DataStorage.deleteFromStorage(post: post)
    }
}
