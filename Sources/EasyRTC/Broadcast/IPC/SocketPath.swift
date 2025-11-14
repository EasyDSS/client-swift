/* -- */

#if os(iOS)

import Network

/// A UNIX domain path valid on this system.
struct SocketPath: Loggable {
    let path: String

    /// Creates a socket path or returns nil if the given path string is not valid.
    init?(_ path: String) {
        guard Self.isValid(path) else {
            Self.log("Invalid socket path: \(path)", .error)
            return nil
        }
        self.path = path
    }

    /// Whether or not the given socket path is valid on this system.
    ///
    /// Proper path validation is essential; as of writing, the Network framework
    /// does not perform such validation internally, and attempting to connect to a
    /// socket with an invalid path results in a crash.
    ///
    private static func isValid(_ path: String) -> Bool {
        path.utf8.count <= addressMaxLength
    }

    /// The maximum supported length (in bytes) for socket paths on this system.
    private static let addressMaxLength: Int = MemoryLayout.size(ofValue: sockaddr_un().sun_path) - 1
}

extension NWEndpoint {
    init(_ socketPath: SocketPath) {
        self = .unix(path: socketPath.path)
    }
}

#endif
