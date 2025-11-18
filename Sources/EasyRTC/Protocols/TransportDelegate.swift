#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

protocol TransportDelegate: AnyObject {
    func transport(_ transport: Transport, didUpdateState state: RTCPeerConnectionState)
    func transport(_ transport: Transport, didGenerateIceCandidate iceCandidate: IceCandidate)
    func transport(_ transport: Transport, didOpenDataChannel dataChannel: LKRTCDataChannel)
    func transport(_ transport: Transport, didAddTrack track: LKRTCMediaStreamTrack, rtpReceiver: LKRTCRtpReceiver, streams: [LKRTCMediaStream])
    func transport(_ transport: Transport, didRemoveTrack track: LKRTCMediaStreamTrack)
    func transportShouldNegotiate(_ transport: Transport)
}
