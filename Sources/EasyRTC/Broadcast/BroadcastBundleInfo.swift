/* -- */

#if os(iOS)

import Foundation

enum BroadcastBundleInfo {
    /// Identifier of the app group shared by the primary app and broadcast extension.
    static var groupIdentifier: String? {
        if let override = groupIdentifierOverride { return override }
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
        let appBundleIdentifier = bundleIdentifier.dropSuffix(".\(extensionSuffix)") ?? bundleIdentifier
        return "group.\(appBundleIdentifier)"
    }

    /// Bundle identifier of the broadcast extension.
    static var screenSharingExtension: String? {
        if let override = screenSharingExtensionOverride { return override }
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
        return "\(bundleIdentifier).\(extensionSuffix)"
    }

    /// Path to the socket file used for interprocess communication.
    static var socketPath: SocketPath? {
        guard let groupIdentifier else { return nil }
        return Self.socketPath(for: groupIdentifier)
    }

    /// Whether or not a broadcast extension has been configured.
    static var hasExtension: Bool {
        socketPath != nil && screenSharingExtension != nil
    }

    private static var groupIdentifierOverride: String? {
        Bundle.main.infoDictionary?["RTCAppGroupIdentifier"] as? String
    }

    private static var screenSharingExtensionOverride: String? {
        Bundle.main.infoDictionary?["RTCScreenSharingExtension"] as? String
    }

    private static let extensionSuffix = "broadcast"
    private static let socketFileDescriptor = "rtc_SSFD"

    private static func socketPath(for groupIdentifier: String) -> SocketPath? {
        guard let sharedContainer = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
        else { return nil }
        let path = sharedContainer.appendingPathComponent(Self.socketFileDescriptor).path
        return SocketPath(path)
    }
}

private extension String {
    func dropSuffix(_ suffix: String) -> Self? {
        guard hasSuffix(suffix) else { return nil }
        let trailingIndex = index(endIndex, offsetBy: -suffix.count)
        return String(self[..<trailingIndex])
    }
}

#endif
