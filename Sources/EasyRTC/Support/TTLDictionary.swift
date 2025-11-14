/* -- */

import Foundation

final class TTLDictionary<Key: Hashable, Value> {
    private struct Entry {
        let value: Value
        let expiresAt: TimeInterval
    }

    private var storage: [Key: Entry] = [:]
    private let ttl: TimeInterval
    private var lastCleanup: TimeInterval = 0

    init(ttl: TimeInterval) {
        self.ttl = ttl
    }

    private func _cleanup() {
        let now = Date().timeIntervalSince1970
        storage = storage.filter { _, entry in
            entry.expiresAt >= now
        }
        lastCleanup = now
    }

    subscript(key: Key) -> Value? {
        get {
            get(key)
        }
        set {
            set(key, newValue)
        }
    }

    private func get(_ key: Key) -> Value? {
        guard let entry = storage[key] else { return nil }

        let now = Date().timeIntervalSince1970
        if entry.expiresAt < now {
            storage[key] = nil
            return nil
        }

        return entry.value
    }

    private func set(_ key: Key, _ value: Value?) {
        let now = Date().timeIntervalSince1970

        if now - lastCleanup > ttl / 2 {
            _cleanup()
        }

        if let value {
            let expiresAt = now + ttl
            storage[key] = Entry(value: value, expiresAt: expiresAt)
        } else {
            storage[key] = nil
        }
    }

    func removeAll() {
        storage.removeAll()
        lastCleanup = Date().timeIntervalSince1970
    }

    func forEach(_ callback: (Key, Value) -> Void) {
        _cleanup()

        for (key, entry) in storage {
            callback(key, entry.value)
        }
    }

    func map<T>(_ transform: (Key, Value) -> T) -> [T] {
        _cleanup()
        var result: [T] = []

        for (key, entry) in storage {
            result.append(transform(key, entry.value))
        }

        return result
    }

    var count: Int {
        _cleanup()
        return storage.count
    }

    var keys: [Key] {
        _cleanup()
        return Array(storage.keys)
    }

    var values: [Value] {
        _cleanup()
        return storage.map { _, entry in entry.value }
    }
}
