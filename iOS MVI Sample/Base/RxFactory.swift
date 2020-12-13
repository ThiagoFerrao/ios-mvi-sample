import UIKit

protocol RxFactoring: class {
    associatedtype Parameter

    static func make(with parameter: Parameter) -> UIViewController
}

class RxFactory<Parameter>: RxFactoring {

    static func make(with parameter: Parameter) -> UIViewController {
        preconditionFailure("This method must be overridden")
    }
}
