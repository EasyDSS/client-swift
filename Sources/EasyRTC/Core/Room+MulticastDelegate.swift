import Foundation

extension Room: MulticastDelegateProtocol {
    @objc(addDelegate:)
    public func add(delegate: RoomDelegate) {
        delegates.add(delegate: delegate)
    }

    @objc(removeDelegate:)
    public func remove(delegate: RoomDelegate) {
        delegates.remove(delegate: delegate)
    }

    @objc
    public func removeAllDelegates() {
        delegates.removeAllDelegates()
    }
}
