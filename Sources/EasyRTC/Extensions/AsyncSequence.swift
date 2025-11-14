/* -- */

extension AsyncSequence where Element: RangeReplaceableCollection {
    func collect() async throws -> Element {
        try await reduce(Element()) { $0 + $1 }
    }
}
