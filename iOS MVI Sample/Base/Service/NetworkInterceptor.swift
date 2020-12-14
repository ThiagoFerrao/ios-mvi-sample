import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        request.headers.add(name: "Accept", value: "application/json")
        request.headers.add(name: "user-key", value: "") // TODO: Add Zomato User Key as Env Key

        request.timeoutInterval = 10

        completion(.success(request))
    }
}
