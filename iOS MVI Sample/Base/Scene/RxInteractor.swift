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

    final let initialState: State

    final var inputCommand: Observable<Command> = .empty()
    
    final var outputState: Observable<State> {
        let currentState = PublishSubject<State>()

        return inputCommand
            .withLatestFrom(currentState) { ($0, $1) }
            .flatMap { [weak self] command, state -> Observable<Mutation> in
                self?.mutate(command: command, state: state) ?? .empty()
            }
            .scan(initialState, accumulator: reduce)
            .startWith(initialState)
            .do(onNext: { currentState.onNext($0) })
    }

    func mutate(command: Command, state: State) -> Observable<Mutation> {
        preconditionFailure(GenString.Development.Assertion.mustOverrideMethod)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        preconditionFailure(GenString.Development.Assertion.mustOverrideMethod)
    }
}
