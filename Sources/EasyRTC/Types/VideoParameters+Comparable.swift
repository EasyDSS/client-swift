import Foundation

extension VideoParameters: Comparable {
    public static func < (lhs: VideoParameters, rhs: VideoParameters) -> Bool {
        if lhs.dimensions.area == rhs.dimensions.area {
            return lhs.encoding < rhs.encoding
        }

        return lhs.dimensions.area < rhs.dimensions.area
    }
}
