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
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.45), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    
    @State var lastLocation: Location?
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: model.posts) { post in
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
                        .font(.system(size: 40))
                        .bold()
                    Text("D")
                        .font( .custom("UnifrakturMaguntia", size: 40))
                        .foregroundColor(Color("difigianoGreen"))
                }
                Spacer()
                if self.detailPost != nil {
                    PostDetailView(post: $detailPost).environmentObject(model)
                }
                if let lastLocation = self.lastLocation {
                    HStack {
                        Spacer()
                        Button() {
                            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        } label: {
                            Image(systemName: "location.north.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
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
            if let lastLocation = self.model.locationManager.lastLocation {
                self.lastLocation = lastLocation
            } else {
                self.model.locationManager.requestLocation()
            }
        }
    }
}
