import XCTest
import Alamofire
@testable import iOS_MVI_Sample

final class HomeDataRequestTest: XCTestCase {

    private var testRequests: [HomeDataRequest]!

    override func setUp() {
        super.setUp()

        testRequests = [
            .allCategories,
            .searchRestaurants(searchValue: nil),
            .searchRestaurants(searchValue: "value")
        ]
    }

    func testRequestPath() {
        let testRequestsPaths = testRequests.map { $0.path }

        let expectedPaths = [
            GenString.Home.Request.Path.categories,
            GenString.Home.Request.Path.search,
            GenString.Home.Request.Path.search
        ]

        XCTAssertEqual(testRequestsPaths, expectedPaths)
    }

    func testRequestParameters() {
        let testRequestsParameters = testRequests.map { $0.parameters }

        let expectedParameters: [[String : Any]?] = [
            nil,
            nil,
            [GenString.Home.Request.Parameter.search : "value"]
        ]

        for (testRequestParameter, expectedRawParameter) in zip(testRequestsParameters, expectedParameters) {
            guard let expectedParameter = expectedRawParameter else {
                XCTAssertNil(testRequestParameter)
                continue
            }

            testRequestParameter?.forEach({ testParameterKey, testParameterValue in
                XCTAssert(compareAnys(
                    type: String.self,
                    a: testParameterValue,
                    b: expectedParameter[testParameterKey] ?? ""
                ))
            })
        }
    }

    func testRequestMethod() {
        let testRequestsMethods = testRequests.map { $0.method }

        let expectedMethods: [HTTPMethod] = [.get, .get, .get]

        XCTAssertEqual(testRequestsMethods, expectedMethods)
    }
}
