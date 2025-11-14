/* -- */

import Foundation

public protocol NextInvokable {
    associatedtype Next
    var next: Next? { get set }
}
