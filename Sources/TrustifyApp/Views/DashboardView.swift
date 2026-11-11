import SwiftUI

public struct DashboardView: View {
    @ObservedObject var callKitManager = CallKitManager.shared
    @ObservedObject var storageService = StorageService.shared
    @ObservedObject var supabaseService = SupabaseService.shared

    @State private var quickCheckText: String = ""
    @State private var quickResult: CallerIdentityResult? = nil

    public var body: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Trustify")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(TrustifyTheme.textPrimary)
                                Text("On-Device Telecom Shield & Caller ID")
                                    .font(.subheadline)
                                    .foregroundColor(TrustifyTheme.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "shield.lefthalf.filled")
                                .font(.system(size: 32))
                                .foregroundColor(TrustifyTheme.emerald)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // CallKit Status Card
                        callKitStatusCard

                        // Quick Stat Grid
                        statGrid

                        // Quick Number Verification Card
                        quickCheckCard

                        // CallKit Setup Instructions
                        instructionsCard
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var callKitStatusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: callKitManager.isEnabled ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(callKitManager.isEnabled ? TrustifyTheme.emerald : TrustifyTheme.amber)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(callKitManager.isEnabled ? "iOS Caller ID Active" : "Action Required in iOS Settings")
                        .font(.headline)
                        .foregroundColor(TrustifyTheme.textPrimary)
                    Text(callKitManager.statusMessage)
                        .font(.footnote)
                        .foregroundColor(TrustifyTheme.textSecondary)
                }
                Spacer()
            }

            HStack {
                Button(action: {
                    callKitManager.reloadExtension()
                }) {
                    HStack {
                        if callKitManager.isReloading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                        Text(callKitManager.isReloading ? "Updating..." : "Reload Directory")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(TrustifyTheme.cardHover)
                    .foregroundColor(TrustifyTheme.textPrimary)
                    .cornerRadius(8)
                }
                .disabled(callKitManager.isReloading)

                Spacer()

                if !callKitManager.isEnabled {
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Open Settings")
                            .font(.subheadline.weight(.semibold))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(TrustifyTheme.emerald)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(TrustifyTheme.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(callKitManager.isEnabled ? TrustifyTheme.emerald.opacity(0.3) : TrustifyTheme.amber.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var statGrid: some View {
        HStack(spacing: 12) {
            statTile(
                title: "Verified Seed",
                value: "\(OfflineDirectorySeeder.verifiedProfiles.count + OfflineDirectorySeeder.verifiedIdentityResults.count)",
                icon: "building.2.crop.circle.fill",
                color: TrustifyTheme.teal
            )
            statTile(
                title: "Noted Notes",
                value: "\(storageService.notedNumbers.count)",
                icon: "note.text",
                color: TrustifyTheme.emerald
            )
            statTile(
                title: "Voicemails",
                value: "\(supabaseService.voicemails.count)",
                icon: "recordingtape",
                color: TrustifyTheme.amber
            )
        }
        .padding(.horizontal)
    }

    private func statTile(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                Spacer()
            }
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(TrustifyTheme.textPrimary)
            Text(title)
                .font(.caption)
                .foregroundColor(TrustifyTheme.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(TrustifyTheme.cardBackground)
        .cornerRadius(12)
    }

    private var quickCheckCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Instant On-Device Check")
                .font(.headline)
                .foregroundColor(TrustifyTheme.textPrimary)

            HStack {
                TextField("Enter phone number (e.g. 18002026161, 9429887275)", text: $quickCheckText)
                    .keyboardType(.phonePad)
                    .padding(10)
                    .background(TrustifyTheme.cardHover)
                    .foregroundColor(TrustifyTheme.textPrimary)
                    .cornerRadius(8)
                    .onChange(of: quickCheckText) { val in
                        runQuickCheck(val)
                    }

                if !quickCheckText.isEmpty {
                    Button(action: {
                        quickCheckText = ""
                        quickResult = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(TrustifyTheme.textSecondary)
                    }
                }
            }

            if let result = quickResult {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: result.isVerified ? "checkmark.circle.fill" : "exclamationmark.octagon.fill")
                            .foregroundColor(result.isVerified ? TrustifyTheme.emerald : TrustifyTheme.coralRed)
                        Text(result.displayName)
                            .font(.headline)
                            .foregroundColor(TrustifyTheme.textPrimary)
                    }
                    Text("\(result.category) • \(result.sourceLabel)")
                        .font(.footnote)
                        .foregroundColor(TrustifyTheme.textSecondary)
                    if let attribution = result.attribution {
                        Text(attribution)
                            .font(.caption2)
                            .foregroundColor(TrustifyTheme.teal)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(TrustifyTheme.cardHover)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(TrustifyTheme.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var instructionsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How to Enable iOS Caller ID")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(TrustifyTheme.textPrimary)

            VStack(alignment: .leading, spacing: 6) {
                stepRow(num: "1", text: "Open iPhone Settings app")
                stepRow(num: "2", text: "Tap Phone > Call Blocking & Identification")
                stepRow(num: "3", text: "Toggle Trustify ON")
            }
            .font(.footnote)
            .foregroundColor(TrustifyTheme.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(TrustifyTheme.cardBackground.opacity(0.6))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private func stepRow(num: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(num)
                .font(.caption.bold())
                .frame(width: 18, height: 18)
                .background(TrustifyTheme.teal.opacity(0.2))
                .foregroundColor(TrustifyTheme.teal)
                .clipShape(Circle())
            Text(text)
        }
    }

    private func runQuickCheck(_ number: String) {
        let clean = number.trimmingCharacters(in: .whitespacesAndNewlines)
        if clean.isEmpty {
            quickResult = nil
            return
        }

        // 1. Check offline seed identities
        if let identity = OfflineDirectorySeeder.findIdentity(by: clean) {
            quickResult = identity
            return
        }

        // 2. Check offline verified profiles
        if let profile = OfflineDirectorySeeder.findProfile(by: clean) {
            quickResult = CallerIdentityResult(
                rawNumber: clean,
                normalizedNumber: profile.normalizedPhoneNumber,
                displayName: profile.businessName,
                source: .verifiedDirectory,
                identityType: profile.isVerifiedBusiness ? .verifiedBusiness : .unknown,
                confidence: .verified,
                sourceLabel: profile.verificationMethod,
                isVerified: profile.isVerifiedBusiness,
                organizationName: profile.businessName,
                category: profile.category,
                attribution: "Seeded in offline directory"
            )
            return
        }

        // 3. Check TRAI series (140, 1600, 1800, etc.)
        if let trai = TraiNumberSeriesClassifier.classify(rawNumber: clean) {
            quickResult = trai
            return
        }

        quickResult = CallerIdentityResult(
            rawNumber: clean,
            normalizedNumber: clean,
            displayName: "Unidentified Personal Caller",
            source: .heuristic,
            identityType: .personalCellular,
            confidence: .low,
            sourceLabel: "Standard Cellular Line",
            isVerified: false,
            category: "Standard Mobile",
            attribution: "No telemarketing or enterprise flags detected"
        )
    }
}
