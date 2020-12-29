import Foundation
import RxSwift

final class HomePresenter: HomePresenting {

    var inputState: Observable<HomeState> = .empty()

    func stateToViewModel(state: HomeState) -> HomeViewModel {
        return .init(state: state)
    }
}
