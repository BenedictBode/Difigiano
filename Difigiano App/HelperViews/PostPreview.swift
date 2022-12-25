//
//  MapAnnotation.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 22.12.22.
//

import SwiftUI

struct PostPreview: View {
    
    var post: Post
    var width: Double?
    
    var body: some View {
        if let width = width {
            DifigianoAsyncImage(width: width, imageURL: post.previewImageURL)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(post.color, lineWidth: 3)
                )
        } else {
            DifigianoAsyncImage(imageURL: post.previewImageURL)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(post.color, lineWidth: 3)
                )
        }
        
    }
}
