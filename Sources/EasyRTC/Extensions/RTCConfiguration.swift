/* -- */

import Foundation

internal import LiveKitWebRTC

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
