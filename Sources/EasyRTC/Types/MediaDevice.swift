import Foundation

@objc
public protocol MediaDevice: AnyObject {
    var deviceId: String { get }
    var name: String { get }
}
