/* -- */

import Foundation

// Internal only
@MainActor
protocol Mirrorable {
    func set(isMirrored: Bool)
}
