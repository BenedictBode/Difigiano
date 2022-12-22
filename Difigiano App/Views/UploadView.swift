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
                   
                    let croppedImage = UIImage.cropImageToSquare(image: image)!
                    let previewImage = UIImage.resizeImage(image: croppedImage, targetSize: CGSize(width: 100, height: 100))
                    let bigImage = UIImage.resizeImage(image: croppedImage, targetSize: CGSize(width: 800, height: 800))
                    
                    
                    let postId = UUID()
                    
                    DataStorage.persistToStorage(image: bigImage, path: "postImages/" + postId.uuidString) { imageURL in
                        
                        DataStorage.persistToStorage(image: previewImage, path: "postPreviewImages/" + postId.uuidString) { imagePreviewURL in
                            
                            let post = Post(id: postId,
                                            creatorId: Contributor(name: "Bene").id,
                                 location: location ?? Location(latitude: Double.random(in: 47...50), longitude: Double.random(in: 9...12)),
                                 imageURL: imageURL,
                                 previewImageURL: imagePreviewURL
                            )
                            
                            DataStorage.persistToStorage(post: post)
                        }
                    }
                } label: {
                    Text ("upload")
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

extension UIImage {
    static func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)

        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2

        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }

        return nil
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
