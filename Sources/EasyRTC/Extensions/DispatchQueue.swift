import Foundation

public extension DispatchQueue {
    // The queue which SDK uses to invoke WebRTC methods
    static let liveKitWebRTC = DispatchQueue(label: "EasyRTCSwift.webRTC", qos: .default)
}
