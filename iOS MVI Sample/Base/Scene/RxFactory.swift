import UIKit

protocol RxFactoring: class {
    associatedtype Parameter

    static func make(with parameter: Parameter) -> UIViewController
}

extension RxFactoring where Parameter == Void {

    static func make() -> UIViewController {
        return make(with: ())
    }
}
