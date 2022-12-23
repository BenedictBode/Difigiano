//
//  uploadView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI

struct UploadView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var creationDate: Date?
    @State var location: Location?
    
    
    var body: some View {
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
                            Image(systemName: "photo")
                                .font(.system(size: 100))
                                .padding()
                                .foregroundColor(Color(.label))
                        }
                    }
                }
                Button {
                    guard let image = image else {
                        return
                    }
                   
                    let croppedImage = UIImage.cropImageToSquare(image: image)!
                    let previewImage = UIImage.resizeImage(image: croppedImage, targetSize: CGSize(width: 100, height: 100))
                    let bigImage = UIImage.resizeImage(image: croppedImage, targetSize: CGSize(width: 800, height: 800))
                    
                    
                    let postId = UUID()
                    
                    DataStorage.persistToStorage(image: bigImage, path: "postImages/" + postId.uuidString) { imageURL in
                        
                        DataStorage.persistToStorage(image: previewImage, path: "postPreviewImages/" + postId.uuidString) { imagePreviewURL in
                            
                            guard let currentUser = model.currentUser else {
                                print("no current user.")
                                return
                            }
                            
                            print("last location latitude" + String(model.locationManager.lastLocation?.latitude ?? -5))
                            
                            let post = Post(id: postId,
                                            creatorId: currentUser.id,
                                 location: model.locationManager.lastLocation ?? Location(latitude: Double.random(in: 47...50), longitude: Double.random(in: 9...12)),
                                 imageURL: imageURL,
                                 previewImageURL: imagePreviewURL
                            )
                            
                            DataStorage.persistToStorage(post: post)
                            
                            if var currentUser = model.currentUser {
                                currentUser.points += 1
                                DataStorage.persistToStorage(contributor: currentUser)
                            }
                            
                            self.image = nil
                        }
                    }
                } label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 40))
                        .padding()
                        .foregroundColor(Color(.label))
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image, creationDate: $creationDate, location: $location)
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            
    }
}

