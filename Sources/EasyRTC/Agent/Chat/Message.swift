/* -- */

import Foundation

/// A message received from the agent.
public struct ReceivedMessage: Identifiable, Equatable, Codable, Sendable {
    public let id: String
    public let timestamp: Date
    public let content: Content

    public enum Content: Equatable, Codable, Sendable {
        case agentTranscript(String)
        case userTranscript(String)
        case userInput(String)
    }
}

/// A message sent to the agent.
public struct SentMessage: Identifiable, Equatable, Codable, Sendable {
    public let id: String
    public let timestamp: Date
    public let content: Content

    public enum Content: Equatable, Codable, Sendable {
        case userInput(String)
    }
}
