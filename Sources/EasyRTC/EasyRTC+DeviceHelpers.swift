/* -- */

import AVFoundation

public extension EasyRTCSDK {
    /// Helper method to ensure authorization for video(camera) / audio(microphone) permissions in a single call.
    static func ensureDeviceAccess(for types: Set<AVMediaType>) async -> Bool {
        for type in types {
            if ![.video, .audio].contains(type) {
                log("types must be .video or .audio", .error)
            }

            let status = AVCaptureDevice.authorizationStatus(for: type)
            switch status {
            case .notDetermined:
                if await !(AVCaptureDevice.requestAccess(for: type)) {
                    return false
                }
            case .restricted, .denied: return false
            case .authorized: continue // No action needed for authorized status.
            @unknown default:
                log("Unknown AVAuthorizationStatus", .error)
                return false
            }
        }

        return true
    }

    /// Blocking version of ensureDeviceAccess that uses DispatchGroup to wait for permissions.
    static func ensureDeviceAccessSync(for types: Set<AVMediaType>) -> Bool {
        let group = DispatchGroup()
        var result = true

        for type in types {
            if ![.video, .audio].contains(type) {
                log("types must be .video or .audio", .error)
            }

            let status = AVCaptureDevice.authorizationStatus(for: type)
            switch status {
            case .notDetermined:
                group.enter()
                AVCaptureDevice.requestAccess(for: type) { granted in
                    if !granted {
                        result = false
                    }
                    group.leave()
                }
            case .restricted, .denied:
                return false
            case .authorized:
                continue // No action needed for authorized status
            @unknown default:
                log("Unknown AVAuthorizationStatus", .error)
                return false
            }
        }

        // Wait for all permission requests to complete
        group.wait()

        return result
    }
}
