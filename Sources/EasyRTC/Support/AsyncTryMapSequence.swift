/* -- */

extension AsyncSequence {
    func tryMap<T>(
        _ transform: @escaping (Element) async throws -> T
    ) -> AsyncTryMapSequence<Self, T> {
        AsyncTryMapSequence(base: self, transform: transform)
    }
}

struct AsyncTryMapSequence<Base: AsyncSequence, Element>: AsyncSequence {
    fileprivate let base: Base
    fileprivate let transform: (Base.Element) async throws -> Element

    struct Iterator: AsyncIteratorProtocol {
        var baseIterator: Base.AsyncIterator
        let transform: (Base.Element) async throws -> Element

        mutating func next() async throws -> Element? {
            guard let nextElement = try await baseIterator.next() else {
                return nil
            }
            return try await transform(nextElement)
        }
    }

    func makeAsyncIterator() -> Iterator {
        Iterator(baseIterator: base.makeAsyncIterator(), transform: transform)
    }
}
