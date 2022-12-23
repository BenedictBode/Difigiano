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
    
    @State var detailPost: Post?
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        Map(coordinateRegion: $region,annotationItems: model.posts) { post in
            MapAnnotation(coordinate: post.location.cllocation) {
                DifigianoMapAnnotation(post: post)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            print("tapped on Map Annotation")
                            detailPost = post
                        }
                )
            }
        }
            .statusBar(hidden: true)
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*1.1, alignment: .center)
            .overlay() {
                if let detailPost = self.detailPost {
                    PostDetailView(post: detailPost)
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    print("tapped on Map")
                                    self.detailPost = nil
                                }
                        )
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
