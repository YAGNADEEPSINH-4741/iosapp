import Foundation

public struct NotedNumber: Codable, Identifiable {
    public let id: String
    public let phoneNumber: String
    public let notedValue: String
    public let label: String
    public let callId: String?
    public let createdAt: Date

    public init(
        id: String = UUID().uuidString,
        phoneNumber: String,
        notedValue: String,
        label: String = "General",
        callId: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.notedValue = notedValue
        self.label = label
        self.callId = callId
        self.createdAt = createdAt
    }
}

