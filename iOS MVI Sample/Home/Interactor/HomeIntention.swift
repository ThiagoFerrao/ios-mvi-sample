import Foundation

enum HomeCommand {
    case loadData
    case searchValue(String?)
}

enum HomeMutation {
    case startLoading
    case updateData([HomeRestaurantModel])
}

struct HomeState {
    var isLoading: Bool
    var searchTerm: String?
    var restaurantsData: [HomeRestaurantModel]
}

extension HomeState {
    static var initialState: HomeState {
        return .init(
            isLoading: true,
            searchTerm: nil,
            restaurantsData: []
        )
    }
}
