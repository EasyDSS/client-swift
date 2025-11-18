import Foundation

/// Options used when establishing a connection.
@objc
public final class ConnectOptions: NSObject, Sendable {
    /// Automatically subscribe to ``RemoteParticipant``'s tracks.
    /// Defaults to true.
    @objc
    public let autoSubscribe: Bool

    /// The number of attempts to reconnect when the network disconnects.
    @objc
    public let reconnectAttempts: Int

    /// The delay between reconnect attempts.
    @objc
    public let reconnectAttemptDelay: TimeInterval

    @objc
    public let primaryTransportConnectTimeout: TimeInterval

    @objc
    public let publisherTransportConnectTimeout: TimeInterval

    /// Custom ice servers
    @objc
    public let iceServers: [IceServer]

    @objc
    public let iceTransportPolicy: IceTransportPolicy

    /// LiveKit server protocol version to use. Generally, it's not recommended to change this.
    @objc
    public let protocolVersion: ProtocolVersion

    @objc
    override public init() {
        autoSubscribe = true
        reconnectAttempts = 3
        reconnectAttemptDelay = .defaultReconnectAttemptDelay
        primaryTransportConnectTimeout = .defaultTransportState
        publisherTransportConnectTimeout = .defaultTransportState
        iceServers = []
        iceTransportPolicy = .all
        protocolVersion = .v12
    }

    @objc
    public init(autoSubscribe: Bool = true,
                reconnectAttempts: Int = 3,
                reconnectAttemptDelay: TimeInterval = .defaultReconnectAttemptDelay,
                primaryTransportConnectTimeout: TimeInterval = .defaultTransportState,
                publisherTransportConnectTimeout: TimeInterval = .defaultTransportState,
                iceServers: [IceServer] = [],
                iceTransportPolicy: IceTransportPolicy = .all,
                protocolVersion: ProtocolVersion = .v12)
    {
        self.autoSubscribe = autoSubscribe
        self.reconnectAttempts = reconnectAttempts
        self.reconnectAttemptDelay = reconnectAttemptDelay
        self.primaryTransportConnectTimeout = primaryTransportConnectTimeout
        self.publisherTransportConnectTimeout = publisherTransportConnectTimeout
        self.iceServers = iceServers
        self.iceTransportPolicy = iceTransportPolicy
        self.protocolVersion = protocolVersion
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return autoSubscribe == other.autoSubscribe &&
            reconnectAttempts == other.reconnectAttempts &&
            reconnectAttemptDelay == other.reconnectAttemptDelay &&
            primaryTransportConnectTimeout == other.primaryTransportConnectTimeout &&
            publisherTransportConnectTimeout == other.publisherTransportConnectTimeout &&
            iceServers == other.iceServers &&
            iceTransportPolicy == other.iceTransportPolicy &&
            protocolVersion == other.protocolVersion
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(autoSubscribe)
        hasher.combine(reconnectAttempts)
        hasher.combine(reconnectAttemptDelay)
        hasher.combine(primaryTransportConnectTimeout)
        hasher.combine(publisherTransportConnectTimeout)
        hasher.combine(iceServers)
        hasher.combine(iceTransportPolicy)
        hasher.combine(protocolVersion)
        return hasher.finalize()
    }
}
