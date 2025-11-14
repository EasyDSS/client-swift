/* -- */

import Foundation

internal import LiveKitWebRTC

/// Options used when establishing a connection.
@objc
public final class IceServer: NSObject, Sendable {
    public let urls: [String]
    public let username: String?
    public let credential: String?

    public init(urls: [String],
                username: String?,
                credential: String?)
    {
        self.urls = urls
        self.username = username
        self.credential = credential
    }
}

extension IceServer {
    func toRTCType() -> LKRTCIceServer {
        DispatchQueue.liveKitWebRTC.sync { LKRTCIceServer(urlStrings: urls,
                                                          username: username,
                                                          credential: credential) }
    }
}

extension Livekit_ICEServer {
    func toRTCType() -> LKRTCIceServer {
        let rtcUsername = !username.isEmpty ? username : nil
        let rtcCredential = !credential.isEmpty ? credential : nil
        return DispatchQueue.liveKitWebRTC.sync { LKRTCIceServer(urlStrings: urls,
                                                                 username: rtcUsername,
                                                                 credential: rtcCredential) }
    }
}
