import Foundation

// Workaround for Swift-ObjC limitation around generics.
public protocol MulticastDelegateProtocol {
    associatedtype Delegate
    func add(delegate: Delegate)
    func remove(delegate: Delegate)
    func removeAllDelegates()
}

/// A class that allows to have multiple delegates instead of one.
///
/// Uses `NSHashTable` internally to maintain a set of weak delegates.
///
public class MulticastDelegate<T>: NSObject, Loggable {
    // MARK: - Public properties

    public var isDelegatesEmpty: Bool { countDelegates == 0 }

    public var isDelegatesNotEmpty: Bool { countDelegates != 0 }

    /// `NSHashTable` may not immediately deinit the un-referenced object, due to Apple's implementation, therefore ``countDelegates`` may be unreliable.
    public var countDelegates: Int {
        _state.read { $0.delegates.allObjects.count }
    }

    public var allDelegates: [T] {
        _state.read { $0.delegates.allObjects.compactMap { $0 as? T } }
    }

    // MARK: - Private properties

    private struct State {
        let delegates = NSHashTable<AnyObject>.weakObjects()
    }

    private let _queue: DispatchQueue

    private let _state = StateSync(State())

    init(label: String, qos: DispatchQoS = .default) {
        _queue = DispatchQueue(label: "EasyRTCSwift.Multicast.\(label)", qos: qos, attributes: [])
    }

    /// Add a single delegate.
    public func add(delegate: T) {
        guard let delegate = delegate as AnyObject? else {
            log("MulticastDelegate: delegate is not an AnyObject")
            return
        }

        _state.mutate { $0.delegates.add(delegate) }
    }

    /// Remove a single delegate.
    ///
    /// In most cases this is not required to be called explicitly since all delegates are weak.
    public func remove(delegate: T) {
        guard let delegate = delegate as AnyObject? else {
            log("MulticastDelegate: delegate is not an AnyObject")
            return
        }

        _state.mutate { $0.delegates.remove(delegate) }
    }

    /// Remove all delegates.
    public func removeAllDelegates() {
        _state.mutate { $0.delegates.removeAllObjects() }
    }

    /// Notify delegates inside the queue.
    func notify(label _: (() -> String)? = nil, _ fnc: @escaping (T) -> Void) {
        let delegates = _state.read { $0.delegates.allObjects.compactMap { $0 as? T } }

        _queue.async {
            for delegate in delegates {
                fnc(delegate)
            }
        }
    }

    /// Awaitable version of notify
    func notifyAsync(_ fnc: @escaping (T) -> Void) async {
        // Read a copy of delegates
        let delegates = _state.read { $0.delegates.allObjects.compactMap { $0 as? T } }

        // Convert to async
        await withCheckedContinuation { continuation in
            _queue.async {
                for delegate in delegates {
                    fnc(delegate)
                }
                continuation.resume()
            }
        }
    }
}
