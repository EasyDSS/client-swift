/* -- */

import Foundation

/// A token source that queries LiveKit's sandbox token server for development and testing.
///
/// This token source connects to LiveKit Cloud's sandbox environment, which is perfect for
/// quick prototyping and getting started with LiveKit development.
///
/// - Warning: This token source is **insecure** and should **never** be used in production.
/// - Note: For production use, implement ``EndpointTokenSource`` or your own ``TokenSourceConfigurable``.
public struct SandboxTokenSource: EndpointTokenSource {
    public let url = URL(string: "https://cloud-api.livekit.io/api/v2/sandbox/connection-details")!
    public var headers: [String: String] {
        ["X-Sandbox-ID": id]
    }

    /// The sandbox ID provided by LiveKit Cloud for authentication.
    public let id: String

    /// Initialize with a sandbox ID from LiveKit Cloud.
    ///
    /// - Parameter id: The sandbox ID obtained from your LiveKit Cloud project
    public init(id: String) {
        self.id = id.trimmingCharacters(in: .alphanumerics.inverted)
    }
}
