import Foundation
import RxSwift

protocol RxUseCasing: class {
    associatedtype Parameter
    associatedtype Mutation

    func execute(with parameter: Parameter) -> Observable<Mutation>
}
