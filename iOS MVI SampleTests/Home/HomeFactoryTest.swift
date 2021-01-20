import XCTest
@testable import iOS_MVI_Sample

final class HomeFactoryTest: XCTestCase {

    func testViewCreated() {
        let expectedViewController = HomeFactory.make(with: ())

        XCTAssert(expectedViewController.isKind(of: HomeViewController.self))
    }
}
