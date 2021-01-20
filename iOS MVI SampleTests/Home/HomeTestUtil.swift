import Foundation
import RxSwift
@testable import iOS_MVI_Sample

extension HomeCategoryModel {
    static var testModel: HomeCategoryModel {
        return .init(id: 1, name: "name")
    }
}

extension HomeRestaurantModel {
    static var testModel: HomeRestaurantModel {
        return .init(id: "id", name: "name", address: "address", cuisines: "cuisines", timings: "timings")
    }
}

extension Collection where Element == HomeCategoryModel {
    static var testListModel: [HomeCategoryModel] {
        return [
            .init(id: 1, name: "Delivery"),
            .init(id: 2, name: "Dine-out"),
            .init(id: 3, name: "Nightlife")
        ]
    }
}

extension Collection where Element == HomeRestaurantModel {
    static var testListModel: [HomeRestaurantModel] {
        return [
            .init(
                id: "16615034",
                name: "Whiskey Gully Wines",
                address: "25 Turner Rd, Severnlea",
                cuisines: "French, Modern Australian",
                timings: "9 AM to 5 PM (Mon, Thu), Closed (Tue-Wed),9 AM to 9 PM (Fri-Sun)"
            ),
            .init(
                id: "19170140",
                name: "GO 69 (EVERY DAY PIZZA)",
                address: "94 Ashok colony civil lines south tanakpur road pilibhit, Pilibhit Locality, Pilibhit",
                cuisines: "Pizza",
                timings: "11 AM to 11 PM"
            ),
            .init(
                id: "18483222",
                name: "Jaan",
                address: "2 Stamford Road, Level 70 Equinox Complex, Downtown Core, Singapore 178882",
                cuisines: "French",
                timings: "12 Noon to 2:30 PM, 7 PM to 11 PM (Mon-Sat),7 PM to 11 PM (Sun)"
            )
        ]
    }
}

final class TestHomeCoordinator: HomeCoordinating {
    var presentableViewController: PresentableViewController?

    private(set) var presentAlertExecuted = false
    private var mockResponse: HomeCoordinator.AlertReponse?

    func addMockResponse(_ response: HomeCoordinator.AlertReponse) {
        mockResponse = response
    }

    func presentAlert(
        with viewModel: UIAlertController.ViewModel<HomeCoordinator.AlertReponse>
    ) -> Observable<HomeCoordinator.AlertReponse> {
        presentAlertExecuted = true

        guard let response = mockResponse else { return .empty() }
        return .just(response)
    }
}
