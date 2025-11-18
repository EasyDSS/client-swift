import Foundation

@objc
public final class TranscriptionSegment: NSObject, Sendable {
    public let id: String
    public let text: String
    public let language: String
    public let firstReceivedTime: Date
    public let lastReceivedTime: Date
    public let isFinal: Bool

    init(id: String,
         text: String,
         language: String,
         firstReceivedTime: Date,
         lastReceivedTime: Date,
         isFinal: Bool)
    {
        self.id = id
        self.text = text
        self.language = language
        self.firstReceivedTime = firstReceivedTime
        self.lastReceivedTime = lastReceivedTime
        self.isFinal = isFinal
    }

    // MARK: - Equal

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return id == other.id
    }

    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        return hasher.finalize()
    }
}
