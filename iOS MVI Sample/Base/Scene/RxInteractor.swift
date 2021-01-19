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
    func sideEffect(command: Command)
}

extension RxInteracting {

    var outputState: Observable<State> {
        let currentState = ReplaySubject<State>.create(bufferSize: 1)

        return inputCommand
            .subscribeOn(AppScheduler.background)
            .do(onNext: { [weak self] in self?.sideEffect(command: $0) })
            .withLatestFrom(currentState) { ($0, $1) }
            .flatMap { [weak self] command, state -> Observable<Mutation> in
                self?.mutate(command: command, state: state) ?? .empty()
            }
            .scan(initialState, accumulator: reduce)
            .startWith(initialState)
            .do(onNext: { currentState.onNext($0) })
    }
}
