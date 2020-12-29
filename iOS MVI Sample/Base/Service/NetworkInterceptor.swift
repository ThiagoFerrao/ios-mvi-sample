import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

        request.headers.add(
            name: GenString.Network.Header.acceptKey,
            value: GenString.Network.Header.acceptValue
        )

        request.headers.add(
            name: GenString.Network.Header.userKey,
            value: GenString.Network.Header.userValue
        )

        request.timeoutInterval = 10

        completion(.success(request))
    }
}
