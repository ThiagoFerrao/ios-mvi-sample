import Foundation
import RxSwift

final class HomeInteractor: HomeInteracting {

    let initialState: HomeState
    let coordinator: HomeCoordinating
    let dataUseCase: HomeDataUseCasing

    var inputCommand: Observable<HomeCommand> = .empty()

    init(
        initialState: HomeState,
        coordinator: HomeCoordinating,
        dataUseCase: HomeDataUseCasing
    ) {
        self.initialState = initialState
        self.coordinator = coordinator
        self.dataUseCase = dataUseCase
    }

    func mutate(command: HomeCommand, state: HomeState) -> Observable<HomeMutation> {
        switch command {
        case .loadData:
            return dataUseCase.execute(with: .allRestaurants)

        case let .searchValue(term):
            return dataUseCase.execute(with: .searchedRestaurants(searchValue: term))
        }
    }

    func reduce(state: HomeState, mutation: HomeMutation) -> HomeState {
        var newState = state

        switch mutation {
        case let .showLoading(isLoading):
            newState.isLoading = isLoading

        case let .updateData(newData):
            newState.isLoading = false
            newState.restaurantsData = newData
        }

        return newState
    }

    func sideEffect(command: HomeCommand) {
        switch command {
        case .loadData, .searchValue:
            break
        }
    }
}
