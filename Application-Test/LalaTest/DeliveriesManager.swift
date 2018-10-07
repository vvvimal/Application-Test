import Foundation
import SwiftyJSON
import SwiftyUserDefaults

// Handle Delivery data fetching and caching
final class DeliveriesManager {
    enum FetchMode {
        case refresh
        case nextPage
    }
    
    private let pageSize = 20
    static let instance = DeliveriesManager()
    var data = [Delivery]()
    var hasNextPage = true
    var isFetching = false

    func fetch(_ mode: FetchMode, loadFromCacheWhenFailed: Bool = false) {
        if isFetching { return }
        isFetching = true
        
        NotificationCenter.default.post(name: .deliveriesStartRefresh, object: nil)
        let offset = mode == .refresh ? 0 : data.count
        
        LalaApi.instance.getDeliveries(offset: offset, limit: pageSize) { (result) in
            if let result = result {
                let newData: [Delivery] = JSON(result).lalaModelArray()
                
                switch mode {
                case .refresh:
                    self.data = newData
                    self.hasNextPage = true
                case .nextPage:
                    self.data.append(contentsOf: newData)
                    self.hasNextPage = newData.count >= self.pageSize
                }
                Defaults[.deliveries] = result // Cache the result
                NotificationCenter.default.post(name: .deliveriesDidUpdate, object: nil)
            } else {
                switch mode {
                case .refresh:
                    if loadFromCacheWhenFailed, let result = Defaults[.deliveries] {
                        self.data = JSON(result).lalaModelArray()
                    } else {
                        self.data.removeAll()
                    }
                case .nextPage:
                    // Do nothing
                    break
                }
                NotificationCenter.default.post(name: .deliveriesDidFailToRefresh, object: nil)
            }
            
            self.isFetching = false
        }
        
        if mode == .nextPage {
            LalaApi.instance.getDeliveries(offset: offset, limit: pageSize) { (_) in
                // do nothing
            }
        }
    }
}
