import Foundation

public struct Voicemail: Codable, Identifiable {
    public let id: String
    public let phoneNumber: String
    public let callerName: String?
    public let durationSeconds: Int
    public let audioUrl: String?
    public let localFilePath: String?
    public let timestamp: Date
    public var isRead: Bool
    public let isSynced: Bool

    public init(
        id: String = UUID().uuidString,
        phoneNumber: String,
        callerName: String? = nil,
        durationSeconds: Int = 0,
        audioUrl: String? = nil,
        localFilePath: String? = nil,
        timestamp: Date = Date(),
        isRead: Bool = false,
        isSynced: Bool = true
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.callerName = callerName
        self.durationSeconds = durationSeconds
        self.audioUrl = audioUrl
        self.localFilePath = localFilePath
        self.timestamp = timestamp
        self.isRead = isRead
        self.isSynced = isSynced
    }
}

