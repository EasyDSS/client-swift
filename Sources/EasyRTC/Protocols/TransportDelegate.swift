/* -- */

internal import LiveKitWebRTC

protocol TransportDelegate: AnyObject, Sendable {
    func transport(_ transport: Transport, didUpdateState state: LKRTCPeerConnectionState)
    func transport(_ transport: Transport, didGenerateIceCandidate iceCandidate: IceCandidate)
    func transport(_ transport: Transport, didOpenDataChannel dataChannel: LKRTCDataChannel)
    func transport(_ transport: Transport, didAddTrack track: LKRTCMediaStreamTrack, rtpReceiver: LKRTCRtpReceiver, streams: [LKRTCMediaStream])
    func transport(_ transport: Transport, didRemoveTrack track: LKRTCMediaStreamTrack)
    func transportShouldNegotiate(_ transport: Transport)
}
