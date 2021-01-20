import Foundation

enum HomeCommand {
    case loadData
    case searchValue(String?)
}

enum HomeMutation: Equatable {
    case showLoading(Bool)
    case updateData([HomeRestaurantModel])
}

struct HomeState: Equatable {
    var isLoading: Bool
    var restaurantsData: [HomeRestaurantModel]?
}

extension HomeState {
    static var initialState: HomeState {
        return .init(isLoading: true, restaurantsData: nil)
    }
}
