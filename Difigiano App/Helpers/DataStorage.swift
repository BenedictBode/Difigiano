//
//  ImageStorage.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import UIKit

class DataStorage {
    
    static let shared = DataStorage()
    static let storage = Storage.storage()
    static let ref = Database.database().reference()
    
        
    static func persistToStorage(image: UIImage, path: String) {
        
        let ref = storage.reference(withPath: path)
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    print("Failed to push image to Storage: \(err)")
                    return
                }
                
                ref.downloadURL { url, err in
                    if let err = err {
                        print("Failed to retrieve downloadURL: \(err)")
                        return
                    }
                    
                    print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                    print(url?.absoluteString ?? "url placeholder")
                }
            }
        }
    
    static func persistToStorage(post: Post) {
        ref.child("posts").child(post.id.uuidString).setValue(post.asDictonary())
    }
}

enum ParsingError: Error {
    case invalidFormat
}
