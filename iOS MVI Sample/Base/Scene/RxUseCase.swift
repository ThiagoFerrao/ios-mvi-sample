import Foundation
import RxSwift

protocol RxUseCasing: class {
    associatedtype Parameter
    associatedtype Mutation

    func execute(with parameter: Parameter) -> Observable<Mutation>
}

extension RxUseCasing where Parameter == Void {

    func execute() -> Observable<Mutation> {
        return execute(with: ())
    }
}

class RxUseCase<Parameter, Mutation>: RxUseCasing {

    func execute(with parameter: Parameter) -> Observable<Mutation> {
        preconditionFailure(GenString.Development.Assertion.mustOverrideMethod)
    }
}
