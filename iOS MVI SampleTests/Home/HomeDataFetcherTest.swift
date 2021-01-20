import XCTest
import Alamofire
import RxSwift
import RxTest
@testable import iOS_MVI_Sample

final class HomeDataFetcherTest: XCTestCase {

    private var testNetwork: MockNetwork!
    private var testDataFetcher: HomeDataFetcher!
    private var testScheduler: TestScheduler!
    private var testCategoriesOutput: TestableObserver<[HomeCategoryModel]>!
    private var testRestaurantsOutput: TestableObserver<[HomeRestaurantModel]>!

    override func setUp() {
        super.setUp()

        testNetwork = MockNetwork.shared
        testDataFetcher = HomeDataFetcher(network: testNetwork)
        testScheduler = TestScheduler(initialClock: 0)
        testCategoriesOutput = testScheduler.createObserver([HomeCategoryModel].self)
        testRestaurantsOutput = testScheduler.createObserver([HomeRestaurantModel].self)
    }

    override func tearDown() {
        testNetwork.clearMockResponses()

        super.tearDown()
    }

    func testMethodFetchAllCategoriesSuccess() {
        let successData = Bundle.data(bundle: "home", file: "categories", testCase: self)
        testNetwork.addMockResponse(.success(data: successData))

        _ = testDataFetcher.fetchAllCategories().asObservable()
            .bind(to: testCategoriesOutput)

        let expectedEvents: [Event<[HomeCategoryModel]>] = [.next(.testListModel), .completed]

        XCTAssertEqual(testCategoriesOutput.valueEvents, expectedEvents)
    }

    func testMethodFetchAllCategoriesFailure() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))
        let networkError = NetworkError(afError: afError, jsonData: nil)
        testNetwork.addMockResponse(.failure(error: networkError))

        _ = testDataFetcher.fetchAllCategories().asObservable()
            .bind(to: testCategoriesOutput)

        let expectedEvents: [Event<[HomeCategoryModel]>] = [.error(networkError)]

        XCTAssertEqual(testCategoriesOutput.valueEvents, expectedEvents)
    }

    func testMethodFetchAllRestaurantsSuccess() {
        let successData = Bundle.data(bundle: "home", file: "restaurants", testCase: self)
        testNetwork.addMockResponse(.success(data: successData))

        _ = testDataFetcher.fetchAllRestaurants().asObservable()
            .bind(to: testRestaurantsOutput)

        let expectedEvents: [Event<[HomeRestaurantModel]>] = [.next(.testListModel), .completed]

        XCTAssertEqual(testRestaurantsOutput.valueEvents, expectedEvents)
    }

    func testMethodFetchAllRestaurantsFailure() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))
        let networkError = NetworkError(afError: afError, jsonData: nil)
        testNetwork.addMockResponse(.failure(error: networkError))

        _ = testDataFetcher.fetchAllRestaurants().asObservable()
            .bind(to: testRestaurantsOutput)

        let expectedEvents: [Event<[HomeRestaurantModel]>] = [.error(networkError)]

        XCTAssertEqual(testRestaurantsOutput.valueEvents, expectedEvents)
    }

    func testMethodFetchSearchedRestaurantsSuccess() {
        let successData = Bundle.data(bundle: "home", file: "restaurants", testCase: self)
        testNetwork.addMockResponse(.success(data: successData))

        _ = testDataFetcher.fetchSearchedRestaurants(searchValue: "value").asObservable()
            .bind(to: testRestaurantsOutput)

        let expectedEvents: [Event<[HomeRestaurantModel]>] = [.next(.testListModel), .completed]

        XCTAssertEqual(testRestaurantsOutput.valueEvents, expectedEvents)
    }

    func testMethodFetchSearchedRestaurantsFailure() {
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500))
        let networkError = NetworkError(afError: afError, jsonData: nil)
        testNetwork.addMockResponse(.failure(error: networkError))

        _ = testDataFetcher.fetchSearchedRestaurants(searchValue: "value").asObservable()
            .bind(to: testRestaurantsOutput)

        let expectedEvents: [Event<[HomeRestaurantModel]>] = [.error(networkError)]

        XCTAssertEqual(testRestaurantsOutput.valueEvents, expectedEvents)
    }
}
