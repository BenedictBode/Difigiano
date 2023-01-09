//
//  MapAnnotation.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 22.12.22.
//

import SwiftUI

struct PostPreview: View {
    
    let post: Post
    let width: Double?
    
    @State var shouldHighlight = false
    
    var body: some View {
        Group {
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
}
