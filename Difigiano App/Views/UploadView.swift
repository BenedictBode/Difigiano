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
    
    @State var shouldShowImagePicker = true
    @State var image: UIImage?
    @State var userLocation: Location?
    @State var shortestDist: Int?
    
    var body: some View {
        VStack {
            if let userLocation = self.userLocation {
                NavigationView {
                    VStack{
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 400, height: 400)
                                        .cornerRadius(20)
                                } else {
                                    Image(systemName: "camera")
                                        .font(.system(size: 100))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                        }
                        if let shortestDist = shortestDist, let image = image {
                            if Post.calcRewardClass(dist: shortestDist) != .toClose {
                                Button {
                                    post(image: image, dist: shortestDist, location: userLocation)
                                } label: {
                                    Image(systemName: "paperplane")
                                        .font(.system(size: 40))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                                Text("distance to next ground: " + String(shortestDist) + "m")
                                    .padding()
                            } else {
                                Button() {
                                    model.locationManager.requestLocation()
                                } label: {
                                    Text("to close: " + String(shortestDist) + "m")
                                        .padding()
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image, sourceType: .camera)
                }
            } else {
                Text("currently no location available")
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
        
        DataStorage.persistToStorage(image: bigImage, path: "postImages/" + postId.uuidString) { imageURL in
            
            DataStorage.persistToStorage(image: previewImage, path: "postPreviewImages/" + postId.uuidString) { imagePreviewURL in
                
                let post = Post(id: postId,
                                creatorId: currentUser.id,
                                location: location,
                                imageURL: imageURL,
                                previewImageURL: imagePreviewURL,
                                dist: dist
                )
                
                DataStorage.persistToStorage(post: post)
                
                currentUser.points += post.points
                DataStorage.persistToStorage(contributor: currentUser)
                
                self.image = nil
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

