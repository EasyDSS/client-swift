import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

extension LKRTCDataChannel {
    enum labels {
        static let reliable = "_reliable"
        static let lossy = "_lossy"
    }

    func toLKInfoType() -> Livekit_DataChannelInfo {
        Livekit_DataChannelInfo.with {
            $0.id = UInt32(max(0, channelId))
            $0.label = label
        }
    }
}
