import Foundation

// Identify by sid

extension Participant: Identifiable {
    public var id: String {
        "\(type(of: self))-\(sid?.stringValue ?? String(hash))"
    }
}
