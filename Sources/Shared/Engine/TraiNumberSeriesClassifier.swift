import Foundation

/**
 * Deterministic classifier for official Indian telecom numbering series based on
 * regulations established by the Telecom Regulatory Authority of India (TRAI) and
 * Department of Telecommunications (DoT).
 *
 * Applicable series:
 * - 140 series: Mandatory prefix for registered promotional telemarketing voice calls.
 * - 1600 series: Mandated by DoT & TRAI for Banking, Financial Services, and Insurance (BFSI) & Govt service calls.
 * - 1601 series: Mandated by DoT & TRAI for essential utilities, courier, express logistics & delivery services.
 * - 1800 series: National toll-free communications.
 * - 1860 series: Shared-cost enterprise customer support.
 * - Official emergency short codes (112, 100, 101, 102, 108, 1091, 1098).
 */
public enum TraiNumberSeriesClassifier {

    private static let emergencyShortCodes: [String: String] = [
        "112": "National Emergency Helpline",
        "100": "Police Emergency",
        "101": "Fire Emergency",
        "102": "Ambulance Emergency",
        "108": "Medical Emergency Helpline",
        "1091": "Women Helpline",
        "1098": "Childline Support"
    ]

    public static func classify(rawNumber: String) -> CallerIdentityResult? {
        let trimmed = rawNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }

        let digitsOnly = trimmed.filter { $0.isNumber }
        if digitsOnly.isEmpty { return nil }

        // 1. Check emergency short codes (e.g., 112, 100)
        if let emergencyName = emergencyShortCodes[digitsOnly] {
            return CallerIdentityResult(
                rawNumber: rawNumber,
                normalizedNumber: digitsOnly,
                displayName: emergencyName,
                source: .traiSeries,
                identityType: .publicService,
                confidence: .high,
                sourceLabel: "National emergency helpline",
                isVerified: true,
                category: "Emergency",
                attribution: "Official DoT Emergency Short Code"
            )
        }

        // 2. Normalize country code (+91 / 91 / 0)
        var nationalNumber = digitsOnly
        if nationalNumber.hasPrefix("91") && nationalNumber.count > 10 {
            nationalNumber = String(nationalNumber.dropFirst(2))
        } else if nationalNumber.hasPrefix("0") && nationalNumber.count > 10 {
            nationalNumber = String(nationalNumber.dropFirst(1))
        }

        // 3. TRAI 140 Series - Promotional Telemarketing
        if nationalNumber.hasPrefix("140") {
            return CallerIdentityResult(
                rawNumber: rawNumber,
                normalizedNumber: "+91" + nationalNumber,
                displayName: "Promotional Telemarketer",
                source: .traiSeries,
                identityType: .promotionalTelemarketing,
                confidence: .high,
                sourceLabel: "TRAI 140 Series • Telemarketing",
                isVerified: false,
                organizationName: "Registered Commercial Telemarketer",
                category: "Promotional / Telemarketing",
                attribution: "Mandated by TRAI for commercial telemarketing voice calls"
            )
        }

        // 4. TRAI 1600 Series - BFSI & Government Transactions
        if nationalNumber.hasPrefix("1600") {
            return CallerIdentityResult(
                rawNumber: rawNumber,
                normalizedNumber: "+91" + nationalNumber,
                displayName: "Bank / Financial Service Transaction",
                source: .traiSeries,
                identityType: .serviceTransactional,
                confidence: .high,
                sourceLabel: "TRAI 1600 Series • BFSI & Govt",
                isVerified: true,
                organizationName: "Banking / Financial Entity",
                category: "Banking & Financial Services",
                attribution: "Mandated by DoT & TRAI for legitimate transactional banking calls"
            )
        }

        // 5. TRAI 1601 Series - Essential Utilities & Courier Logistics
        if nationalNumber.hasPrefix("1601") {
            return CallerIdentityResult(
                rawNumber: rawNumber,
                normalizedNumber: "+91" + nationalNumber,
                displayName: "Courier / Utility Delivery Service",
                source: .traiSeries,
                identityType: .serviceTransactional,
                confidence: .high,
                sourceLabel: "TRAI 1601 Series • Courier & Utilities",
                isVerified: true,
                organizationName: "Express Delivery & Logistics Desk",
                category: "Courier / Utilities / Delivery",
                attribution: "Mandated by DoT & TRAI for essential utilities and delivery relay calls"
            )
        }

        // 6. National Toll-Free 1800 Series
        if nationalNumber.hasPrefix("1800") {
            return CallerIdentityResult(
                rawNumber: rawNumber,
                normalizedNumber: "+91" + nationalNumber,
                displayName: "National Toll-Free Helpline",
                source: .traiSeries,
                identityType: .verifiedBusiness,
                confidence: .medium,
                sourceLabel: "Toll-Free Helpline",
                isVerified: true,
                organizationName: "Enterprise Customer Care",
                category: "Customer Support (Toll-Free)",
                attribution: "National 1800 Toll-Free Inbound Service"
            )
        }

        // 7. National Shared-Cost 1860 Series
        if nationalNumber.hasPrefix("1860") {
            return CallerIdentityResult(
                rawNumber: rawNumber,
                normalizedNumber: "+91" + nationalNumber,
                displayName: "Enterprise Support Desk",
                source: .traiSeries,
                identityType: .verifiedBusiness,
                confidence: .medium,
                sourceLabel: "Enterprise Helpline",
                isVerified: true,
                organizationName: "Corporate Helpdesk",
                category: "Corporate Support (Shared-Cost)",
                attribution: "National 1860 Shared-Cost Trunk"
            )
        }

        return nil
    }
}

