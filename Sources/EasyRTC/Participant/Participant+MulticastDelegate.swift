import Foundation

extension Participant: MulticastDelegateProtocol {
    @objc(addDelegate:)
    public func add(delegate: ParticipantDelegate) {
        delegates.add(delegate: delegate)
    }

    @objc(removeDelegate:)
    public func remove(delegate: ParticipantDelegate) {
        delegates.remove(delegate: delegate)
    }

    @objc
    public func removeAllDelegates() {
        delegates.removeAllDelegates()
    }
}
