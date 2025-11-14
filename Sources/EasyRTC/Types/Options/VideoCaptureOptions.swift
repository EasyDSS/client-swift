/* -- */

import Foundation

@objc
public protocol VideoCaptureOptions: CaptureOptions, Sendable {
    var dimensions: Dimensions { get }
    var fps: Int { get }
}
