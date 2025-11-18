import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

extension LKRTCConfiguration {
    static func liveKitDefault() -> LKRTCConfiguration {
        let result = DispatchQueue.liveKitWebRTC.sync { LKRTCConfiguration() }
        result.sdpSemantics = .unifiedPlan
        result.continualGatheringPolicy = .gatherContinually
        result.candidateNetworkPolicy = .all
        result.tcpCandidatePolicy = .enabled

        return result
    }
}
