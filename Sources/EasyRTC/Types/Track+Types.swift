import Foundation

public extension Track {
    @objc(TrackSid)
    final class Sid: NSObject, Codable, Sendable {
        @objc
        public let stringValue: String

        init(from stringValue: String) {
            self.stringValue = stringValue
        }

        override public func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? Self else { return false }
            return stringValue == other.stringValue
        }

        override public var hash: Int {
            var hasher = Hasher()
            stringValue.hash(into: &hasher)
            return hasher.finalize()
        }

        override public var description: String {
            stringValue
        }
    }
}
