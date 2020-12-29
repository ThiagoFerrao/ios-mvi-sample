import Foundation
import RxSwift

final class HomeDataUseCase: HomeDataUseCasing {

    let dataFetcher: HomeDataFetching
    let coordinator: HomeCoordinating

    init(
        dataFetcher: HomeDataFetching,
        coordinator: HomeCoordinating
    ) {
        self.dataFetcher = dataFetcher
        self.coordinator = coordinator
    }

    override func execute(with parameter: RequestType) -> Observable<HomeMutation> {
        let dataResult: Single<[HomeRestaurantModel]>

        switch parameter {
        case .allRestaurants:
            dataResult = dataFetcher.fetchAllRestaurants()

        case let .searchedRestaurants(searchValue):
            dataResult = dataFetcher.fetchSearchedRestaurants(searchValue: searchValue)
        }

        return dataResult.asObservable()
            .map { .updateData($0) }
            .retryWhen { errorObservable in
                return errorObservable.flatMap { error -> Observable<Void> in
                    let requestError = RequestError(statusCode: error.asAFError?.responseCode)
                    return self.coordinator.presentAlert(with: requestError.alertViewModel)
                        .do(onNext: { element in if element == .close { self.coordinator.dismissScreen() } })
                        .filter { $0 == .retry }
                        .map { _ in () }
                }
            }
            .startWith(.startLoading)
    }
}

extension HomeDataUseCase {
    enum RequestType {
        case allRestaurants
        case searchedRestaurants(searchValue: String)
    }

    enum RequestError: Int {
        case forbidden = 403
        case general

        init(statusCode: Int?) {
            let code = statusCode ?? 0
            self = RequestError(rawValue: code) ?? .general
        }
    }
}

extension HomeDataUseCase.RequestError {
    var alertViewModel: UIAlertController.ViewModel<AlertReponse> {
        switch self {
        case .forbidden:
            return .init(
                title: "Unable to Retrieve Data",
                message: "An user Key is needed to use the Zomato API. Generate one in the Zomato website and add it in the Base.strings before running the app",
                style: .alert,
                actions: [
                    .init(title: "Close", style: .destructive, response: .close)
                ]
            )

        case .general:
            return .init(
                title: "Unable to Retrieve Data",
                message: "An error during the data request happened. Please, try again later",
                style: .alert,
                actions: [
                    .init(title: "Retry", style: .default, response: .retry),
                    .init(title: "Close", style: .destructive, response: .close)
                ]
            )
        }
    }

    enum AlertReponse {
        case retry
        case close
    }
}
