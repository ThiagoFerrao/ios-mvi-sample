import Foundation
import Alamofire

enum HomeDataRequest: NetworkRequest {
    case allCategories
    case searchRestaurants(searchValue: String)

    var path: String {
        switch self {
        case .allCategories:
            return "categories"

        case .searchRestaurants:
            return "search"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .allCategories:
            return nil

        case let .searchRestaurants(searchValue):
            return [
                "q" : searchValue
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .allCategories, .searchRestaurants:
            return .get
        }
    }
}
