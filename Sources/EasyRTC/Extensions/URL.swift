import Foundation

extension URL {
    var isValidForConnect: Bool {
        host != nil && (scheme == "ws" || scheme == "wss" || scheme == "https" || scheme == "http")
    }

    var isValidForSocket: Bool {
        host != nil && (scheme == "ws" || scheme == "wss")
    }

    var isSecure: Bool {
        scheme == "https" || scheme == "wss"
    }
}
