/* -- */

import Foundation

@objc
public protocol RemoteTrackProtocol: AnyObject, Sendable {}

public typealias RemoteTrack = RemoteTrackProtocol & Track
