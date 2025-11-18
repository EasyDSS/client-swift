import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

extension LKRTCRtpSender: Loggable {
    // ...
    func _set(subscribedQualities qualities: [Livekit_SubscribedQuality]) {
        let _parameters = parameters
        let encodings = _parameters.encodings

        var didUpdate = false

        // For SVC mode...
        if let firstEncoding = encodings.first,
           let _ = ScalabilityMode.fromString(firstEncoding.scalabilityMode)
        {
            let _enabled = qualities.highest != .off
            if firstEncoding.isActive != _enabled {
                firstEncoding.isActive = _enabled
                didUpdate = true
            }
        } else {
            // For Simulcast...
            for e in qualities {
                guard let rid = e.quality.asRID else { continue }
                guard let encodingforRID = encodings.first(where: { $0.rid == rid }) else { continue }

                if encodingforRID.isActive != e.enabled {
                    didUpdate = true
                    encodingforRID.isActive = e.enabled
                    log("Setting layer \(e.quality) to \(e.enabled)", .info)
                }
            }

            // Non simulcast streams don't have RIDs, handle here.
            if encodings.count == 1, qualities.count >= 1 {
                let firstEncoding = encodings.first!
                let firstQuality = qualities.first!

                if firstEncoding.isActive != firstQuality.enabled {
                    didUpdate = true
                    firstEncoding.isActive = firstQuality.enabled
                    log("Setting layer \(firstQuality.quality) to \(firstQuality.enabled)", .info)
                }
            }
        }

        if didUpdate {
            parameters = _parameters
        }
    }
}
