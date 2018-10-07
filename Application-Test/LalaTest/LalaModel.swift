import Foundation
import SwiftyJSON

// Provide common init method to convert json to data object or array base on generic type
// All data model should conform to this protocol
protocol LalaModel {
    init?(json: JSON)
}

extension JSON {
    // Convert JSON to any LalaModel array
    func lalaModelArray<T: LalaModel>() -> [T] {
        guard let array = array else { return [T]() }
        return array.compactMap {
            T(json: $0)
        }
    }
    
    // Convert JSON to any LalaModel
    func lalaModel<T: LalaModel>() -> T? {
        return T(json: self)
    }
}
