import Foundation
import Alamofire

enum HomeDataRequest: NetworkRequest {
    case allCategories
    case allRestaurants
    case searchRestaurants(searchValue: String)

    var path: String {
        switch self {
        case .allCategories:
            return GenString.Home.Request.Path.categories

        case .allRestaurants, .searchRestaurants:
            return GenString.Home.Request.Path.search
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .allCategories, .allRestaurants:
            return nil

        case let .searchRestaurants(searchValue):
            return [
                GenString.Home.Request.Parameter.search : searchValue
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .allCategories, .allRestaurants, .searchRestaurants:
            return .get
        }
    }
}
