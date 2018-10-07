import Foundation
import SwiftyUserDefaults

struct Global {
    //MARK: - API Constants
    struct api {
        static let timeout: TimeInterval = 8.0
        static let lalaUrl = "https://mock-api-mobile.dev.lalamove.com"
        static let googleMapsApiKey = "AIzaSyAuKhE8Fnwm5LqIthSE0H06atUNPrEt4GU"
    }
    
    //MARK: -  Show Log only when DEBUG
    static func log(_ object: Any) {
        #if DEBUG
            debugPrint(object)
        #endif
    }
    
    static func crash() {
        fatalError()
    }
}

//MARK: - UserDefaults Key
extension DefaultsKeys {
    static let deliveries = DefaultsKey<Any?>("lalatest.userdefaults.deliveries")
}

//MARK: - Theme Colors
extension UIColor {
    @nonobjc static let lalaOrange = UIColor(red: 239/255, green: 102/255, blue: 47/255, alpha: 1) // Sharper
    @nonobjc static let lalaDarkOrange = UIColor(red: 215/255, green: 68/255, blue: 24/255, alpha: 1)
    @nonobjc static let lalaGreen = UIColor(red: 124/255, green: 179/255, blue: 66/255, alpha: 1)
    @nonobjc static let lalaText = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
}

//MARK: -  Notification Name
extension Notification.Name {
    static let deliveriesStartRefresh = Notification.Name("lalatest.notification.deliveriesStartRefresh")
    static let deliveriesDidUpdate = Notification.Name("lalatest.notification.deliveriesDidUpdate")
    static let deliveriesDidFailToRefresh = Notification.Name("lalatest.notification.deliveriesDidFailToRefresh")
}
