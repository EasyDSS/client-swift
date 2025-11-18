import Foundation

@objc
public protocol VideoCaptureOptions: CaptureOptions {
    var dimensions: Dimensions { get }
    var fps: Int { get }
}
