import Alamofire

final class LalaApi {
    static let instance = LalaApi()
    private let url = Global.api.lalaUrl
    private let sessionManager: SessionManager = {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = Global.api.timeout
        return Alamofire.SessionManager(configuration: conf)
    }()
    
    //MARK: -  Get Delivery List
    func getDeliveries(offset: Int, limit: Int, completion: @escaping (Any?) -> Void) {
        let parameters = ["offset": offset, "limit": limit]
        
        let request = sessionManager.request(url + "/deliveries", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    completion(json)
                case .failure:
                    completion(nil)
                }
        }
        
        Global.log(request.request?.url?.absoluteString ?? "")
    }
}
