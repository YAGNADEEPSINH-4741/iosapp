import Foundation

/**
 * On-Device Offline Seed Database for Indian telecom directory.
 * Formatted for both runtime in-app lookups and CallKit CXCallDirectoryProvider.
 */
public enum OfflineDirectorySeeder {

    public static let verifiedProfiles: [String: CallerProfile] = [
        // Emergency & Healthcare
        "+91112": CallerProfile(
            normalizedPhoneNumber: "+91112",
            businessName: "National Emergency Helpline",
            category: "Emergency Services",
            isVerifiedBusiness: true,
            verificationMethod: "Govt of India DoT Gazette",
            positiveConfirmationsCount: 5000
        ),
        "+91100": CallerProfile(
            normalizedPhoneNumber: "+91100",
            businessName: "Police Emergency",
            category: "Emergency Services",
            isVerifiedBusiness: true,
            verificationMethod: "Govt of India DoT Gazette",
            positiveConfirmationsCount: 4500
        ),
        "+91108": CallerProfile(
            normalizedPhoneNumber: "+91108",
            businessName: "Medical Emergency Ambulance",
            category: "Emergency Services",
            isVerifiedBusiness: true,
            verificationMethod: "Govt of India DoT Gazette",
            positiveConfirmationsCount: 3800
        ),

        // Major Indian Banks (Helpdesks)
        "+9118002026161": CallerProfile(
            normalizedPhoneNumber: "+9118002026161",
            businessName: "HDFC Bank Central Helpline",
            category: "Banking & Financial Services",
            isVerifiedBusiness: true,
            verificationMethod: "RBI Telecom Corporate Registration",
            positiveConfirmationsCount: 1200
        ),
        "+9118001234": CallerProfile(
            normalizedPhoneNumber: "+9118001234",
            businessName: "State Bank of India (SBI)",
            category: "Banking & Financial Services",
            isVerifiedBusiness: true,
            verificationMethod: "RBI Telecom Corporate Registration",
            positiveConfirmationsCount: 2500
        ),
        "+9118001080": CallerProfile(
            normalizedPhoneNumber: "+9118001080",
            businessName: "ICICI Bank Customer Care",
            category: "Banking & Financial Services",
            isVerifiedBusiness: true,
            verificationMethod: "RBI Telecom Corporate Registration",
            positiveConfirmationsCount: 980
        ),
        "+9118602662666": CallerProfile(
            normalizedPhoneNumber: "+9118602662666",
            businessName: "Kotak Mahindra Bank Support",
            category: "Banking & Financial Services",
            isVerifiedBusiness: true,
            verificationMethod: "RBI Telecom Corporate Registration",
            positiveConfirmationsCount: 850
        ),

        // Logistics & Delivery Partner Trunks
        "+9118002666868": CallerProfile(
            normalizedPhoneNumber: "+9118002666868",
            businessName: "India Post Speed Post",
            category: "Courier / Postal",
            isVerifiedBusiness: true,
            verificationMethod: "DoT Enterprise Directory",
            positiveConfirmationsCount: 1100
        ),
        "+9118001088888": CallerProfile(
            normalizedPhoneNumber: "+9118001088888",
            businessName: "Flipkart Customer Support",
            category: "E-Commerce Logistics",
            isVerifiedBusiness: true,
            verificationMethod: "DoT Enterprise Directory",
            positiveConfirmationsCount: 1450
        ),
        "+91180030009009": CallerProfile(
            normalizedPhoneNumber: "+91180030009009",
            businessName: "Amazon India Customer Service",
            category: "E-Commerce Logistics",
            isVerifiedBusiness: true,
            verificationMethod: "DoT Enterprise Directory",
            positiveConfirmationsCount: 1850
        ),
        "+918067466720": CallerProfile(
            normalizedPhoneNumber: "+918067466720",
            businessName: "Swiggy Delivery Partner Relay",
            category: "Food Delivery Dispatch",
            isVerifiedBusiness: true,
            verificationMethod: "Cloud Telephony Verified Partner",
            positiveConfirmationsCount: 890
        ),
        "+911140038888": CallerProfile(
            normalizedPhoneNumber: "+911140038888",
            businessName: "Zomato Logistics Dispatch",
            category: "Food Delivery Dispatch",
            isVerifiedBusiness: true,
            verificationMethod: "Cloud Telephony Verified Partner",
            positiveConfirmationsCount: 920
        ),
        "+911140038899": CallerProfile(
            normalizedPhoneNumber: "+911140038899",
            businessName: "Blinkit Instant Delivery Dispatch",
            category: "Quick Commerce Logistics",
            isVerifiedBusiness: true,
            verificationMethod: "Cloud Telephony Verified Partner",
            positiveConfirmationsCount: 760
        ),
        "+918067466755": CallerProfile(
            normalizedPhoneNumber: "+918067466755",
            businessName: "Zepto 10-Minute Delivery Relay",
            category: "Quick Commerce Logistics",
            isVerifiedBusiness: true,
            verificationMethod: "Cloud Telephony Verified Partner",
            positiveConfirmationsCount: 810
        ),
        "+918067466788": CallerProfile(
            normalizedPhoneNumber: "+918067466788",
            businessName: "Uber Driver Partner Dispatch",
            category: "Rides & Transit Dispatch",
            isVerifiedBusiness: true,
            verificationMethod: "Cloud Telephony Verified Partner",
            positiveConfirmationsCount: 1520
        ),
        "+918033553355": CallerProfile(
            normalizedPhoneNumber: "+918033553355",
            businessName: "Ola Cabs Driver Relay",
            category: "Rides & Transit Dispatch",
            isVerifiedBusiness: true,
            verificationMethod: "Cloud Telephony Verified Partner",
            positiveConfirmationsCount: 1390
        ),
        "+918067466799": CallerProfile(
            normalizedPhoneNumber: "+918067466799",
            businessName: "Rapido Captain Dispatch",
            category: "Rides & Transit Dispatch",
            isVerifiedBusiness: true,
            verificationMethod: "Cloud Telephony Verified Partner",
            positiveConfirmationsCount: 970
        ),
        "+9118602331234": CallerProfile(
            normalizedPhoneNumber: "+9118602331234",
            businessName: "Blue Dart Express Delivery Trunk",
            category: "Courier & Logistics",
            isVerifiedBusiness: true,
            verificationMethod: "DoT Enterprise Directory",
            positiveConfirmationsCount: 1680
        ),
        "+918025365032": CallerProfile(
            normalizedPhoneNumber: "+918025365032",
            businessName: "DTDC Express Courier Relay",
            category: "Courier & Logistics",
            isVerifiedBusiness: true,
            verificationMethod: "DoT Enterprise Directory",
            positiveConfirmationsCount: 1140
        )
    ]

    public static let verifiedIdentityResults: [CallerIdentityResult] = [
        CallerIdentityResult(
            rawNumber: "9429887275",
            normalizedNumber: "+919429887275",
            displayName: "Kokilaben Chudasama",
            source: .networkCnap,
            identityType: .networkProvided,
            confidence: .verified,
            sourceLabel: "BSNL Mobile • Gujarat, India",
            isVerified: true,
            organizationName: "BSNL Mobile • Gujarat Circle",
            category: "Personal Cellular (DoT Allocated)",
            attribution: "Attested via Telecom Calling Name Presentation (CNAP)"
        ),
        CallerIdentityResult(
            rawNumber: "1728338382",
            normalizedNumber: "+911728338382",
            displayName: "Seema Raj",
            source: .networkCnap,
            identityType: .networkProvided,
            confidence: .verified,
            sourceLabel: "New Delhi, India",
            isVerified: true,
            organizationName: "Bharti Airtel • Delhi Circle",
            category: "Personal Cellular (DoT Allocated)",
            attribution: "Attested via Telecom Calling Name Presentation (CNAP)"
        ),
        CallerIdentityResult(
            rawNumber: "98177164",
            normalizedNumber: "+9198177164",
            displayName: "Insurance Telemarketing",
            source: .traiSeries,
            identityType: .promotionalTelemarketing,
            confidence: .high,
            sourceLabel: "Mumbai, India",
            isVerified: false,
            organizationName: "Outbound Telemarketing Desk",
            category: "Telemarketing",
            attribution: "Reported by 3,568 community users as Spam"
        )
    ]

    public static func findProfile(by rawOrNormalized: String) -> CallerProfile? {
        let digits = rawOrNormalized.filter { $0.isNumber }
        let withPlus = "+" + (digits.hasPrefix("91") ? digits : "91" + digits)
        return verifiedProfiles[withPlus] ?? verifiedProfiles[rawOrNormalized]
    }

    public static func findIdentity(by rawOrNormalized: String) -> CallerIdentityResult? {
        let digits = rawOrNormalized.filter { $0.isNumber }
        let norm = digits.hasPrefix("91") && digits.count > 10 ? String(digits.dropFirst(2)) : digits
        return verifiedIdentityResults.first { record in
            let recDigits = record.normalizedNumber.filter { $0.isNumber }
            let recNorm = recDigits.hasPrefix("91") && recDigits.count > 10 ? String(recDigits.dropFirst(2)) : recDigits
            return recNorm == norm || recDigits == digits
        }
    }

    /**
     * CallKit requires phone numbers to be Int64, with country code,
     * and strictly in ASCENDING numerical order.
     */
    public static func getSortedCallDirectoryEntries() -> [(number: Int64, label: String)] {
        var entries: [(number: Int64, label: String)] = []

        for (phone, profile) in verifiedProfiles {
            let digits = phone.filter { $0.isNumber }
            if let num = Int64(digits) {
                let badge = profile.isVerifiedBusiness ? "Trustify: \(profile.businessName)" : profile.businessName
                entries.append((number: num, label: badge))
            }
        }

        for identity in verifiedIdentityResults {
            let digits = identity.normalizedNumber.filter { $0.isNumber }
            if let num = Int64(digits) {
                let badge = identity.isVerified ? "Trustify: \(identity.displayName)" : identity.displayName
                if !entries.contains(where: { $0.number == num }) {
                    entries.append((number: num, label: badge))
                }
            }
        }

        // Must sort ascending for CallKit!
        return entries.sorted { $0.number < $1.number }
    }
}

