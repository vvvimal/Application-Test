import Foundation
import SwiftyJSON

// Delivery Data Model
struct Delivery: LalaModel {
    var id: Int
    var desc: String
    var imageUrl: URL
    var location: Location
    
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let desc = json["description"].string,
            let imageUrl = json["imageUrl"].url,
            let location: Location = json["location"].lalaModel()
            else { return nil }
        self.id = id
        self.desc = desc
        self.imageUrl = imageUrl
        self.location = location
    }
}
