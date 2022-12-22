//
//  MapAnnotation.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 22.12.22.
//

import SwiftUI

struct DifigianoMapAnnotation: View {
    
    var post: Post
    
    var body: some View {
        VStack {
            AsyncImage(
                url: post.previewImageURL,
                content: { image in
                    image
                        .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: 45, maxHeight: 45)
                         .clipShape(Circle())
                },
                placeholder: {
                    Image("Difigiano")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 45, maxHeight: 45)
                        .clipShape(Circle())
                }
            )
        }
    }
}
