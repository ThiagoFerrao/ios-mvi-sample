import Foundation

enum HomeCommand {
    case loadData
    case dismissScreen
    case searchValue(String)
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
