/* -- */

import Foundation

internal import LiveKitWebRTC

// MARK: Immutable classes

extension LKRTCDataBuffer: @unchecked Swift.Sendable {}
extension LKRTCDataChannel: @unchecked Swift.Sendable {}
extension LKRTCFrameCryptorKeyProvider: @unchecked Swift.Sendable {}
extension LKRTCIceCandidate: @unchecked Swift.Sendable {}
extension LKRTCMediaConstraints: @unchecked Swift.Sendable {}
extension LKRTCMediaStream: @unchecked Swift.Sendable {}
extension LKRTCMediaStreamTrack: @unchecked Swift.Sendable {}
extension LKRTCPeerConnection: @unchecked Swift.Sendable {}
extension LKRTCPeerConnectionFactory: @unchecked Swift.Sendable {}
extension LKRTCRtpReceiver: @unchecked Swift.Sendable {}
extension LKRTCRtpSender: @unchecked Swift.Sendable {}
extension LKRTCRtpTransceiver: @unchecked Swift.Sendable {}
extension LKRTCRtpTransceiverInit: @unchecked Swift.Sendable {}
extension LKRTCSessionDescription: @unchecked Swift.Sendable {}
extension LKRTCStatisticsReport: @unchecked Swift.Sendable {}
extension LKRTCVideoCodecInfo: @unchecked Swift.Sendable {}
extension LKRTCVideoFrame: @unchecked Swift.Sendable {}
extension LKRTCRtpCapabilities: @unchecked Swift.Sendable {}

// MARK: Mutable classes - to be validated

extension LKRTCConfiguration: @unchecked Swift.Sendable {}
extension LKRTCVideoCapturer: @unchecked Swift.Sendable {}
extension LKRTCDefaultAudioProcessingModule: @unchecked Swift.Sendable {}
extension LKRTCCallbackLogger: @unchecked Swift.Sendable {}

// MARK: Collections

extension NSHashTable: @unchecked Swift.Sendable {} // cannot specify Obj-C generics
extension NSMapTable: @unchecked Swift.Sendable {} // cannot specify Obj-C generics
#if swift(<6.2)
extension Dictionary: Swift.Sendable where Key: Sendable, Value: Sendable {}
#endif

// MARK: AV

extension AVCaptureDevice: @unchecked Swift.Sendable {}
extension AVCaptureDevice.Format: @unchecked Swift.Sendable {}
extension CVPixelBuffer: @unchecked Swift.Sendable {}
