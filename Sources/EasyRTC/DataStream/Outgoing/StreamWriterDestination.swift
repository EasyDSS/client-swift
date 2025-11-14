/* -- */

import Foundation

protocol StreamWriterDestination: Sendable {
    var isOpen: Bool { get async }
    func write(_ data: some StreamData) async throws
    func close(reason: String?) async throws
}
