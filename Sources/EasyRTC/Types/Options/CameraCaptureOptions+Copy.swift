import AVFoundation

public extension CameraCaptureOptions {
    func copyWith(device: ValueOrAbsent<AVCaptureDevice?> = .absent,
                  position: ValueOrAbsent<AVCaptureDevice.Position> = .absent,
                  preferredFormat: ValueOrAbsent<AVCaptureDevice.Format?> = .absent,
                  dimensions: ValueOrAbsent<Dimensions> = .absent,
                  fps: ValueOrAbsent<Int> = .absent) -> CameraCaptureOptions
    {
        CameraCaptureOptions(device: device.value(ifAbsent: self.device),
                             position: position.value(ifAbsent: self.position),
                             preferredFormat: preferredFormat.value(ifAbsent: self.preferredFormat),
                             dimensions: dimensions.value(ifAbsent: self.dimensions),
                             fps: fps.value(ifAbsent: self.fps))
    }
}
