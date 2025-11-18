import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

protocol SignalClientDelegate: AnyObject {
    func signalClient(_ signalClient: SignalClient, didUpdateConnectionState newState: ConnectionState, oldState: ConnectionState, disconnectError: LiveKitError?) async
    func signalClient(_ signalClient: SignalClient, didReceiveConnectResponse connectResponse: SignalClient.ConnectResponse) async
    func signalClient(_ signalClient: SignalClient, didReceiveAnswer answer: LKRTCSessionDescription) async
    func signalClient(_ signalClient: SignalClient, didReceiveOffer offer: LKRTCSessionDescription) async
    func signalClient(_ signalClient: SignalClient, didReceiveIceCandidate iceCandidate: IceCandidate, target: Livekit_SignalTarget) async
    func signalClient(_ signalClient: SignalClient, didUnpublishLocalTrack localTrack: Livekit_TrackUnpublishedResponse) async
    func signalClient(_ signalClient: SignalClient, didUpdateParticipants participants: [Livekit_ParticipantInfo]) async
    func signalClient(_ signalClient: SignalClient, didUpdateRoom room: Livekit_Room) async
    func signalClient(_ signalClient: SignalClient, didUpdateSpeakers speakers: [Livekit_SpeakerInfo]) async
    func signalClient(_ signalClient: SignalClient, didUpdateConnectionQuality connectionQuality: [Livekit_ConnectionQualityInfo]) async
    func signalClient(_ signalClient: SignalClient, didUpdateRemoteMute trackSid: Track.Sid, muted: Bool) async
    func signalClient(_ signalClient: SignalClient, didUpdateTrackStreamStates streamStates: [Livekit_StreamStateInfo]) async
    func signalClient(_ signalClient: SignalClient, didUpdateSubscribedCodecs codecs: [Livekit_SubscribedCodec], qualities: [Livekit_SubscribedQuality], forTrackSid sid: String) async
    func signalClient(_ signalClient: SignalClient, didUpdateSubscriptionPermission permission: Livekit_SubscriptionPermissionUpdate) async
    func signalClient(_ signalClient: SignalClient, didUpdateToken token: String) async
    func signalClient(_ signalClient: SignalClient, didReceiveLeave canReconnect: Bool, reason: Livekit_DisconnectReason) async
    func signalClient(_ signalClient: SignalClient, didSubscribeTrack trackSid: Track.Sid) async
}
