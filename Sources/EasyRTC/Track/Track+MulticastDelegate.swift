import Foundation

extension Track: MulticastDelegateProtocol {
    @objc(addDelegate:)
    public func add(delegate: TrackDelegate) {
        delegates.add(delegate: delegate)
    }

    @objc(removeDelegate:)
    public func remove(delegate: TrackDelegate) {
        delegates.remove(delegate: delegate)
    }

    @objc
    public func removeAllDelegates() {
        delegates.removeAllDelegates()
    }
}
