import Foundation

enum DarwinNotification: String {
    case broadcastStarted = "iOS_BroadcastStarted"
    case broadcastStopped = "iOS_BroadcastStopped"
}

final class DarwinNotificationCenter: @unchecked Sendable {
    static let shared = DarwinNotificationCenter()

    private let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()

    func postNotification(_ name: DarwinNotification) {
        CFNotificationCenterPostNotification(notificationCenter,
                                             CFNotificationName(rawValue: name.rawValue as CFString),
                                             nil,
                                             nil,
                                             true)
    }
}
