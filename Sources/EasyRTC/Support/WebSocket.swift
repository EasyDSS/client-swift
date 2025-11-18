import Foundation

typealias WebSocketStream = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>

class WebSocket: NSObject, Loggable, AsyncSequence, URLSessionWebSocketDelegate {
    typealias AsyncIterator = WebSocketStream.Iterator
    typealias Element = URLSessionWebSocketTask.Message

    private var streamContinuation: WebSocketStream.Continuation?
    private var connectContinuation: CheckedContinuation<Void, Error>?

    private let request: URLRequest

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        // explicitly set timeout intervals
        config.timeoutIntervalForRequest = TimeInterval(60)
        config.timeoutIntervalForResource = TimeInterval(604_800)
        config.shouldUseExtendedBackgroundIdleMode = true
        config.networkServiceType = .callSignaling
        #if os(iOS) || os(visionOS)
        /// https://developer.apple.com/documentation/foundation/urlsessionconfiguration/improving_network_reliability_using_multipath_tcp
        config.multipathServiceType = .handover
        #endif
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    private lazy var task: URLSessionWebSocketTask = urlSession.webSocketTask(with: request)

    private lazy var stream: WebSocketStream = WebSocketStream { continuation in
        streamContinuation = continuation
        waitForNextValue()
    }

    init(url: URL) async throws {
        request = URLRequest(url: url,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: .defaultSocketConnect)
        super.init()
        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                connectContinuation = continuation
                task.resume()
            }
        } onCancel: {
            // Cancel(reset) when Task gets cancelled
            close()
        }
    }

    deinit {
        close()
    }

    func close() {
        task.cancel(with: .normalClosure, reason: nil)
        connectContinuation?.resume(throwing: LiveKitError(.cancelled))
        connectContinuation = nil
        streamContinuation?.finish(throwing: LiveKitError(.cancelled))
        streamContinuation = nil
    }

    // MARK: - AsyncSequence

    func makeAsyncIterator() -> AsyncIterator {
        stream.makeAsyncIterator()
    }

    private func waitForNextValue() {
        guard task.closeCode == .invalid else {
            streamContinuation?.finish(throwing: LiveKitError(.invalidState))
            streamContinuation = nil
            return
        }

        task.receive(completionHandler: { [weak self] result in
            guard let continuation = self?.streamContinuation else {
                return
            }

            do {
                let message = try result.get()
                continuation.yield(message)
                self?.waitForNextValue()
            } catch {
                continuation.finish(throwing: LiveKitError.from(error: error))
                self?.streamContinuation = nil
            }
        })
    }

    // MARK: - Send

    func send(data: Data) async throws {
        let message = URLSessionWebSocketTask.Message.data(data)
        try await task.send(message)
    }

    // MARK: - URLSessionWebSocketDelegate

    func urlSession(_: URLSession, webSocketTask _: URLSessionWebSocketTask, didOpenWithProtocol _: String?) {
        connectContinuation?.resume()
        connectContinuation = nil
    }

    func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: Error?) {
        log("didCompleteWithError: \(String(describing: error))", error != nil ? .error : .debug)

        if let error {
            let lkError = LiveKitError.from(error: error) ?? LiveKitError(.unknown)
            connectContinuation?.resume(throwing: lkError)
            streamContinuation?.finish(throwing: lkError)
        } else {
            connectContinuation?.resume()
            streamContinuation?.finish()
        }

        connectContinuation = nil
        streamContinuation = nil
    }
}
