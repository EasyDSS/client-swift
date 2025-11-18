import Foundation

// Simple ring-buffer used for internal audio processing. Not thread-safe.
class RingBuffer<T: Numeric> {
    private var _isFull = false
    private var _buffer: [T]
    private var _head: Int = 0

    init(size: Int) {
        _buffer = [T](repeating: 0, count: size)
    }

    func write(_ value: T) {
        _buffer[_head] = value
        _head = (_head + 1) % _buffer.count
        if _head == 0 { _isFull = true }
    }

    func write(_ sequence: [T]) {
        for value in sequence {
            write(value)
        }
    }

    func read() -> [T]? {
        guard _isFull else { return nil }

        if _head == 0 {
            return _buffer // Return the entire buffer if _head is at the start
        } else {
            // Return the buffer in the correct order
            return Array(_buffer[_head ..< _buffer.count] + _buffer[0 ..< _head])
        }
    }
}
