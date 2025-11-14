/* -- */

import Foundation

@objc
public enum ReconnectMode: Int, Sendable {
    /// Quick reconnection mode attempts to maintain the same session, reusing existing
    /// transport connections and published tracks. This is faster but may not succeed
    /// in all network conditions.
    case quick

    /// Full reconnection mode performs a complete new connection to the LiveKit server,
    /// closing existing connections and re-publishing all tracks. This is slower but
    /// more reliable for recovering from severe connection issues.
    case full
}

@objc
public enum ConnectionState: Int, Sendable {
    case disconnected
    case connecting
    case reconnecting
    case connected
    case disconnecting
}

extension ConnectionState: Identifiable {
    public var id: Int {
        rawValue
    }
}
