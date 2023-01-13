import SwiftUI
import MapKit
import UIKit

struct MapViewUI: UIViewRepresentable {
    
    var posts: [Post]
    @Binding var selectedPost: Post?
    @Binding var region: MKCoordinateRegion
    
    let mapView = MKMapView()
    let clusterManager = ClusterManager()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.setRegion(region, animated: true)
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        clusterManager.clusterPosition = .average
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        context.coordinator.clusterManager.reload(mapView: mapView)
        
        if posts != context.coordinator.posts {
            context.coordinator.clusterManager.removeAll()
            for post in posts {
                let annotation = Annotation(coordinate: post.location.cllocation)
                annotation.title = post.previewImageURL.absoluteString
                //annotation.subtitle = String(post.rewardClass.rawValue)
                context.coordinator.clusterManager.add(annotation)
            }
            context.coordinator.posts = posts
            
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init(clusterManager: clusterManager, posts: posts, selectedPost: $selectedPost, region: $region)
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        
        let clusterManager: ClusterManager
        var posts: [Post]
        @Binding private var selectedPost: Post?
        @Binding var region: MKCoordinateRegion
        
        init(clusterManager: ClusterManager, posts: [Post], selectedPost: Binding<Post?>, region: Binding<MKCoordinateRegion>) {
            self.clusterManager = clusterManager
            self.posts = posts
            _selectedPost = selectedPost
            _region = region
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
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if let title = annotation.title as? String {
                region = mapView.region
                selectedPost = posts.first(where: { $0.previewImageURL.absoluteString == title })
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
