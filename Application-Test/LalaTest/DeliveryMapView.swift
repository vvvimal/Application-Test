import UIKit
import GoogleMaps
import SwiftIcons

final class DeliveryMapView: GMSMapView {
    
    lazy private var origin: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 22.335289, longitude: 114.176007)
    lazy private var destination: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.delivery.location.lat, longitude: self.delivery.location.lng)
    
    //MARK: - Init with delivery object
    private var delivery: Delivery!
    convenience init(_ delivery: Delivery) {
        self.init()
        self.delivery = delivery
        self.setInitialCamera()
    }
    
    // Initiate camera at destination point
    private func setInitialCamera() {
        let position = CLLocationCoordinate2D(latitude: delivery.location.lat, longitude: delivery.location.lng)
        camera = GMSCameraPosition.camera(withTarget: position, zoom: 12)
        padding = UIEdgeInsets(top: 0, left: 0, bottom: 106, right: 0)
    }
    
    // MARK: - Update Map Contents
    
    // Show origin and destination markers
    func showMarkers() {
        let destinationImage = pinImage(withIcon: .ionicons(.iosFlag), color: .lalaGreen, scale: 0.6)
        let destinationMarker = GMSMarker(position: destination)
        destinationMarker.icon = destinationImage
        destinationMarker.title = "Destination"
        destinationMarker.appearAnimation = .pop
        destinationMarker.map = self
        
        destinationMarker.iconView?.accessibilityLabel = "DestinationMarker"
        destinationMarker.iconView?.accessibilityIdentifier = "DestinationMarker"
        destinationMarker.iconView?.isAccessibilityElement = true
        
        accessibilityLabel = "Map"
        accessibilityIdentifier = "Map"
    }
    
    // Animating camera to fit 2 markers
    func updateCamera() {
        animate(toLocation: destination)
        setMinZoom(16, maxZoom: 16)
    }
}

//MARK: - Make View Components
extension DeliveryMapView {
    fileprivate func pinImage(withIcon icon: FontType, color: UIColor, scale: CGFloat) -> UIImage {
        let size = CGFloat(70)
        let bgImage = UIImage(icon: .mapicons(.mapPin), size: CGSize(width: size, height: size), textColor: color)
        let iconImage = UIImage(icon: icon, size: CGSize(width: size*scale, height: size*scale), textColor: .white)
        
        UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
        bgImage.draw(in: CGRect(
            x: 0,
            y: 0,
            width: bgImage.size.width,
            height: bgImage.size.height
        ))
        iconImage.draw(in: CGRect(
            x: (bgImage.size.width - iconImage.size.width) * 0.5,
            y: (bgImage.size.height - iconImage.size.width) * 0.3,
            width: iconImage.size.width,
            height: iconImage.size.height
        ))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
