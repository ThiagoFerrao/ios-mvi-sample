import Foundation
import RxSwift

protocol RxUseCasing: class {
    associatedtype Parameter
    associatedtype Mutation

    func execute(with parameter: Parameter) -> Observable<Mutation>
}

class RxUseCase<Parameter, Mutation>: RxUseCasing {

    func execute(with parameter: Parameter) -> Observable<Mutation> {
        preconditionFailure("This method must be overridden")
    }
}
