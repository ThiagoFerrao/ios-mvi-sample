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
                title: GenString.Alert.Title.error,
                message: GenString.Alert.Message.userKeyError,
                style: .alert,
                actions: [
                    .init(title: GenString.Alert.Action.retry, style: .default, response: .retry)
                ]
            )

        case .general:
            return .init(
                title: GenString.Alert.Title.error,
                message: GenString.Alert.Message.defaultError,
                style: .alert,
                actions: [
                    .init(title: GenString.Alert.Action.retry, style: .default, response: .retry)
                ]
            )
        }
    }

    enum AlertReponse {
        case retry
        case close
    }
}
