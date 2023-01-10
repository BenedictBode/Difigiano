import SwiftUI
import MapKit
import UIKit

struct MapViewUI: UIViewRepresentable {
    
    let posts: [Post]
    let mapView = MKMapView()
    
    let clusterManager = ClusterManager()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.setRegion(MKCoordinateRegion(center: posts.first!.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)), animated: true)
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator

        clusterManager.clusterPosition = .first
        for post in posts {
            let annotation = Annotation(coordinate: post.location.cllocation)
            annotation.title = post.previewImageURL.absoluteString
            annotation.subtitle = String(post.rewardClass.rawValue)
            clusterManager.add(annotation)
        }

        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init(clusterManager: clusterManager)
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        let clusterManager: ClusterManager
        
        init(clusterManager: ClusterManager) {
            self.clusterManager = clusterManager
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? ClusterAnnotation {
                return LocationDataMapClusterView(annotation: annotation, reuseIdentifier: "cluster")
                
            } else {
                return PostAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            }
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            clusterManager.reload(mapView: mapView) { finished in
                // handle completion
            }
        }
        
        
    }
    
}

final class PostAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        canShowCallout = false
        backgroundColor = .clear
        
        
        let annotationView = AnnotationView(imageURL: URL(string: ((annotation?.title as? String) ?? "")))
        addSubview(annotationView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class LocationDataMapClusterView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        backgroundColor = .clear
        
        guard let annotation = annotation as? ClusterAnnotation else {
            return
        }
        
        let presentedAnnotation = annotation.annotations.first
        let annotationView = AnnotationView(imageURL: URL(string: ((presentedAnnotation?.title as? String) ?? "")))
        addSubview(annotationView)
        
        let label = UILabel(frame: frame)
        label.frame = bounds
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = String(annotation.annotations.count)
        addSubview(label)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AnnotationView: UIImageView {
            
    init(imageURL: URL?) {
        super.init(image: UIImage(named:"Difigiano50x")!)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        if let imageURL = imageURL {
            loadImage(imageURL: imageURL)
        }
    }
    
    func loadImage(imageURL: URL) {
        DataStorage.loadImage(url: imageURL) { [weak self] image in
            guard let self = self else {
                return
            }
            self.image = image
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
