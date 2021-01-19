import Foundation
import RxSwift

protocol RxPresenting: class {
    associatedtype State
    associatedtype ViewModel: Equatable

    var inputState: Observable<State> { get set }
    var outputViewModel: Observable<ViewModel> { get }

    func stateToViewModel(state: State) -> ViewModel
}

extension RxPresenting {

    var outputViewModel: Observable<ViewModel> {
        return inputState
            .compactMap { [weak self] in
                self?.stateToViewModel(state: $0)
            }
    }
}
