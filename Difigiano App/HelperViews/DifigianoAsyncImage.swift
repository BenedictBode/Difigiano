//
//  DifigianoAsyncImage.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 24.12.22.
//

import SwiftUI

struct DifigianoAsyncImage: View {
    
    var width: Double?
    var imageURL: URL
    
    var body: some View {
        AsyncImage(url: imageURL,
            content: { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .if(self.width != nil) { view in
                         view.frame(maxWidth: width!, maxHeight: width!)
                     }
                     .cornerRadius(6)
            },
            placeholder: {
                Image("Difigiano").resizable()
                 .aspectRatio(contentMode: .fit)
                 .cornerRadius(6)
                 .if(self.width != nil) { view in
                     view.frame(maxWidth: width!, maxHeight: width!)
                 }
            }
        )
    }
}
