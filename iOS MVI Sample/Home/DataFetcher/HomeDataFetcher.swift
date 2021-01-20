import Foundation
import RxSwift

final class HomeDataFetcher: HomeDataFetching {

    private let network: Networking

    init(network: Networking) {
        self.network = network
    }

    func fetchAllCategories() -> Single<[HomeCategoryModel]> {
        return network.request(with: Request.allCategories)
            .map { (response: HomeCategoriesModel) in response.categories }
    }

    func fetchAllRestaurants() -> Single<[HomeRestaurantModel]> {
        return network.request(with: Request.searchRestaurants(searchValue: nil))
            .map { (response: HomeRestaurantsModel) in response.restaurants }
    }

    func fetchSearchedRestaurants(searchValue: String?) -> Single<[HomeRestaurantModel]> {
        return network.request(with: Request.searchRestaurants(searchValue: searchValue))
            .map { (response: HomeRestaurantsModel) in response.restaurants }
    }
}
