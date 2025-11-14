/* -- */

import Foundation

internal import LiveKitWebRTC

// MARK: - EncryptedPacket

extension Livekit_EncryptedPacket {
    init(rtcPacket: LKRTCEncryptedPacket) {
        encryptionType = .gcm
        iv = rtcPacket.iv
        keyIndex = rtcPacket.keyIndex
        encryptedValue = rtcPacket.data
    }

    func toRTCEncryptedPacket() -> LKRTCEncryptedPacket {
        LKRTCEncryptedPacket(
            data: encryptedValue,
            iv: iv,
            keyIndex: keyIndex
        )
    }
}

// MARK: - EncryptedPacketPayload

extension Livekit_EncryptedPacketPayload {
    init?(dataPacket: Livekit_DataPacket) {
        switch dataPacket.value {
        case let .user(user):
            self.user = user
        case let .chatMessage(chatMessage):
            self.chatMessage = chatMessage
        case let .rpcRequest(rpcRequest):
            self.rpcRequest = rpcRequest
        case let .rpcAck(rpcAck):
            self.rpcAck = rpcAck
        case let .rpcResponse(rpcResponse):
            self.rpcResponse = rpcResponse
        case let .streamHeader(streamHeader):
            self.streamHeader = streamHeader
        case let .streamChunk(streamChunk):
            self.streamChunk = streamChunk
        case let .streamTrailer(streamTrailer):
            self.streamTrailer = streamTrailer
        default:
            return nil
        }
    }

    func applyTo(_ dataPacket: inout Livekit_DataPacket) {
        switch value {
        case let .user(userPacket):
            dataPacket.user = userPacket
        case let .chatMessage(chatMessage):
            dataPacket.chatMessage = chatMessage
        case let .rpcRequest(rpcRequest):
            dataPacket.rpcRequest = rpcRequest
        case let .rpcAck(rpcAck):
            dataPacket.rpcAck = rpcAck
        case let .rpcResponse(rpcResponse):
            dataPacket.rpcResponse = rpcResponse
        case let .streamHeader(streamHeader):
            dataPacket.streamHeader = streamHeader
        case let .streamChunk(streamChunk):
            dataPacket.streamChunk = streamChunk
        case let .streamTrailer(streamTrailer):
            dataPacket.streamTrailer = streamTrailer
        case .none:
            break
        }
    }
}

// MARK: - DataPacket

extension Livekit_DataPacket {
    // Skip the default value returned from protobufs
    var encryptedPacketOrNil: Livekit_EncryptedPacket? {
        switch value {
        case .encryptedPacket: encryptedPacket
        default: nil
        }
    }
}
