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
                annotation.title = post.id.uuidString
                annotation.subtitle = String(post.points)
                context.coordinator.clusterManager.add(annotation)
            }
            context.coordinator.posts = posts
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init(clusterManager: clusterManager, posts: [], selectedPost: $selectedPost, region: $region)
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
                if let post = postFor(annotation: annotation.annotations.sorted(by: {MapCoordinator.sortBySubtitle(left: $0, right: $1)}).first!) {
                    return PostAnnotationView(annotation: annotation, reuseIdentifier: "cluster", post: post, selectedPost: $selectedPost, region: $region, count: annotation.annotations.count, mapView: mapView)
                }
                return MKAnnotationView(annotation: annotation, reuseIdentifier: "error")
                
            } else {
                if let post = postFor(annotation: annotation) {
                    return PostAnnotationView(annotation: annotation, reuseIdentifier: "pin", post: post, selectedPost: $selectedPost, region: $region, mapView: mapView)
                }
                return MKAnnotationView(annotation: annotation, reuseIdentifier: "error")
            }
        }
        
        static func sortBySubtitle(left: MKAnnotation, right: MKAnnotation) -> Bool {
            Int((left.subtitle ?? "-1") ?? "-1") ?? -1 > Int((right.subtitle ?? "-1") ?? "-1") ?? -1
        }
        
        func postFor(annotation: MKAnnotation) -> Post? {
            posts.first(where: { $0.id.uuidString == annotation.title })
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            clusterManager.reload(mapView: mapView) { finished in
                // handle completion
            }
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        }
        
    }
    
}

final class PostAnnotationView: MKAnnotationView {
        
    var post: Post
    @Binding private var selectedPost: Post?
    @Binding var region: MKCoordinateRegion
    var mapView: MKMapView
        
    init(annotation: MKAnnotation?, reuseIdentifier: String?, post: Post, selectedPost: Binding<Post?>, region: Binding<MKCoordinateRegion>, count: Int? = nil, mapView: MKMapView) {
        
        self.post = post
        _selectedPost = selectedPost
        _region = region
        self.mapView = mapView
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        canShowCallout = false
        backgroundColor = .clear
        
        let annotationView = AnnotationView(imageURL: post.previewImageURL, borderColor: Post.color(for: post.rewardClass))
        annotationView.isUserInteractionEnabled = true
        addSubview(annotationView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        annotationView.addGestureRecognizer(tap)
        
        if let count = count {
            let label = UILabel(frame: frame)
            label.frame = bounds
            label.font = .systemFont(ofSize: 20)
            label.textColor = .white
            label.textAlignment = .center
            label.text = String(count)
            addSubview(label)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        region = MKCoordinateRegion(center: post.location.cllocation, span: mapView.region.span)
        selectedPost = post
    }
}

class AnnotationView: UIImageView {
            
    init(imageURL: URL?, borderColor: Color) {
        super.init(image: UIImage(named:"Difigiano50x")!)
        layer.borderColor = UIColor(borderColor).cgColor
        layer.borderWidth = 4
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
