import Foundation

extension AudioEncoding: Comparable {
    public static func < (lhs: AudioEncoding, rhs: AudioEncoding) -> Bool {
        lhs.maxBitrate < rhs.maxBitrate
    }
}
