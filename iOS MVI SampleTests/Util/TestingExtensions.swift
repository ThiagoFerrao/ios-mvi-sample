import XCTest
import RxSwift
import RxTest
@testable import iOS_MVI_Sample

extension Bundle {
    class func data(bundle: String, file: String, testCase: XCTestCase) -> Data {
        do {
            let testBundle = Bundle(for: type(of: testCase))
            let bundleUrl = try testBundle.url(forResource: bundle, withExtension: "bundle").unwrapOrThrow()
            let fileUrl = try (Bundle(url: bundleUrl)?.url(forResource: file, withExtension: "json")).unwrapOrThrow()
            return try Data(contentsOf: fileUrl)
        } catch {
            fatalError(GenString.Development.Assertion.bundleFileNotFound)
        }
    }
}

extension TestableObserver {
    var valueEvents: [Event<Element>] {
        return events.map { $0.value }
    }
}

func compareAnys<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
    guard let a = a as? T, let b = b as? T else {
        return false
    }

    return a == b
}
