import Foundation

public enum SimulateScenario: Sendable {
    // Client
    case quickReconnect
    case fullReconnect
    // Server
    case nodeFailure
    case migration
    case serverLeave
    case speakerUpdate(seconds: Int)
    case forceTCP
    case forceTLS
}

public extension Room {
    /// Simulate a scenario for debuggin
    func debug_simulate(scenario: SimulateScenario) async throws {
        if case .quickReconnect = scenario {
            try await startReconnect(reason: .debug)
        } else if case .fullReconnect = scenario {
            try await startReconnect(reason: .debug, nextReconnectMode: .full)
        } else {
            try await signalClient.sendSimulate(scenario: scenario)
        }
    }
}
