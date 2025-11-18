import Foundation

extension VideoCapturer: MulticastDelegateProtocol {
    @objc(addDelegate:)
    public func add(delegate: VideoCapturerDelegate) {
        delegates.add(delegate: delegate)
    }

    @objc(removeDelegate:)
    public func remove(delegate: VideoCapturerDelegate) {
        delegates.remove(delegate: delegate)
    }

    @objc
    public func removeAllDelegates() {
        delegates.removeAllDelegates()
    }
}
