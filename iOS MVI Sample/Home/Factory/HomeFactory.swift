import UIKit

final class HomeFactory: HomeFactoring {

    static func make(with parameter: Void) -> UIViewController {

        let dataFetcher = HomeDataFetcher(
            network: Network.shared
        )

        let coordinator = HomeCoordinator()

        let dataUseCase = HomeDataUseCase(
            dataFetcher: dataFetcher,
            coordinator: coordinator
        )

        let interactor = HomeInteractor(
            initialState: .initialState,
            coordinator: coordinator,
            dataUseCase: dataUseCase
        )

        let presenter = HomePresenter()

        let viewController = HomeViewController(
            presenter: presenter,
            interactor: interactor
        ) { viewOutput in
            interactor.inputCommand = viewOutput.startWith(.loadData)
            presenter.inputState = interactor.outputState
            return presenter.outputViewModel
        }

        coordinator.presentableViewController = viewController

        return viewController
    }
}
