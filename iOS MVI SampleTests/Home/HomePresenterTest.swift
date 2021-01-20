import XCTest
import RxSwift
import RxTest
@testable import iOS_MVI_Sample

final class HomePresenterTest: XCTestCase {

    private var testPresenter: HomePresenter!
    private var testInput: PublishSubject<HomeState>!
    private var testScheduler: TestScheduler!
    private var testOutput: TestableObserver<HomeViewModel>!

    override func setUp() {
        super.setUp()

        testPresenter = HomePresenter()
        testInput = PublishSubject()
        testScheduler = TestScheduler(initialClock: 0)
        testOutput = testScheduler.createObserver(HomeViewModel.self)

        testPresenter.inputState = testInput
        _ = testPresenter.outputViewModel.bind(to: testOutput)
    }

    func testInitialStateToInitialViewModel() {
        testInput.onNext(.initialState)

        let expectedEvents: [Event<HomeViewModel>] = [.next(.init(isLoading: true,restaurants: []))]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
    }

    func testCustomStatesToCustomViewModels() {
        testInput.onNext(.init(isLoading: true, restaurantsData: nil))
        testInput.onNext(.init(isLoading: false, restaurantsData: nil))
        testInput.onNext(.init(isLoading: true, restaurantsData: [.testModel]))
        testInput.onNext(.init(isLoading: false, restaurantsData: [.testModel]))

        let expectedEvents: [Event<HomeViewModel>] = [
            .next(.init(isLoading: true, restaurants: [])),
            .next(.init(isLoading: false, restaurants: [])),
            .next(.init(isLoading: true, restaurants: [.testModel])),
            .next(.init(isLoading: false, restaurants: [.testModel]))
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
    }
}
