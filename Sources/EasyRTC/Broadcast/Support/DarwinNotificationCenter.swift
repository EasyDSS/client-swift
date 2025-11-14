/* -- */

import Combine
import Foundation

enum DarwinNotification: String {
    case broadcastStarted = "iOS_BroadcastStarted"
    case broadcastStopped = "iOS_BroadcastStopped"
    case broadcastRequestStop = "iOS_BroadcastRequestStop"
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

extension DarwinNotificationCenter {
    /// Returns a publisher that emits events when broadcasting notifications matching the given name.
    func publisher(for name: DarwinNotification) -> Publisher {
        Publisher(notificationCenter, name)
    }

    /// A publisher that emits notifications.
    struct Publisher: Combine.Publisher {
        typealias Output = DarwinNotification
        typealias Failure = Never

        private let name: DarwinNotification
        private let center: CFNotificationCenter?

        fileprivate init(_ center: CFNotificationCenter?, _ name: DarwinNotification) {
            self.name = name
            self.center = center
        }

        func receive<S>(
            subscriber: S
        ) where S: Subscriber, Never == S.Failure, DarwinNotification == S.Input {
            subscriber.receive(subscription: Subscription(subscriber, center, name))
        }
    }

    private class SubscriptionBase {
        let name: DarwinNotification
        let center: CFNotificationCenter?

        init(_ center: CFNotificationCenter?, _ name: DarwinNotification) {
            self.name = name
            self.center = center
        }

        static let callback: CFNotificationCallback = { _, observer, _, _, _ in
            guard let observer else { return }
            Unmanaged<SubscriptionBase>
                .fromOpaque(observer)
                .takeUnretainedValue()
                .notifySubscriber()
        }

        func notifySubscriber() {
            // Overridden by generic subclass to call specific subscriber's
            // receive method. This allows forming a C function pointer to the callback.
        }
    }

    private class Subscription<S: Subscriber>: SubscriptionBase, Combine.Subscription where S.Input == DarwinNotification, S.Failure == Never {
        private var subscriber: S?

        init(_ subscriber: S, _ center: CFNotificationCenter?, _ name: DarwinNotification) {
            self.subscriber = subscriber
            super.init(center, name)
            addObserver()
        }

        func request(_: Subscribers.Demand) {}

        private var opaqueSelf: UnsafeRawPointer {
            UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        }

        private func addObserver() {
            CFNotificationCenterAddObserver(center,
                                            opaqueSelf,
                                            Self.callback,
                                            name.rawValue as CFString,
                                            nil,
                                            .deliverImmediately)
        }

        private func removeObserver() {
            guard subscriber != nil else { return }
            CFNotificationCenterRemoveObserver(center,
                                               opaqueSelf,
                                               CFNotificationName(name.rawValue as CFString),
                                               nil)
            subscriber = nil
        }

        override func notifySubscriber() {
            _ = subscriber?.receive(name)
        }

        func cancel() {
            removeObserver()
        }

        deinit {
            removeObserver()
        }
    }
}
