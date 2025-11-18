import Foundation

class HTTP: NSObject {
    private static let operationQueue = OperationQueue()

    private static let session: URLSession = .init(configuration: .default,
                                                   delegate: nil,
                                                   delegateQueue: operationQueue)

    static func requestData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: .defaultHTTPConnect)
        let (data, _) = try await session.data(for: request)
        return data
    }

    static func requestString(from url: URL) async throws -> String {
        let data = try await requestData(from: url)
        guard let string = String(data: data, encoding: .utf8) else {
            throw LiveKitError(.failedToConvertData, message: "Failed to convert string")
        }
        return string
    }
}
