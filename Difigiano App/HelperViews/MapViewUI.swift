/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import MapKit
import UIKit

struct MapViewUI: UIViewRepresentable {
    
    let location: Post
    let places: [Post]
    let mapViewType: MKMapType
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)), animated: true)
        mapView.mapType = mapViewType
        mapView.isRotateEnabled = false
        mapView.addAnnotations(places)
        mapView.delegate = context.coordinator
        
        mapView.register(PostAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(LocationDataMapClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)


        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.mapType = mapViewType
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init()
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            switch annotation {
            case let cluster as MKClusterAnnotation:
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: cluster)
                /*annotationView.markerTintColor = .clear
                annotationView.image = UIImage(named: "Difigiano")!
                for clusterAnnotation in cluster.memberAnnotations {
                    if let place = clusterAnnotation as? Place {
                        if place.sponsored {
                            cluster.title = place.name
                            break
                        }
                    }
                }
                annotationView.titleVisibility = .visible*/
                return annotationView
            case let placeAnnotation as Post:
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: placeAnnotation)
                return annotationView
            default:
                fatalError("why")
            }
            
            
        }
        
    }
    
}

final class PostAnnotationView: MKAnnotationView {

    override var annotation: MKAnnotation? {
        didSet {
            if let title = annotation?.title as? String,
                  let imageURL = URL(string: title) {
                view.load(url: imageURL)
                
            }
            clusteringIdentifier = 
        }
    }
    
    var view: UIImageView = UIImageView(image: UIImage(named: "Difigiano"))
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        displayPriority = .required
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        clusteringIdentifier = "cluster"

        canShowCallout = true
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        addSubview(view)

        view.frame = bounds
    }
}

final class LocationDataMapClusterView: MKAnnotationView {

    // MARK: Initialization
    private let countLabel = UILabel()
    var view = UIImageView(image:UIImage(named: "Difigiano"))

    override var annotation: MKAnnotation? {
        didSet {
             guard let annotation = annotation as? MKClusterAnnotation else {
                return
            }
            countLabel.text = annotation.memberAnnotations.count < 100 ? "\(annotation.memberAnnotations.count)" : "99+"
            let presentedAnnotation = annotation.memberAnnotations.max { lhs, rhs in
                guard let lhsSubtitle = lhs.subtitle as? String, let lhsInt = Int(lhsSubtitle),
                   let rhsSubtitle = rhs.subtitle as? String, let rhsInt = Int(rhsSubtitle) else {
                    return false
                }
                return lhsInt > rhsInt
            }
            if let title = presentedAnnotation?.title as? String,
                  let imageURL = URL(string: title) {
                view.load(url: imageURL)
            }
        }
    }
    
    

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        displayPriority = .required
        collisionMode = .circle
        clusteringIdentifier = "cluster"

        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)

       
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    private func setupUI() {
        backgroundColor = .clear
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        addSubview(view)
        
        countLabel.frame = bounds
        countLabel.font = .systemFont(ofSize: 20)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        
        addSubview(countLabel)
        view.frame = bounds
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
