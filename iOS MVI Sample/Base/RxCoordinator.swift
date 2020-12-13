import UIKit

protocol RxCoordinating: class {
    var viewController: UIViewController? { get set }
    func present(_ viewController: UIViewController)
    func push(_ viewController: UIViewController)
    func dismiss()
    func pop()
}

class RxCoordinator: RxCoordinating {

    weak var viewController: UIViewController?

    func present(_ viewControllerToPresent: UIViewController) {
        execute { [weak self] in
            self?.viewController?.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }

    func dismiss() {
        execute { [weak self] in
            self?.viewController?.dismiss(animated: true, completion: nil)
        }
    }

    func push(_ viewControllerToPush: UIViewController) {
        execute { [weak self] in
            self?.viewController?.navigationController?.pushViewController(viewControllerToPush, animated: true)
        }
    }

    func pop() {
        execute { [weak self] in
            self?.viewController?.navigationController?.popViewController(animated: true)
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
