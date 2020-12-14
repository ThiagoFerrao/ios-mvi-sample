import UIKit

final class HomeFactory: RxFactoring {

    static func make(with parameter: Void) -> UIViewController {
        return HomeViewController()
    }
}
