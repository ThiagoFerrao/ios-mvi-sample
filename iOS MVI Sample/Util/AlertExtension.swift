import UIKit
import RxSwift

extension UIAlertController {
    static func createAlert<Response>(
        with viewModel: ViewModel<Response>
    ) -> Result<Response> {
        let alertOutput = PublishSubject<Response>()

        let alertController = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: viewModel.style
        )

        viewModel.actions.forEach { action in
            alertController.addAction(.init(
                title: action.title,
                style: action.style,
                handler: { _ in alertOutput.onNext(action.response) }
            ))
        }

        return .init(alertView: alertController, alertOutput: alertOutput.asObservable())
    }
}

extension UIAlertController {
    struct ViewModel<Response> {
        let title: String?
        let message: String?
        let style: UIAlertController.Style
        let actions: [Action<Response>]
    }

    struct Action<Response> {
        let title: String?
        let style: UIAlertAction.Style
        let response: Response
    }

    struct Result<Response> {
        let alertView: UIAlertController
        let alertOutput: Observable<Response>
    }
}
