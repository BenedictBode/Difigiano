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
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.1004, longitude: 11.5664), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        Map(coordinateRegion: $region,
            showsUserLocation: true,
            userTrackingMode: $tracking,
            annotationItems: model.posts) { post in
            MapAnnotation(coordinate: post.location.cllocation) {
                PostPreview(post: post, width: 45)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                self.detailPost = post
                            }
                    )
            }
        }
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.all)
        .overlay() {
            VStack() {
                HStack {
                    Text(String(model.posts.count))
                        .font( .custom("UnifrakturMaguntia", size: 40))
                    Text("D")
                        .font( .custom("UnifrakturMaguntia", size: 40))
                        .foregroundColor(Color("difigianoGreen"))
                }
                Spacer()
                if self.detailPost != nil {
                    PostDetailView(post: $detailPost).environmentObject(model)
                }
            }
        }
        .onAppear {
            if let lastLocation = self.model.locationManager.lastLocation {
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        }
    }
}

struct MapOverview_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Model())
    }
}
