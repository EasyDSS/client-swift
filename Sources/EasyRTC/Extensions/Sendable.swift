import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

// Immutable classes.
extension LKRTCMediaConstraints: @unchecked Sendable {}
extension LKRTCSessionDescription: @unchecked Sendable {}
