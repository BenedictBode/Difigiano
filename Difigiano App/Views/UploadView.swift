//
//  uploadView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI
import CoreLocation

struct UploadView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var userLocation: Location?
    @State var shortestDist: Int?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NavigationLink(destination: PostInfoView())
                {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .padding(20)
                }
            }
            if let userLocation = self.userLocation, let shortestDist = self.shortestDist {
                if Post.calcRewardClass(dist: shortestDist) != .toClose {
                    NavigationView {
                        VStack {
                            Button {
                                shouldShowImagePicker.toggle()
                            } label: {
                                
                                VStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 400, height: 400)
                                            .cornerRadius(6)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(Post.color(for: Post.calcRewardClass(dist: shortestDist)), lineWidth: 5)
                                            )
                                        
                                        Button {
                                            post(image: image, dist: shortestDist, location: userLocation)
                                        } label: {
                                            Image(systemName: "paperplane")
                                                .font(.system(size: 40))
                                                .padding()
                                        }
                                    } else {
                                        Image(systemName: "camera")
                                            .font(.system(size: 100))
                                            .padding()
                                    }
                                }
                            }
                            if shortestDist < 1000 {
                                Text("erster Ground im Umkreis von " + String(shortestDist) + "m")
                                    .padding()
                                    .foregroundColor(.black)
                            } else {
                                Text("erster Ground im Umkreis von " + String(shortestDist/1000) + "km")
                                    .padding()
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                        ImagePicker(image: $image, sourceType: .camera)
                    }
                } else {
                    Text("zu nah an nächstem Ground (" + String(shortestDist) + "m)")
                }
            } else {
                Text("Standort nicht verfügbar")
                ProgressView()
            }
            Button() {
                model.locationManager.requestLocation()
            } label: {
                Text("Standort neu laden")
                    .padding()
                    .foregroundColor(.accentColor)
            }
        }
        .onAppear() {
            if let userLocation = self.model.locationManager.lastLocation {
                self.userLocation = userLocation
                shortestDist = self.distanceToClosestPost(userLocation: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude), posts: model.posts)
            } else {
                self.model.locationManager.requestLocation()
            }
        }
        .onReceive(self.model.locationManager.$lastLocation) { userLocation in
            if let userLocation = userLocation {
                self.userLocation = userLocation
                shortestDist = self.distanceToClosestPost(userLocation: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude), posts: model.posts)
            }
        }
        .onReceive(self.model.$posts) { posts in
            if let userLocation = userLocation {
                shortestDist = self.distanceToClosestPost(userLocation: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude), posts: posts)
            }
        }
    }
    
    
    
    func post(image: UIImage, dist: Int, location: Location) {
        
        guard var currentUser = model.currentUser else {
            print("no current user.")
            return
        }
        
        let croppedImage = UIImage.cropImageToSquare(image: image)!
        let previewImage = UIImage.resizeImage(image: croppedImage, targetSize: CGSize(width: 100, height: 100))
        let bigImage = UIImage.resizeImage(image: croppedImage, targetSize: CGSize(width: 800, height: 800))
        
        let postId = UUID()
        
        self.image = nil
        var post = Post(id: postId,
                        creatorId: currentUser.id,
                        location: location,
                        imageURL: URL(filePath: "Difigiano"),
                        previewImageURL: URL(filePath: "Difigiano"),
                        dist: dist
        )
        self.model.posts.append(post)
        
        DataStorage.persistToStorage(image: bigImage, path: "postImages/" + postId.uuidString) { imageURL in
            
            post.imageURL = imageURL
            DataStorage.persistToStorage(image: previewImage, path: "postPreviewImages/" + postId.uuidString) { imagePreviewURL in
                
                post.previewImageURL = imagePreviewURL
                
                DataStorage.persistToStorage(post: post)
                
                currentUser.points += post.points
                DataStorage.persistToStorage(contributor: currentUser)
            }
        }
    }
    
    
    func distanceToClosestPost(userLocation: CLLocation, posts: [Post]) -> Int {
        return posts.map {
            Int(userLocation.distance(from: CLLocation(latitude: $0.location.latitude,
                                                       longitude: $0.location.longitude)))
        }.min() ?? Int.max
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
        
    }
}

