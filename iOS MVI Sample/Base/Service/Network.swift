import Foundation
import Alamofire
import RxSwift

protocol Networking {
    func request<T: Decodable>(with networkRequest: NetworkRequest) -> Single<T>
}

class Network: Networking {
    static let shared = Network()

    private(set) lazy var session: Session = .default
    var interceptor: RequestInterceptor? {
        didSet {
            session = Session(interceptor: interceptor)
        }
    }

    func request<T: Decodable>(with networkRequest: NetworkRequest) -> Single<T> {
        return session.rx.request(with: networkRequest)
            .map { data in
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                return try JSONDecoder().decode(T.self, from: jsonData)
            }
    }
}

extension Session: ReactiveCompatible { }

extension Reactive where Base: Session {

    func request(with networkRequest: NetworkRequest) -> Single<Any> {

        return .create(subscribe: { singleObserver -> Disposable in
            let request = base.request(
                networkRequest,
                method: networkRequest.method,
                parameters: networkRequest.parameters,
                encoding: networkRequest.encoding,
                headers: networkRequest.headers
            )
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    singleObserver(.success(data))

                case let .failure(error):
                    singleObserver(.error(error))
                }
            }

            DebugChecker.executeInDebug {
                request.cURLDescription { print($0) }
            }

            return Disposables.create {
                request.cancel()
            }
        })
    }
}
