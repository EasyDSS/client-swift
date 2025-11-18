import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

// MARK: - Internal delegate

protocol DataChannelDelegate {
    func dataChannel(_ dataChannelPair: DataChannelPair, didReceiveDataPacket dataPacket: Livekit_DataPacket)
}

class DataChannelPair: NSObject, Loggable {
    // MARK: - Public

    let delegates = MulticastDelegate<DataChannelDelegate>(label: "DataChannelDelegate")

    let openCompleter = AsyncCompleter<Void>(label: "Data channel open", defaultTimeout: .defaultPublisherDataChannelOpen)

    var isOpen: Bool { _state.isOpen }

    // MARK: - Private

    private struct State {
        var lossy: LKRTCDataChannel?
        var reliable: LKRTCDataChannel?

        var isOpen: Bool {
            guard let lossy, let reliable else { return false }
            return reliable.readyState == .open && lossy.readyState == .open
        }
    }

    private let _state: StateSync<State>

    init(delegate: DataChannelDelegate? = nil,
         lossyChannel: LKRTCDataChannel? = nil,
         reliableChannel: LKRTCDataChannel? = nil)
    {
        _state = StateSync(State(lossy: lossyChannel,
                                 reliable: reliableChannel))

        if let delegate {
            delegates.add(delegate: delegate)
        }
    }

    func set(reliable channel: LKRTCDataChannel?) {
        let isOpen = _state.mutate {
            $0.reliable = channel
            return $0.isOpen
        }

        channel?.delegate = self

        if isOpen {
            openCompleter.resume(returning: ())
        }
    }

    func set(lossy channel: LKRTCDataChannel?) {
        let isOpen = _state.mutate {
            $0.lossy = channel
            return $0.isOpen
        }

        channel?.delegate = self

        if isOpen {
            openCompleter.resume(returning: ())
        }
    }

    func reset() {
        let (lossy, reliable) = _state.mutate {
            let result = ($0.lossy, $0.reliable)
            $0.reliable = nil
            $0.lossy = nil
            return result
        }

        lossy?.close()
        reliable?.close()

        openCompleter.reset()
    }

    func send(userPacket: Livekit_UserPacket, kind: Livekit_DataPacket.Kind) throws {
        guard isOpen else {
            throw LiveKitError(.invalidState, message: "Data channel is not open")
        }

        let packet = Livekit_DataPacket.with {
            $0.kind = kind
            $0.user = userPacket
        }

        let serializedData = try packet.serializedData()
        let rtcData = RTC.createDataBuffer(data: serializedData)

        let channel = _state.read { kind == .reliable ? $0.reliable : $0.lossy }
        guard let sendDataResult = channel?.sendData(rtcData), sendDataResult else {
            throw LiveKitError(.invalidState, message: "sendData failed")
        }
    }

    func infos() -> [Livekit_DataChannelInfo] {
        _state.read { [$0.lossy, $0.reliable] }
            .compactMap { $0 }
            .map { $0.toLKInfoType() }
    }
}

// MARK: - RTCDataChannelDelegate

extension DataChannelPair: LKRTCDataChannelDelegate {
    func dataChannelDidChangeState(_: LKRTCDataChannel) {
        if isOpen {
            openCompleter.resume(returning: ())
        }
    }

    func dataChannel(_: LKRTCDataChannel, didReceiveMessageWith buffer: LKRTCDataBuffer) {
        guard let dataPacket = try? Livekit_DataPacket(serializedData: buffer.data) else {
            log("Could not decode data message", .error)
            return
        }

        delegates.notify {
            $0.dataChannel(self, didReceiveDataPacket: dataPacket)
        }
    }
}
