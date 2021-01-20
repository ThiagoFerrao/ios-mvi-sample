import Foundation
import RxSwift
@testable import iOS_MVI_Sample

final class MockUseCase<Parameter, Mutation>: RxUseCase<Parameter, Mutation> {

    private(set) var useCaseExecuted = false
    private var mockMutation: Mutation?

    func addMockMutation(_ mutation: Mutation) {
        mockMutation = mutation
    }

    override func execute(with parameter: Parameter) -> Observable<Mutation> {
        useCaseExecuted = true

        guard let mutation = mockMutation else { return .empty() }
        return .just(mutation)
    }
}
