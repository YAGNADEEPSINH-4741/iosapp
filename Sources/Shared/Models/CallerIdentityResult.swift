import Foundation

public enum CallerIdentitySource: String, Codable {
    case networkCnap = "NETWORK_CNAP"
    case traiSeries = "TRAI_SERIES"
    case verifiedDirectory = "VERIFIED_DIRECTORY"
    case communityReports = "COMMUNITY_REPORTS"
    case localContact = "LOCAL_CONTACT"
    case osmOverpass = "OSM_OVERPASS"
    case aadhaarKyc = "AADHAAR_KYC"
    case heuristic = "HEURISTIC"
}

public enum CallerIdentityType: String, Codable {
    case networkProvided = "NETWORK_PROVIDED"
    case publicService = "PUBLIC_SERVICE"
    case verifiedBusiness = "VERIFIED_BUSINESS"
    case promotionalTelemarketing = "PROMOTIONAL_TELEMARKETING"
    case serviceTransactional = "SERVICE_TRANSACTIONAL"
    case suspectedFraud = "SUSPECTED_FRAUD"
    case personalCellular = "PERSONAL_CELLULAR"
    case unknown = "UNKNOWN"
}

public enum IdentityConfidence: String, Codable {
    case verified = "VERIFIED"
    case high = "HIGH"
    case medium = "MEDIUM"
    case low = "LOW"
    case unverified = "UNVERIFIED"
}

public struct CallerIdentityResult: Codable, Identifiable {
    public var id: String { normalizedNumber }
    public let rawNumber: String
    public let normalizedNumber: String
    public let displayName: String
    public let source: CallerIdentitySource
    public let identityType: CallerIdentityType
    public let confidence: IdentityConfidence
    public let sourceLabel: String
    public let isVerified: Bool
    public let organizationName: String?
    public let category: String
    public let attribution: String?

    public init(
        rawNumber: String,
        normalizedNumber: String,
        displayName: String,
        source: CallerIdentitySource,
        identityType: CallerIdentityType,
        confidence: IdentityConfidence,
        sourceLabel: String,
        isVerified: Bool,
        organizationName: String? = nil,
        category: String,
        attribution: String? = nil
    ) {
        self.rawNumber = rawNumber
        self.normalizedNumber = normalizedNumber
        self.displayName = displayName
        self.source = source
        self.identityType = identityType
        self.confidence = confidence
        self.sourceLabel = sourceLabel
        self.isVerified = isVerified
        self.organizationName = organizationName
        self.category = category
        self.attribution = attribution
    }
}
