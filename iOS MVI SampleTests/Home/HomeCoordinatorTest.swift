import XCTest
@testable import iOS_MVI_Sample

final class HomeCoordinatorTest: XCTestCase {

    private var testViewController: MockViewController!
    private var testCoordinator: HomeCoordinator!

    override func setUp() {
        super.setUp()

        testViewController = MockViewController()
        testCoordinator = HomeCoordinator()
        testCoordinator.presentableViewController = testViewController
    }

    func testMethodPresentAlert() {
        _ = testCoordinator.presentAlert(
            with: .init(
                title: "title",
                message: "message",
                style: .alert,
                actions: [.init(
                    title: "title",
                    style: .default,
                    response: .close
                )]
            )
        )

        XCTAssertNotNil(testViewController.presentedViewController)
        XCTAssert(testViewController.presentedViewController?.isKind(of: UIAlertController.self) ?? false)
    }
}
