import Foundation

/// Helper class to observer ``TrackDelegate`` from Swift UI.
public class TrackDelegateObserver: ObservableObject, TrackDelegate {
    private let track: Track

    @Published public var dimensions: Dimensions?
    @Published public var statistics: TrackStatistics?
    @Published public var simulcastStatistics: [VideoCodec: TrackStatistics]

    public var allStatisticts: [TrackStatistics] {
        var result: [TrackStatistics] = []
        if let statistics {
            result.append(statistics)
        }
        result.append(contentsOf: simulcastStatistics.values)
        return result
    }

    public init(track: Track) {
        self.track = track

        dimensions = track.dimensions
        statistics = track.statistics
        simulcastStatistics = track.simulcastStatistics

        track.add(delegate: self)
    }

    // MARK: - TrackDelegate

    public func track(_: VideoTrack, didUpdateDimensions dimensions: Dimensions?) {
        Task.detached { @MainActor in
            self.dimensions = dimensions
        }
    }

    public func track(_: Track, didUpdateStatistics statistics: TrackStatistics, simulcastStatistics: [VideoCodec: TrackStatistics]) {
        Task.detached { @MainActor in
            self.statistics = statistics
            self.simulcastStatistics = simulcastStatistics
        }
    }
}
