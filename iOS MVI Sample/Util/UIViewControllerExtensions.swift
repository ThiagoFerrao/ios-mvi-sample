import UIKit

protocol PresentableViewController: class {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
}

extension UIViewController {
    func push(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}
