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
    
    @Published var previewImages: [UIImage] = []
    
    @Published var isSignedIn: Bool = Auth.auth().currentUser?.uid != nil
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.13, longitude: 11.58), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published var users = [Contributor(name: "Amelie"), Contributor(name: "Amalie"), Contributor(name: "Fella"), Contributor(name: "Bene")]
    
    func getPreviewImages() {
        
    }
    
    func subscribeToSignedIn() {
        Authentication.auth.addStateDidChangeListener() { auth, user in
            self.isSignedIn = Auth.auth().currentUser?.uid != nil
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
