//
//  MapOverview.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    
    @EnvironmentObject
    private var model: Model
    
    @State private var detailPost: Post?
    
    @State var tracking: MapUserTrackingMode = .follow
    
    @State var lastLocation: Location?
    
    var body: some View {
        /*Map(coordinateRegion: $model.region, annotationItems: model.posts) { post in
            MapAnnotation(coordinate: post.location.cllocation) {
                PostPreview(post: post, width: 45)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                self.detailPost = post
                            }
                    )
            }
        }*/
        MapViewUI(posts: model.posts, selectedPost: $detailPost, region: $model.region)
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.all)
        .overlay() {
            VStack() {
                Text(String(model.posts.count) + "🧤")
                    .font(.system(size: 40))
                    .bold()
                Spacer()
                if self.detailPost != nil {
                    PostDetailCard(post: $detailPost)
                } else if let lastLocation = self.lastLocation {
                    HStack {
                        Spacer()
                        Button() {
                            withAnimation(.easeInOut(duration: 1)) {
                                model.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            }
                        } label: {
                            Image(systemName: "location.north.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .padding(20)
                        }
                    }
                }
            }
        }
        .onChange(of: self.model.locationManager.lastLocation) { lastLocation in
            self.lastLocation = lastLocation
        }
        .onAppear {
            self.model.locationManager.requestLocation()
            if let lastLocation = self.model.locationManager.lastLocation {
                self.lastLocation = lastLocation
            }
        }
    }
}
