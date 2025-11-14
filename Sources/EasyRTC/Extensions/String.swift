/* -- */

import Foundation

extension String {
    /// Simply return nil if String is empty
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    var byteLength: Int {
        data(using: .utf8)?.count ?? 0
    }

    func truncate(maxBytes: Int) -> String {
        if byteLength <= maxBytes {
            return self
        }

        var low = 0
        var high = count

        while low < high {
            let mid = (low + high + 1) / 2
            let substring = String(prefix(mid))
            if substring.byteLength <= maxBytes {
                low = mid
            } else {
                high = mid - 1
            }
        }

        return String(prefix(low))
    }

    /// The path extension, if any, of the string as interpreted as a path.
    var pathExtension: String? {
        let pathExtension = (self as NSString).pathExtension
        return pathExtension.isEmpty ? nil : pathExtension
    }
}
