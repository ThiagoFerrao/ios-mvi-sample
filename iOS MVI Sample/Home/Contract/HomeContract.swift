import Foundation
import RxSwift

protocol HomeFactoring: RxFactoring {
    associatedtype Parameter = Void
}

protocol HomeDataFetching {
    associatedtype Request = HomeDataRequest

    init(network: Network)
    func fetchAllCategories() -> Single<[HomeCategoryModel]>
    func fetchSearchedRestaurants(searchValue: String) -> Single<[HomeRestaurantModel]>
}
