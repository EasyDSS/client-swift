import Foundation

struct ParseStreamIdResult {
    let participantSid: Participant.Sid
    let streamId: String?
    let trackId: Track.Sid?
}

func parse(streamId: String) -> ParseStreamIdResult {
    let parts = streamId.split(separator: "|")
    if parts.count >= 2 {
        let p1String = String(parts[1])
        let p1IsTrackId = p1String.starts(with: "TR_")
        return ParseStreamIdResult(participantSid: Participant.Sid(from: String(parts[0])),
                                   streamId: p1IsTrackId ? nil : p1String,
                                   trackId: p1IsTrackId ? Track.Sid(from: p1String) : nil)
    }
    return ParseStreamIdResult(participantSid: Participant.Sid(from: streamId),
                               streamId: nil,
                               trackId: nil)
}

extension Bool {
    func toString() -> String {
        self ? "true" : "false"
    }
}

public extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
