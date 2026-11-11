import Foundation

public struct CallerProfile: Codable, Identifiable {
    public var id: String { normalizedPhoneNumber }
    public let normalizedPhoneNumber: String
    public let businessName: String
    public let category: String
    public let isVerifiedBusiness: Bool
    public let verificationMethod: String
    public let spamReportsCount: Int
    public let falseSpamReportsCount: Int
    public let positiveConfirmationsCount: Int

    public init(
        normalizedPhoneNumber: String,
        businessName: String,
        category: String,
        isVerifiedBusiness: Bool = false,
        verificationMethod: String = "",
        spamReportsCount: Int = 0,
        falseSpamReportsCount: Int = 0,
        positiveConfirmationsCount: Int = 0
    ) {
        self.normalizedPhoneNumber = normalizedPhoneNumber
        self.businessName = businessName
        self.category = category
        self.isVerifiedBusiness = isVerifiedBusiness
        self.verificationMethod = verificationMethod
        self.spamReportsCount = spamReportsCount
        self.falseSpamReportsCount = falseSpamReportsCount
        self.positiveConfirmationsCount = positiveConfirmationsCount
    }
}

