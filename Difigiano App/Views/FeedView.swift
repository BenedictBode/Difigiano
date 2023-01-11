//
//  FeedView.swift
//  Difigiano
//
//  Created by Benedict Bode Privat on 11.01.23.
//

import SwiftUI
import MapKit

struct FeedView: View {
    
    @EnvironmentObject var model: Model
    @Binding var tabSelection: Int
    
    var body: some View {
        ScrollView {
            LazyVStack (spacing: 10) {
                ForEach(model.posts.sorted(by: { $0.timestamp > $1.timestamp })) { post in
                    VStack {
                        PostDetailView(post: post)
                        Button() {
                            withAnimation() {
                                model.region = MKCoordinateRegion(center: post.location.cllocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                                tabSelection = 1
                            }
                        } label: {
                            Image(systemName: "map")
                                .font(.system(size: 20))
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
