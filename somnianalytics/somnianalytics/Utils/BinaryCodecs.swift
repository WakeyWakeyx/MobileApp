import Foundation

/// The result of a binary decoding process.
enum DecodeResult<A> {
    /// The decoder successfully decoded a value of type A.
    case Success(value: A)
    /// The decoder couldn't decode the value.
    case Failure(msg: String)
}

/// Protocol representing an encoder of values of type A.
protocol Encoder {
    associatedtype A
    func encode(value: A)
}

/// Protocol representing an decoder of values of type A.
protocol Decoder {
    associatedtype A
    func decode() -> DecodeResult<A>
}

/// Protocol representing both a decoder and encoder of type A.
protocol Codec: Encoder, Decoder {
    override associatedtype A
    override func encode(value: A)
    override func decode() -> DecodeResult<A>
}

/// A Sink is an automatically-resized array of bytes to which binary data can be written to.
// Unless otherwrise specified, numeric values are written in Big Endian order.
protocol Sink {
    /// Writes a single byte into this Sink.
    func writeInt8(value: Int8)
    /// Writes a 16-bit integer into this Sink.
    func writeInt16(value: Int16)
    /// Writes a 32-but integer into this Sink.
    func writeInt32(value: Int32)
    /// Writes a 64-bit integer into this Sink.
    func writeInt64(value: Int64)
}

/// A Source is an array of bytes from which binary data can be read from.
protocol Source {
    /// Reads a single byte of memory as an Int8.
    func readInt8(value: Int8)
    /// Reads a 16-bit integer from this Source.
    func readInt16(value: Int16)
    /// Reads a 32-bit integer from this Source.
    func readInt32(value: Int32)
    /// Reads a 64-bit integer from this Source.
    func readInt64(value: Int64)
}

/// Implementation of the Sink and Source protocols using a resizing byte array.
class Buffer: Sink {
    private var _buffer = [Int8]()
    private var _cursor = 0
    
    private func _reserve(newCount: Int) {
        _buffer.reserveCapacity(_cursor + newCount)
    }
    
    func writeInt8(value: Int8) {
        _reserve(newCount: 1)
        _buffer[_cursor] = value
        _cursor += 1
    }
    
    func writeInt16(value: Int16) {
        _reserve(newCount: 2)
        _buffer[_cursor] = Int8(value >> 8 & 0xFF)
        _buffer[_cursor + 1] = Int8(value & 0xFF)
        _cursor += 2
    }
    
    func writeInt32(value: Int32) {
        _reserve(newCount: 4)
        _buffer[_cursor] = Int8(value >> 24 & 0xFF)
        _buffer[_cursor + 1] = Int8(value >> 16 & 0xFF)
        _buffer[_cursor + 2] = Int8(value >> 8 & 0xFF)
        _buffer[_cursor + 3] = Int8(value & 0xFF)
        _cursor += 4
    }
    
    func writeInt64(value: Int64) {
        _reserve(newCount: 8)
        _buffer[_cursor] = Int8(value >> 56 & 0xFF)
        _buffer[_cursor + 1] = Int8(value >> 48 & 0xFF)
        _buffer[_cursor + 2] = Int8(value >> 40 & 0xFF)
        _buffer[_cursor + 3] = Int8(value >> 32 & 0xFF)
        _buffer[_cursor + 4] = Int8(value >> 24 & 0xFF)
        _buffer[_cursor + 5] = Int8(value >> 16 & 0xFF)
        _buffer[_cursor + 6] = Int8(value >> 8 & 0xFF)
        _buffer[_cursor + 7] = Int8(value & 0xFF)
        _cursor += 8
    }
}
