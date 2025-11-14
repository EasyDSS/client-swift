/* -- */

import Foundation

public extension DispatchQueue {
    // The queue which SDK uses to invoke WebRTC methods
    static let liveKitWebRTC = DispatchQueue(label: "EasyRTC.webRTC", qos: .default)
}
