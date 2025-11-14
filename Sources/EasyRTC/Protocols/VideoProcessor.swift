/* -- */

import Foundation

@objc
public protocol VideoProcessor {
    func process(frame: VideoFrame) -> VideoFrame?
}
