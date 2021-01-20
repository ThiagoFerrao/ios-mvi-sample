import UIKit

protocol RxCoordinating: class {
    var presentableViewController: PresentableViewController? { get set }

    func present(_ viewController: UIViewController, completion: (() -> Void)?)
    func dismiss(completion: (() -> Void)?)
    func push(_ viewController: UIViewController)
    func pop()
}

extension RxCoordinating {

    func present(_ viewControllerToPresent: UIViewController, completion: (() -> Void)? = nil) {
        execute { [weak self] in
            self?.presentableViewController?.present(viewControllerToPresent, animated: true, completion: completion)
        }
    }

    func dismiss(completion: (() -> Void)? = nil) {
        execute { [weak self] in
            self?.presentableViewController?.dismiss(animated: true, completion: completion)
        }
    }

    func push(_ viewControllerToPush: UIViewController) {
        execute { [weak self] in
            self?.presentableViewController?.push(viewControllerToPush, animated: true)
        }
    }

    func pop() {
        execute { [weak self] in
            self?.presentableViewController?.pop(animated: true)
        }
    }

    private func execute(handler: @escaping (() -> Void)) {
        if Thread.current.isMainThread {
            handler()
            return
        }
        DispatchQueue.main.async { handler() }
    }
}
