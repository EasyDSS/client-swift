import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

@objc
protocol AppStateDelegate: AnyObject {
    func appDidEnterBackground()
    func appWillEnterForeground()
    func appWillTerminate()
    /// Only for macOS.
    func appWillSleep()
    /// Only for macOS.
    func appDidWake()
}

class AppStateListener: Loggable {
    static let shared = AppStateListener()

    private let _queue = OperationQueue()
    let delegates = MulticastDelegate<AppStateDelegate>(label: "AppStateDelegate")

    private init() {
        let defaultCenter = NotificationCenter.default

        #if os(iOS) || os(visionOS) || os(tvOS)
        defaultCenter.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                  object: nil,
                                  queue: _queue)
        { _ in
            self.log("UIApplication.didEnterBackground")
            self.delegates.notify { $0.appDidEnterBackground() }
        }

        defaultCenter.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                  object: nil,
                                  queue: _queue)
        { _ in
            self.log("UIApplication.willEnterForeground")
            self.delegates.notify { $0.appWillEnterForeground() }
        }

        defaultCenter.addObserver(forName: UIApplication.willTerminateNotification,
                                  object: nil,
                                  queue: _queue)
        { _ in
            self.log("UIApplication.willTerminate")
            self.delegates.notify { $0.appWillTerminate() }
        }
        #elseif os(macOS)
        let workspaceCenter = NSWorkspace.shared.notificationCenter

        workspaceCenter.addObserver(forName: NSWorkspace.willSleepNotification,
                                    object: nil,
                                    queue: _queue)
        { _ in
            self.log("NSWorkspace.willSleepNotification")
            self.delegates.notify { $0.appWillSleep() }
        }

        workspaceCenter.addObserver(forName: NSWorkspace.didWakeNotification,
                                    object: nil,
                                    queue: _queue)
        { _ in
            self.log("NSWorkspace.didWakeNotification")
            self.delegates.notify { $0.appDidWake() }
        }
        #endif
    }
}
