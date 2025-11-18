import Foundation

public struct Stopwatch {
    public struct Entry: Equatable {
        let label: String
        let time: TimeInterval
    }

    public let label: String
    public private(set) var start: TimeInterval
    public private(set) var splits = [Entry]()

    init(label: String) {
        self.label = label
        start = ProcessInfo.processInfo.systemUptime
    }

    mutating func split(label: String = "") {
        splits.append(Entry(label: label, time: ProcessInfo.processInfo.systemUptime))
    }

    public func total() -> TimeInterval {
        guard let last = splits.last else { return 0 }
        return last.time - start
    }
}

extension Stopwatch: Equatable {
    public static func == (lhs: Stopwatch, rhs: Stopwatch) -> Bool {
        lhs.start == rhs.start &&
            lhs.splits == rhs.splits
    }
}

extension Stopwatch: CustomStringConvertible {
    public var description: String {
        var e = [String]()
        var s = start
        for x in splits {
            let diff = x.time - s
            s = x.time
            e.append("\(x.label) +\(diff.rounded(to: 2))s")
        }

        e.append("total \((s - start).rounded(to: 2))s")
        return "Stopwatch(\(label), \(e.joined(separator: ", ")))"
    }
}
