import Foundation
import RxSwift

protocol RxPresenting: class {
    associatedtype State
    associatedtype ViewModel

    var inputState: Observable<State> { get set }
    var outputViewModel: Observable<ViewModel> { get }
    func stateToViewModel(state: State) -> ViewModel
}

class RxPresenter<State, ViewModel>: RxPresenting {

    final var inputState: Observable<State> = .empty()

    final var outputViewModel: Observable<ViewModel> {
        return inputState
            .compactMap { [weak self] in
                self?.stateToViewModel(state: $0)
            }
    }

    func stateToViewModel(state: State) -> ViewModel {
        preconditionFailure("This method must be overridden")
    }
}
