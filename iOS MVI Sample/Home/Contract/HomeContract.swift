import Foundation
import RxSwift

protocol HomeDataFetching {
    typealias Request = HomeDataRequest

    func fetchAllCategories() -> Single<[HomeCategoryModel]>
    func fetchAllRestaurants() -> Single<[HomeRestaurantModel]>
    func fetchSearchedRestaurants(searchValue: String?) -> Single<[HomeRestaurantModel]>
}

protocol HomeCoordinating: RxCoordinating {
    func presentAlert(
        with viewModel: UIAlertController.ViewModel<HomeCoordinator.AlertReponse>
    ) -> Observable<HomeCoordinator.AlertReponse>
}

typealias HomeDataUseCasing = RxUseCase<HomeDataUseCase.RequestType, HomeMutation>

protocol HomeInteracting: RxInteracting where
    Command == HomeCommand,
    Mutation == HomeMutation,
    State == HomeState { }

protocol HomePresenting: RxPresenting where
    State == HomeState,
    ViewModel == HomeViewModel { }

protocol HomeFactoring: RxFactoring where
    Parameter == Void { }
