import UIKit
import RxSwift

final class HomeCoordinator: HomeCoordinating {
    weak var presentableViewController: PresentableViewController?

    func presentAlert(with viewModel: UIAlertController.ViewModel<AlertReponse>) -> Observable<AlertReponse> {
        let alertResult = UIAlertController.createAlert(with: viewModel)

        present(alertResult.alertView)

        return alertResult.alertOutput
    }
}

extension HomeCoordinator {
    enum AlertReponse {
        case retry
        case close
    }
}
