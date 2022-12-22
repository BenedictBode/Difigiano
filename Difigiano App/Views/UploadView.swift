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
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                                .foregroundColor(Color(.label))
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 64)
                        .stroke(Color.black, lineWidth: 3)
                    )
                    
                }
                
                Button {
                    guard let image = image else {
                        return
                    }
                    let post = Post(creatorId: Contributor(name: "Bene").id, location: Location(latitude: 48.13, longitude: 11.58))
                    
                    DataStorage.persistToStorage(image: image, path: "postImages/" + post.id.uuidString)
                    DataStorage.persistToStorage(post: post)
                } label: {
                    Text ("upload")
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
