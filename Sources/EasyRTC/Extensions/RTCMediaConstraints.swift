/* -- */

import Foundation

internal import LiveKitWebRTC

extension LKRTCMediaConstraints {
    static let defaultPCConstraints = LKRTCMediaConstraints(
        mandatoryConstraints: nil,
        optionalConstraints: ["DtlsSrtpKeyAgreement": kLKRTCMediaConstraintsValueTrue]
    )
}
