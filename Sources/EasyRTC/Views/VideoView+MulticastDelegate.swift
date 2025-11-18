import Foundation

extension VideoView: MulticastDelegateProtocol {
    @objc(addDelegate:)
    public func add(delegate: VideoViewDelegate) {
        delegates.add(delegate: delegate)
    }

    @objc(removeDelegate:)
    public func remove(delegate: VideoViewDelegate) {
        delegates.remove(delegate: delegate)
    }

    @objc
    public func removeAllDelegates() {
        delegates.removeAllDelegates()
    }
}
