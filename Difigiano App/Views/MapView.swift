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
    
    var body: some View {
        Map(coordinateRegion: $model.region,annotationItems: model.posts) { post in
            MapAnnotation(coordinate: post.location.cllocation) {
                DifigianoMapAnnotation(post: post)
            }
        }
            .statusBar(hidden: true)
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*1.1, alignment: .center)

    }
}

struct MapOverview_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Model())
    }
}
