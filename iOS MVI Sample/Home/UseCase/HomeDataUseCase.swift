import Foundation
import Alamofire
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
            .map {
                guard $0.isEmpty else { return .updateData($0) }
                throw NetworkError(
                    afError: AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: -1)),
                    jsonData: nil
                )
            }
            .retryWhen { errorObservable in
                return errorObservable.flatMap { [weak self] error -> Observable<Void> in
                    guard let self = self else { return .error(error) }
                    let requestError = RequestError(statusCode: error.asNetworkError?.afError.responseCode)
                    return self.coordinator.presentAlert(with: requestError.alertViewModel)
                        .map {
                            guard $0 == .retry else { throw error }
                            return ()
                        }
                }
            }
            .catchErrorJustReturn(.showLoading(false))
            .startWith(.showLoading(true))
    }
}

extension HomeDataUseCase {
    enum RequestType {
        case allRestaurants
        case searchedRestaurants(searchValue: String?)
    }

    enum RequestError: Int {
        case emptyResponse = -1
        case forbidden = 403
        case general

        init(statusCode: Int?) {
            let code = statusCode ?? 0
            self = RequestError(rawValue: code) ?? .general
        }
    }
}

extension HomeDataUseCase.RequestError {
    var alertViewModel: UIAlertController.ViewModel<HomeCoordinator.AlertReponse> {
        switch self {
        case .emptyResponse:
            return .init(
                title: GenString.Alert.Title.emptyResponse,
                message: GenString.Alert.Message.emptyResponse,
                style: .alert,
                actions: [
                    .init(title: GenString.Alert.Action.close, style: .cancel, response: .close)
                ]
            )

        case .forbidden:
            return .init(
                title: GenString.Alert.Title.error,
                message: GenString.Alert.Message.userKeyError,
                style: .alert,
                actions: [
                    .init(title: GenString.Alert.Action.close, style: .cancel, response: .close)
                ]
            )

        case .general:
            return .init(
                title: GenString.Alert.Title.error,
                message: GenString.Alert.Message.defaultError,
                style: .alert,
                actions: [
                    .init(title: GenString.Alert.Action.retry, style: .default, response: .retry),
                    .init(title: GenString.Alert.Action.close, style: .cancel, response: .close)
                ]
            )
        }
    }
}
