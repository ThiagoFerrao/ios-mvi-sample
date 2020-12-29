import Foundation
import RxSwift

protocol HomeFactoring: RxFactoring where
    Parameter == Void { }

protocol HomeDataFetching {
    typealias Request = HomeDataRequest

    func fetchAllCategories() -> Single<[HomeCategoryModel]>
    func fetchAllRestaurants() -> Single<[HomeRestaurantModel]>
    func fetchSearchedRestaurants(searchValue: String) -> Single<[HomeRestaurantModel]>
}

protocol HomeCoordinating: RxCoordinating {
    func dismissScreen()
    func presentAlert<Response>(with viewModel: UIAlertController.ViewModel<Response>) -> Observable<Response>
}

typealias HomeDataUseCasing = RxUseCase<HomeDataUseCase.RequestType, HomeMutation>

protocol HomeInteracting: RxInteracting where
    Command == HomeCommand,
    Mutation == HomeMutation,
    State == HomeState { }

protocol HomePresenting: RxPresenting where
    State == HomeState,
    ViewModel == HomeViewModel { }
