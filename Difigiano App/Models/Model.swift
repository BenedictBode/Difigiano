//
//  MainModel.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 21.12.22.
//

import Foundation
import MapKit
import FirebaseAuth

class Model: ObservableObject {
    
    
    init () {
        Auth.auth().addStateDidChangeListener() { auth, user in
            self.isSignedIn = Auth.auth().currentUser?.uid != nil
        }
    }
    
    @Published var isSignedIn: Bool = Auth.auth().currentUser?.uid != nil
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published var users = [Contributor(name: "Amelie"), Contributor(name: "Amalie"), Contributor(name: "Fella"), Contributor(name: "Bene")]
}
