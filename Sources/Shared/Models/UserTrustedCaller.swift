import Foundation

public struct UserTrustedCaller: Codable, Identifiable {
    public var id: String { phoneNumber }
    public let phoneNumber: String
    public let customLabel: String
    public let notes: String
    public let addedAt: Date

    public init(
        phoneNumber: String,
        customLabel: String,
        notes: String = "",
        addedAt: Date = Date()
    ) {
        self.phoneNumber = phoneNumber
        self.customLabel = customLabel
        self.notes = notes
        self.addedAt = addedAt
    }
}
