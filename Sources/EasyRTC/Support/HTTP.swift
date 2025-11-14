/* -- */

import Foundation

class HTTP: NSObject {
    private static let operationQueue = OperationQueue()

    private static let session: URLSession = .init(configuration: .default,
                                                   delegate: nil,
                                                   delegateQueue: operationQueue)

    static func requestValidation(from url: URL, token: String) async throws -> String {
        // let data = try await requestData(from: url, token: token)
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: .defaultHTTPConnect)
        // Attach token to header
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Make the data request
        let (data, _) = try await session.data(for: request)
        // Convert to string
        guard let string = String(data: data, encoding: .utf8) else {
            throw LiveKitError(.failedToConvertData, message: "Failed to convert string")
        }

        return string
    }
}
