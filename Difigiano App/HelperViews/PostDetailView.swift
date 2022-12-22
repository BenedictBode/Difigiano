//
//  PostDetailView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 22.12.22.
//

import SwiftUI

struct PostDetailView: View {
    
    var post: Post
    
    var body: some View {
        AsyncImage(
            url: post.imageURL,
            content: { image in
                image
                    .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(maxWidth: 200, maxHeight: 200)
                     .cornerRadius(10)
            },
            placeholder: {
                Image("Difigiano")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 200)
                    .cornerRadius(10)
            }
        )
    }
}
