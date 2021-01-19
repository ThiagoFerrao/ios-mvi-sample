import UIKit
import RxSwift

final class HomeCoordinator: HomeCoordinating {
    weak var viewController: UIViewController?

    func presentAlert<Response>(
        with viewModel: UIAlertController.ViewModel<Response>
    ) -> Observable<Response> {
        let alertResult = UIAlertController.createAlert(with: viewModel)

        present(alertResult.alertView)

        return alertResult.alertOutput
    }
}
