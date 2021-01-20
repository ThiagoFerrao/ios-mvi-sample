import UIKit
@testable import iOS_MVI_Sample

final class MockViewController: PresentableViewController {
    private(set) var presentedViewController: UIViewController? = nil
    private(set) var pushedViewControllers: [UIViewController] = []

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentedViewController = viewControllerToPresent
        completion?()
    }

    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        presentedViewController = nil
        completion?()
    }

    func push(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
    }

    func pop(animated: Bool) {
        _ = pushedViewControllers.popLast()
    }
}
