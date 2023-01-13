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
    static let database = Database.database()
    
    static func loadImage(url: URL, completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    static func persistToStorage(image: UIImage, path: String, completion: @escaping (URL) -> ()) {
        
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
                guard let url = url else {
                    return
                }
                completion(url)
            }
        }
    }
    
    
    static func persistToStorage(post: Post) {
        database.reference(withPath: "posts").child(post.id.uuidString).setValue(post.asDictonary())
    }
    
    static func persistToStorage(contributor: Contributor) {
        database.reference(withPath: "users").child(contributor.id).setValue(contributor.asDictonary())
    }
    
    static func deleteFromStorage(post: Post) {
        database.reference(withPath: "posts").child(post.id.uuidString).removeValue { error, _ in
            if let error = error {
                print(error)
            }
        }
        storage.reference(forURL: post.imageURL.absoluteString).delete { error in
            if let error = error {
                print(error)
            }
        }
        storage.reference(forURL: post.previewImageURL.absoluteString).delete { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    static func loadImageFromStorage (path: String, completion: @escaping (UIImage) -> ()) {
        storage.reference(withPath: path).getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let err = error {
                print(err)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    print("wrong data while tying to fetch image")
                }
            }
        }
    }
    
    //Maybe load all preview images at once to reduce amount of single requests to firebase
    /*static func loadImages(from path: String, completion: @escaping ([String: UIImage]) -> ()) {
        
        storage.reference(withPath: path).observe() { (data, error) in
            
        }
    }*/
}

enum ParsingError: Error {
    case invalidFormat
}
