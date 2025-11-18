import Foundation

extension String {
    /// Simply return nil if String is empty
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
