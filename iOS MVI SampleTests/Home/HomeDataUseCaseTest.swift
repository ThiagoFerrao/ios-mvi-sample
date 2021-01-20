import XCTest
import Alamofire
import RxSwift
import RxTest
@testable import iOS_MVI_Sample

final class HomeDataUseCaseTest: XCTestCase {

    private var testNetwork: MockNetwork!
    private var testDataFetcher: HomeDataFetcher!
    private var testCoordinator: TestHomeCoordinator!
    private var testUseCase: HomeDataUseCase!
    private var testScheduler: TestScheduler!
    private var testOutput: TestableObserver<HomeMutation>!

    override func setUp() {
        super.setUp()

        testNetwork = MockNetwork.shared
        testDataFetcher = HomeDataFetcher(network: testNetwork)
        testCoordinator = TestHomeCoordinator()
        testUseCase = HomeDataUseCase(
            dataFetcher: testDataFetcher,
            coordinator: testCoordinator
        )

        testScheduler = TestScheduler(initialClock: 0)
        testOutput = testScheduler.createObserver(HomeMutation.self)
    }

    func testParamAllRestaurantsSuccess() {
        let successData = Bundle.data(bundle: "home", file: "restaurants", testCase: self)
        testNetwork.addMockResponse(.success(data: successData))
        
        _ = testUseCase.execute(with: .allRestaurants).bind(to: testOutput)

        let expectedEvents: [Event<HomeMutation>] = [
            .next(.showLoading(true)),
            .next(.updateData(.testListModel)),
            .completed
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
    }

    func testParamAllRestaurantsSuccessWithEmptyListAndDenyRetry() {
        let successData = Bundle.data(bundle: "home", file: "restaurants_empty", testCase: self)
        testNetwork.addMockResponse(.success(data: successData))

        testCoordinator.addMockResponse(.close)

        _ = testUseCase.execute(with: .allRestaurants).bind(to: testOutput)

        let expectedEvents: [Event<HomeMutation>] = [
            .next(.showLoading(true)),
            .next(.showLoading(false)),
            .completed
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
        XCTAssert(testCoordinator.presentAlertExecuted)
    }

    func testParamAllRestaurantsFailureAndDenyRetry() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 403))
        let networkError = NetworkError(afError: afError, jsonData: nil)
        testNetwork.addMockResponse(.failure(error: networkError))

        testCoordinator.addMockResponse(.close)

        _ = testUseCase.execute(with: .allRestaurants).bind(to: testOutput)

        let expectedEvents: [Event<HomeMutation>] = [
            .next(.showLoading(true)),
            .next(.showLoading(false)),
            .completed
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
        XCTAssert(testCoordinator.presentAlertExecuted)
    }

    func testParamSearchedRestaurantsSuccess() {
        let successData = Bundle.data(bundle: "home", file: "restaurants", testCase: self)
        testNetwork.addMockResponse(.success(data: successData))

        _ = testUseCase.execute(with: .searchedRestaurants(searchValue: "value")).bind(to: testOutput)

        let expectedEvents: [Event<HomeMutation>] = [
            .next(.showLoading(true)),
            .next(.updateData(.testListModel)),
            .completed
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
    }

    func testParamSearchedRestaurantsFailureAndAcceptRetry() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))
        let networkError = NetworkError(afError: afError, jsonData: nil)
        testNetwork.addMockResponse(.failure(error: networkError))

        let successData = Bundle.data(bundle: "home", file: "restaurants", testCase: self)
        testNetwork.addMockResponse(.success(data: successData))

        testCoordinator.addMockResponse(.retry)

        _ = testUseCase.execute(with: .searchedRestaurants(searchValue: "value")).bind(to: testOutput)

        let expectedEvents: [Event<HomeMutation>] = [
            .next(.showLoading(true)),
            .next(.updateData(.testListModel)),
            .completed
        ]

        XCTAssertEqual(testOutput.valueEvents, expectedEvents)
        XCTAssert(testCoordinator.presentAlertExecuted)
    }
}
