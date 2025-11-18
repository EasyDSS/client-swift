import Foundation

@objc
public class ParticipantPermissions: NSObject {
    /// ``Participant`` can subscribe to tracks in the room
    @objc
    public let canSubscribe: Bool

    /// ``Participant`` can publish new tracks to room
    @objc
    public let canPublish: Bool

    /// ``Participant`` can publish data
    @objc
    public let canPublishData: Bool

    /// ``Participant`` is hidden to others
    @objc
    public let hidden: Bool

    /// Indicates it's a recorder instance
    @objc
    public let recorder: Bool

    init(canSubscribe: Bool = false,
         canPublish: Bool = false,
         canPublishData: Bool = false,
         hidden: Bool = false,
         recorder: Bool = false)
    {
        self.canSubscribe = canSubscribe
        self.canPublish = canPublish
        self.canPublishData = canPublishData
        self.hidden = hidden
        self.recorder = recorder
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return canSubscribe == other.canSubscribe &&
            canPublish == other.canPublish &&
            canPublishData == other.canPublishData &&
            hidden == other.hidden &&
            recorder == other.recorder
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(canSubscribe)
        hasher.combine(canPublish)
        hasher.combine(canPublishData)
        hasher.combine(hidden)
        hasher.combine(recorder)
        return hasher.finalize()
    }
}

extension Livekit_ParticipantPermission {
    func toLKType() -> ParticipantPermissions {
        ParticipantPermissions(canSubscribe: canSubscribe,
                               canPublish: canPublish,
                               canPublishData: canPublishData,
                               hidden: hidden,
                               recorder: recorder)
    }
}
