/* -- */

public enum StreamError: Error, Equatable {
    /// Unable to open a stream with the same ID more than once.
    case alreadyOpened

    /// Stream closed abnormally by remote participant.
    case abnormalEnd(reason: String)

    /// Incoming chunk data could not be decoded.
    case decodeFailed

    /// Read length exceeded total length specified in stream header.
    case lengthExceeded

    /// Read length less than total length specified in stream header.
    case incomplete

    /// Stream terminated before completion.
    case terminated

    /// Cannot perform operations on an unknown stream.
    case unknownStream

    /// Unable to register a stream handler more than once.
    case handlerAlreadyRegistered

    /// Given destination URL is not a directory.
    case notDirectory

    /// Unable to read information about the file to send.
    case fileInfoUnavailable

    /// Encryption type mismatch between stream header and chunk/trailer.
    case encryptionTypeMismatch(expected: EncryptionType, received: EncryptionType)
}
