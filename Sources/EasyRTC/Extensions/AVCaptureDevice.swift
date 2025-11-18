import AVFoundation

public extension AVCaptureDevice {
    /// Helper extension to return the acual direction the camera is facing.
    var facingPosition: AVCaptureDevice.Position {
        #if os(macOS)
        /// In macOS, the Facetime camera's position is .unspecified but this property will return .front for such cases.
        if deviceType == .builtInWideAngleCamera, position == .unspecified {
            return .front
        }
        #elseif os(visionOS)
        /// In visionOS, the Persona camera's position is .unspecified but this property will return .front for such cases.
        if position == .unspecified {
            return .front
        }
        #endif

        return position
    }
}

public extension Collection where Element: AVCaptureDevice {
    /// Helper extension to return only a single suggested device for each position.
    func singleDeviceforEachPosition() -> [AVCaptureDevice] {
        let front = first { $0.facingPosition == .front }
        let back = first { $0.facingPosition == .back }
        return [front, back].compactMap { $0 }
    }
}
