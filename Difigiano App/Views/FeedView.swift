//
//  FeedView.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 11.01.23.
//

import SwiftUI

struct FeedView: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        ScrollView {
            LazyVStack (spacing: 10) {
                ForEach(model.posts.sorted(by: { $0.timestamp > $1.timestamp })) { post in
                    VStack {
                        PostDetailView(post: post)
                    }
                    .padding()
                }
            }
        }
    }
}
