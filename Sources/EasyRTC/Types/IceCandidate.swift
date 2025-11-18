#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

struct IceCandidate: Codable, Sendable {
    let sdp: String
    let sdpMLineIndex: Int32
    let sdpMid: String?

    enum CodingKeys: String, CodingKey {
        case sdpMLineIndex, sdpMid
        case sdp = "candidate"
    }

    func toJsonString() throws -> String {
        let data = try JSONEncoder().encode(self)
        guard let string = String(data: data, encoding: .utf8) else {
            throw LiveKitError(.failedToConvertData, message: "Failed to convert Data to String")
        }
        return string
    }
}

extension LKRTCIceCandidate {
    func toLKType() -> IceCandidate {
        IceCandidate(sdp: sdp, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
    }

    convenience init(fromJsonString string: String) throws {
        // String to Data
        guard let data = string.data(using: .utf8) else {
            throw LiveKitError(.failedToConvertData, message: "Failed to convert String to Data")
        }
        // Decode JSON
        let iceCandidate: IceCandidate = try JSONDecoder().decode(IceCandidate.self, from: data)

        self.init(sdp: iceCandidate.sdp,
                  sdpMLineIndex: iceCandidate.sdpMLineIndex,
                  sdpMid: iceCandidate.sdpMid)
    }
}

extension IceCandidate {
    func toRTCType() -> LKRTCIceCandidate {
        LKRTCIceCandidate(sdp: sdp, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
    }
}
