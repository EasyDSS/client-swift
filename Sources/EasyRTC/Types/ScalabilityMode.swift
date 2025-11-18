import Foundation

@objc
public enum ScalabilityMode: Int {
    case L3T3 = 1
    case L3T3_KEY = 2
    case L3T3_KEY_SHIFT = 3
}

public extension ScalabilityMode {
    static func fromString(_ rawString: String?) -> ScalabilityMode? {
        switch rawString {
        case "L3T3": return .L3T3
        case "L3T3_KEY": return .L3T3_KEY
        case "L3T3_KEY_SHIFT": return .L3T3_KEY_SHIFT
        default: return nil
        }
    }

    var rawStringValue: String {
        switch self {
        case .L3T3: return "L3T3"
        case .L3T3_KEY: return "L3T3_KEY"
        case .L3T3_KEY_SHIFT: return "L3T3_KEY_SHIFT"
        }
    }

    var spatial: Int { 3 }

    var temporal: Int { 3 }
}

// MARK: - CustomStringConvertible

extension ScalabilityMode: CustomStringConvertible {
    public var description: String {
        "ScalabilityMode(\(rawStringValue))"
    }
}
