import Foundation

struct TrackSettings: Equatable, Hashable, Sendable {
    let isEnabled: Bool
    let dimensions: Dimensions
    let videoQuality: VideoQuality
    let preferredFPS: UInt

    init(enabled: Bool = false,
         dimensions: Dimensions = .zero,
         videoQuality: VideoQuality = .low,
         preferredFPS: UInt = 0)
    {
        isEnabled = enabled
        self.dimensions = dimensions
        self.videoQuality = videoQuality
        self.preferredFPS = preferredFPS
    }

    func copyWith(isEnabled: ValueOrAbsent<Bool> = .absent,
                  dimensions: ValueOrAbsent<Dimensions> = .absent,
                  videoQuality: ValueOrAbsent<VideoQuality> = .absent,
                  preferredFPS: ValueOrAbsent<UInt> = .absent) -> TrackSettings
    {
        TrackSettings(enabled: isEnabled.value(ifAbsent: self.isEnabled),
                      dimensions: dimensions.value(ifAbsent: self.dimensions),
                      videoQuality: videoQuality.value(ifAbsent: self.videoQuality),
                      preferredFPS: preferredFPS.value(ifAbsent: self.preferredFPS))
    }
}
