import Foundation
import SwiftyJSON

// Location Data Model
struct Location: LalaModel {
    var lat: Double
    var lng: Double
    var address: String
    
    init?(json: JSON) {
        guard
            let lat = json["lat"].double,
            let lng = json["lng"].double,
            let address = json["address"].string
            else { return nil }
        self.lat = lat
        self.lng = lng
        self.address = address
    }
}
