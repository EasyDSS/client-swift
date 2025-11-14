/* -- */

import Foundation

internal import LiveKitWebRTC

@objc
public class AudioDevice: NSObject, MediaDevice {
    public var deviceId: String { _ioDevice.deviceId }
    public var name: String { _ioDevice.name }
    public var isDefault: Bool { _ioDevice.isDefault }

    let _ioDevice: LKRTCIODevice

    init(ioDevice: LKRTCIODevice) {
        _ioDevice = ioDevice
    }
}

extension AudioDevice: Identifiable {
    public var id: String { deviceId }
}
