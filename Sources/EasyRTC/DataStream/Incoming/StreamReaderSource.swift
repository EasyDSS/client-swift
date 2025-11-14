/* -- */

import Foundation

/// Upstream asynchronous sequence from which raw chunk data is read.
typealias StreamReaderSource = AsyncThrowingStream<Data, any Error>
