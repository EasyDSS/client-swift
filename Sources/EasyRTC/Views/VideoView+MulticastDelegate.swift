/* -- */

import Foundation

extension VideoView: MulticastDelegateProtocol {
    @objc(addDelegate:)
    public nonisolated func add(delegate: VideoViewDelegate) {
        delegates.add(delegate: delegate)
    }

    @objc(removeDelegate:)
    public nonisolated func remove(delegate: VideoViewDelegate) {
        delegates.remove(delegate: delegate)
    }

    @objc
    public nonisolated func removeAllDelegates() {
        delegates.removeAllDelegates()
    }
}
