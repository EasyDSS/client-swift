/* -- */

import Foundation

protocol StreamData: Sendable {
    func chunks(of size: Int) -> [Data]
}

extension Data: StreamData {
    func chunks(of size: Int) -> [Data] {
        guard size > 0, !isEmpty else { return [] }
        return stride(from: startIndex, to: endIndex, by: size).map {
            let end = index($0, offsetBy: size, limitedBy: endIndex) ?? endIndex
            return self[$0 ..< end]
        }
    }
}

extension String: StreamData {
    /// Chunk along valid UTF-8 bounderies.
    ///
    /// Uses the same algorithm as in the LiveKit JS SDK.
    ///
    func chunks(of size: Int) -> [Data] {
        guard size > 0, !isEmpty else { return [] }

        var chunks: [Data] = []
        var encoded = Data(utf8)[...]

        while encoded.count > size {
            var k = size
            while k > 0 {
                guard encoded.indices.contains(k),
                      encoded[k] & 0xC0 == 0x80 else { break }
                k -= 1
            }
            chunks.append(encoded.subdata(in: 0 ..< k))
            encoded = encoded.subdata(in: k ..< encoded.count)
        }
        if !encoded.isEmpty {
            chunks.append(encoded)
        }
        return chunks
    }
}
