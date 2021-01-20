import XCTest
import RxSwift
import RxTest
@testable import iOS_MVI_Sample

final class HomeInteractorTest: XCTestCase {

    private var testCoordinator: TestHomeCoordinator!
    private var testDataUseCase: MockUseCase<HomeDataUseCase.RequestType, HomeMutation>!
    private var testInteractor: HomeInteractor!
    private var testInput: PublishSubject<HomeCommand>!
    private var testScheduler: TestScheduler!
    private var testOutput: TestableObserver<HomeState>!

    override func setUp() {
        super.setUp()

        testCoordinator = TestHomeCoordinator()
        testDataUseCase = MockUseCase()
        testInteractor = HomeInteractor(
            initialState: .initialState,
            coordinator: testCoordinator,
            dataUseCase: testDataUseCase
        )

        testInput = PublishSubject()
        testScheduler = TestScheduler(initialClock: 0)
        testOutput = testScheduler.createObserver(HomeState.self)

        testInteractor.inputCommand = testInput
        _ = testInteractor.outputState.bind(to: testOutput)
    }

    func testInteractorInitialStateEvent() {
        let expectedEvents: [Event<HomeState>] = [.next(.initialState)]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
    }

    func testLoadDataCommandWithDifferentUseCaseMutationResponses() {
        testDataUseCase.addMockMutation(.showLoading(true))
        testInput.onNext(.loadData)
        testDataUseCase.addMockMutation(.showLoading(false))
        testInput.onNext(.loadData)
        testDataUseCase.addMockMutation(.updateData([.testModel]))
        testInput.onNext(.loadData)

        let expectedEvents: [Event<HomeState>] = [
            .next(.initialState),
            .next(.init(isLoading: true, restaurantsData: nil)),
            .next(.init(isLoading: false, restaurantsData: nil)),
            .next(.init(isLoading: false, restaurantsData: [.testModel]))
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
    }

    func testSearchValueCommandWithDifferentUseCaseMutationResponses() {
        testDataUseCase.addMockMutation(.showLoading(true))
        testInput.onNext(.searchValue("value1"))
        testDataUseCase.addMockMutation(.showLoading(false))
        testInput.onNext(.searchValue("value2"))
        testDataUseCase.addMockMutation(.updateData([.testModel]))
        testInput.onNext(.searchValue("value3"))

        let expectedEvents: [Event<HomeState>] = [
            .next(.initialState),
            .next(.init(isLoading: true, restaurantsData: nil)),
            .next(.init(isLoading: false, restaurantsData: nil)),
            .next(.init(isLoading: false, restaurantsData: [.testModel]))
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
    }
}
