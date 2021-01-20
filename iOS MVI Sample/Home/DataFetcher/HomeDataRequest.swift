import Foundation
import Alamofire

enum HomeDataRequest: NetworkRequest {
    case allCategories
    case searchRestaurants(searchValue: String?)

    var path: String {
        switch self {
        case .allCategories:
            return GenString.Home.Request.Path.categories

        case .searchRestaurants:
            return GenString.Home.Request.Path.search
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case let .searchRestaurants(.some(searchValue)):
            return [
                GenString.Home.Request.Parameter.search : searchValue
            ]

        case .allCategories, .searchRestaurants:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .allCategories, .searchRestaurants:
            return .get
        }
    }
}
