import Foundation

// Identify by sid

extension TrackPublication: Identifiable {
    public typealias ID = Track.Sid

    public var id: Track.Sid {
        _state.sid
    }
}
