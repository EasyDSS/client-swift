import Foundation

public extension ConnectOptions {
    func copyWith(autoSubscribe: ValueOrAbsent<Bool> = .absent,
                  reconnectAttempts: ValueOrAbsent<Int> = .absent,
                  reconnectAttemptDelay: ValueOrAbsent<TimeInterval> = .absent,
                  protocolVersion: ValueOrAbsent<ProtocolVersion> = .absent) -> ConnectOptions
    {
        ConnectOptions(autoSubscribe: autoSubscribe.value(ifAbsent: self.autoSubscribe),
                       reconnectAttempts: reconnectAttempts.value(ifAbsent: self.reconnectAttempts),
                       reconnectAttemptDelay: reconnectAttemptDelay.value(ifAbsent: self.reconnectAttemptDelay),
                       protocolVersion: protocolVersion.value(ifAbsent: self.protocolVersion))
    }
}
