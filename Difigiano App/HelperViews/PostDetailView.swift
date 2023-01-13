//
//  PostDetailView.swift
//  Difigiano App
//
//  Created by Benedict Bode Privat on 22.12.22.
//

import SwiftUI
import MapKit

struct PostDetailView: View {
    
    @EnvironmentObject
    private var model: Model
    
    var post: Post
    
    @State var addressString: String?

    var body: some View {
        VStack(spacing: 10) {
            if let creator = model.users.first(where: {post.creatorId == $0.id}) {
                HStack {
                    NavigationLink(destination: ProfileView(user: creator))
                    {
                        HStack {
                            DifigianoAsyncImage(width: 50, imageURL: creator.imageURL)
                            Text(creator.name)
                                .multilineTextAlignment(.leading)
                        }
                    
                    }
                    Spacer()
                    Text(pointsToString())
                }
            }
            DifigianoAsyncImage(imageURL: post.imageURL)
                .onTapGesture(count: 2) {
                    model.likePressed(post: post)
                }
            HStack {
                Button() {
                    withAnimation() {
                        model.region = MKCoordinateRegion(center: post.location.cllocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                        model.tabSelection = .map
                    }
                } label: {
                    Image(systemName: "map")
                        .font(.system(size: 25))
                }
                LikeIndicator(post: post)
            }
            HStack {
                Text((addressString ?? "") + post.timestamp.formatted())
                    .font(.caption)
                Spacer()
            }
        }.onAppear() {
            loadAddressString()
        }
    }
    
    func pointsToString() -> String {
        var pointsString = ""
        for _ in 1...post.points {
            pointsString += "⭐️"
        }
        
        return pointsString
    }
    
    func loadAddressString() {
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: post.location.latitude, longitude:post.location.longitude)) { (placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            
            if let placemark =  placemarks?.first, let locality = placemark.locality{
                let addressString = locality + ", "
                self.addressString = addressString
            }
        }
    }
    
}
