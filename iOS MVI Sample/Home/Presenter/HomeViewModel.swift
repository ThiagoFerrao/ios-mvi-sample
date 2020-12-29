import Foundation

struct HomeViewModel {
    let isLoading: Bool
    let restaurants: [HomeRestaurantModel]
}

extension HomeViewModel {
    init(state: HomeState) {
        self.isLoading = state.isLoading
        self.restaurants = state.restaurantsData
    }
}
