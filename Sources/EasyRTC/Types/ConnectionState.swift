import Foundation

@objc
public enum ReconnectMode: Int, Sendable {
    case quick
    case full
}

@objc
public enum ConnectionState: Int, Sendable {
    case disconnected
    case connecting
    case reconnecting
    case connected
}

extension ConnectionState: Identifiable {
    public var id: Int {
        rawValue
    }
}
