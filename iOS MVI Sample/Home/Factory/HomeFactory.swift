import UIKit

final class HomeFactory: HomeFactoring {

    static func make(with parameter: Void) -> UIViewController {
        return HomeViewController()
    }
}
