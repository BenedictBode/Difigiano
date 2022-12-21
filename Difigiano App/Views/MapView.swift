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
        Map(coordinateRegion: $model.region)
    }
}

struct MapOverview_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Model())
    }
}
