import Foundation

extension VideoEncoding: Comparable {
    public static func < (lhs: VideoEncoding, rhs: VideoEncoding) -> Bool {
        if lhs.maxBitrate == rhs.maxBitrate {
            return lhs.maxFps < rhs.maxFps
        }

        return lhs.maxBitrate < rhs.maxBitrate
    }
}
