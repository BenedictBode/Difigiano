//
//  profileView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @State var detailPost: Post?
    @State var name = ""
    @State var newImage: UIImage?
    @State var shouldShowImagePicker = false
    
    var user: Contributor
    
    private let topInfoFontSize = CGFloat(22)
    private let threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            EditableLabel($name, isEditingAllowed: hasEditingRights()) {
                if name.count < 1 {
                    name = user.name
                } else {
                    name = String(name.prefix(18))
                    var user = user
                    user.name = name
                    DataStorage.persistToStorage(contributor: user)
                }
            }
            .font(.largeTitle)
            .padding()
            
            DifigianoAsyncImage(width: 150, imageURL: user.imageURL)
                .clipShape(Circle())
                .onTapGesture(count: 2) {
                    shouldShowImagePicker = hasEditingRights()
                }
            HStack {
                VStack {
                    Text("⭐️")
                        .font( .system(size: topInfoFontSize))
                        .padding(2)
                    Text(String(user.points))
                        .font( .system(size: topInfoFontSize))
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("🧤")
                        .font( .system(size: topInfoFontSize))
                        .padding(2)
                    Text(String(user.posts.count))
                        .font( .system(size: topInfoFontSize))
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("❤️")
                        .font( .system(size: topInfoFontSize))
                        .padding(2)
                    Text(String(user.calculateLikes(likes: model.likes)))
                        .font( .system(size: topInfoFontSize))
                }
                .frame(maxWidth: .infinity)
            }.padding()
            
            ScrollView {
                LazyVGrid(columns: threeColumnGrid) {
                    ForEach(model.posts.filter({$0.creatorId == user.id})) {post in
                        DifigianoAsyncImage(imageURL: post.previewImageURL)
                            .onTapGesture {
                                self.detailPost = post
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
        .overlay() {
            if self.detailPost != nil {
                PostDetailView(post: $detailPost,
                               showsDeleteButton: self.hasEditingRights(),
                               showsCreator: false)
                .environmentObject(model)
            }
        }
        .onAppear() {
            name = user.name
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: {replaceProfileImage()}) {
            ImagePicker(image: $newImage, sourceType: .photoLibrary)
        }
    }
    
    func replaceProfileImage() {
        if let image = newImage {
            
            let croppedImage = UIImage.cropImageToSquare(image: image)!
            let croppedResizedImage = UIImage.resizeImage(image: croppedImage, targetSize: CGSize(width: 200, height: 200))
            
            DataStorage.persistToStorage(image: croppedResizedImage, path: "profileImages/" + user.id) { imageURL in
                var user = user
                user.imageURL = imageURL
                DataStorage.persistToStorage(contributor: user)
            }
        }
    }
    
    func hasEditingRights() -> Bool {
        user == model.currentUser || (model.currentUser?.isAdmin ?? false)
    }
}
