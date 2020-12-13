import Foundation
import RxSwift

protocol RxInteracting: class {
    associatedtype Command
    associatedtype Mutation
    associatedtype State

    var initialState: State { get }
    var inputCommand: Observable<Command> { get set }
    var outputState: Observable<State> { get }
    func mutate(command: Command, state: State) -> Observable<Mutation>
    func reduce(state: State, mutation: Mutation) -> State
}

class RxInteractor<Command, Mutation, State>: RxInteracting {

    init(initialState: State) {
        self.initialState = initialState
    }

    let initialState: State

    var inputCommand: Observable<Command> = .empty()
    
    var outputState: Observable<State> {
        let currentState = PublishSubject<State>()

        return inputCommand
            .withLatestFrom(currentState) { ($0, $1) }
            .flatMap { [weak self] command, state -> Observable<Mutation> in
                guard let self = self else {
                    return .empty()
                }
                return self.mutate(command: command, state: state)
            }
            .scan(initialState, accumulator: reduce)
            .startWith(initialState)
            .do(onNext: { currentState.onNext($0) })
    }

    func mutate(command: Command, state: State) -> Observable<Mutation> {
        preconditionFailure("This method must be overridden")
    }

    func reduce(state: State, mutation: Mutation) -> State {
        preconditionFailure("This method must be overridden")
    }
}
