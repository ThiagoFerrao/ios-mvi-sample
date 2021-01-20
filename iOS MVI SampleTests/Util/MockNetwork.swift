import Foundation
import RxSwift
@testable import iOS_MVI_Sample

final class MockNetwork: Networking {

    private init() { }

    static let shared = MockNetwork()

    private var mockResposeList: [MockReponse] = []

    func addMockResponse(_ mockReponse: MockReponse) {
        mockResposeList.insert(mockReponse, at: 0)
    }

    func clearMockResponses() {
        mockResposeList.removeAll()
    }

    func request(with networkRequest: NetworkRequest) -> Single<Void> {
        return .create(subscribe: { [weak self] singleObserver -> Disposable in
            do {
                let mockResponse = try (self?.mockResposeList.popLast()).unwrapOrThrow()

                switch mockResponse {
                case .success:
                    singleObserver(.success(()))
                case let .failure(error):
                    singleObserver(.error(error))
                }
            } catch { }
            return Disposables.create()
        })
    }

    func request<T>(with networkRequest: NetworkRequest) -> Single<T> where T : Decodable {
        return .create(subscribe: { [weak self] singleObserver -> Disposable in
            do {
                let mockResponse = try (self?.mockResposeList.popLast()).unwrapOrThrow()

                switch mockResponse {
                case let .success(data):
                    let reponseData = try JSONDecoder().decode(T.self, from: data.unwrapOrThrow())
                    singleObserver(.success(reponseData))
                case let .failure(error):
                    singleObserver(.error(error))
                }
            } catch { }
            return Disposables.create()
        })
    }
}

enum MockReponse {
    case success(data: Data?)
    case failure(error: NetworkError)
}
