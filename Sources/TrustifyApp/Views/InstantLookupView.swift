import SwiftUI

public struct InstantLookupView: View {
    @ObservedObject var storageService = StorageService.shared

    @State private var inputNumber: String = ""
    @State private var searchResult: CallerIdentityResult? = nil
    @State private var showingAddNoteSheet: Bool = false
    @State private var newNoteValue: String = ""
    @State private var newNoteLabel: String = "OTP"

    private let dialpadRows = [
        [("1", ""), ("2", "ABC"), ("3", "DEF")],
        [("4", "GHI"), ("5", "JKL"), ("6", "MNO")],
        [("7", "PQRS"), ("8", "TUV"), ("9", "WXYZ")],
        [("*", ""), ("0", "+"), ("#", "")]
    ]

    public var body: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Display Box
                        VStack(spacing: 8) {
                            Text(inputNumber.isEmpty ? "Enter Number" : inputNumber)
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(inputNumber.isEmpty ? TrustifyTheme.textSecondary : TrustifyTheme.textPrimary)
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)

                            if !inputNumber.isEmpty {
                                Button(action: {
                                    if !inputNumber.isEmpty {
                                        inputNumber.removeLast()
                                        evaluate(inputNumber)
                                    }
                                }) {
                                    Image(systemName: "delete.left.fill")
                                        .foregroundColor(TrustifyTheme.textSecondary)
                                        .font(.title3)
                                }
                            }
                        }
                        .padding()
                        .background(TrustifyTheme.cardBackground)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Result Card if available
                        if let result = searchResult {
                            resultCard(result)
                        }

                        // Dialpad
                        dialpadView
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Instant Lookup")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddNoteSheet) {
                addNoteSheet
            }
        }
    }

    private var dialpadView: some View {
        VStack(spacing: 12) {
            ForEach(dialpadRows, id: \.self.first!.0) { row in
                HStack(spacing: 20) {
                    ForEach(row, id: \.0) { item in
                        Button(action: {
                            inputNumber.append(item.0)
                            evaluate(inputNumber)
                        }) {
                            VStack(spacing: 2) {
                                Text(item.0)
                                    .font(.title.weight(.bold))
                                    .foregroundColor(TrustifyTheme.textPrimary)
                                if !item.1.isEmpty {
                                    Text(item.1)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(TrustifyTheme.textSecondary)
                                }
                            }
                            .frame(width: 72, height: 60)
                            .background(TrustifyTheme.cardBackground)
                            .clipShape(Circle())
                        }
                    }
                }
            }

            // Quick Call or Clear button
            HStack(spacing: 20) {
                Button(action: {
                    inputNumber = ""
                    searchResult = nil
                }) {
                    Text("Clear")
                        .font(.subheadline.bold())
                        .foregroundColor(TrustifyTheme.coralRed)
                        .frame(width: 72, height: 50)
                        .background(TrustifyTheme.cardBackground)
                        .cornerRadius(25)
                }

                Button(action: {
                    if let url = URL(string: "tel://\(inputNumber)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "phone.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 50)
                        .background(TrustifyTheme.emerald)
                        .cornerRadius(25)
                }
                .disabled(inputNumber.isEmpty)
            }
            .padding(.top, 6)
        }
        .padding(.horizontal)
    }

    private func resultCard(_ result: CallerIdentityResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: result.isVerified ? "shield.checkmark.fill" : "exclamationmark.shield.fill")
                    .foregroundColor(result.isVerified ? TrustifyTheme.emerald : TrustifyTheme.coralRed)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(result.displayName)
                        .font(.headline)
                        .foregroundColor(TrustifyTheme.textPrimary)
                    Text("\(result.category) • \(result.sourceLabel)")
                        .font(.footnote)
                        .foregroundColor(TrustifyTheme.textSecondary)
                }
                Spacer()
            }

            if let attribution = result.attribution {
                Text(attribution)
                    .font(.caption)
                    .foregroundColor(TrustifyTheme.teal)
            }

            Divider().background(TrustifyTheme.border)

            HStack(spacing: 12) {
                Button(action: {
                    newNoteValue = inputNumber
                    showingAddNoteSheet = true
                }) {
                    Label("Note Number", systemImage: "square.and.pencil")
                        .font(.footnote.weight(.semibold))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(TrustifyTheme.cardHover)
                        .foregroundColor(TrustifyTheme.textPrimary)
                        .cornerRadius(8)
                }

                Button(action: {
                    storageService.addTrustedCaller(
                        UserTrustedCaller(
                            phoneNumber: result.normalizedNumber,
                            customLabel: result.displayName,
                            notes: result.category
                        )
                    )
                }) {
                    Label("Trust Caller", systemImage: "person.badge.shield.checkmark.fill")
                        .font(.footnote.weight(.semibold))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(TrustifyTheme.emerald.opacity(0.2))
                        .foregroundColor(TrustifyTheme.emerald)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(TrustifyTheme.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var addNoteSheet: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()
                VStack(spacing: 20) {
                    TextField("Value / OTP / Code", text: $newNoteValue)
                        .padding()
                        .background(TrustifyTheme.cardBackground)
                        .foregroundColor(TrustifyTheme.textPrimary)
                        .cornerRadius(8)

                    Picker("Label", selection: $newNoteLabel) {
                        Text("Delivery OTP").tag("Delivery OTP")
                        Text("Tracking ID").tag("Tracking ID")
                        Text("Account Number").tag("Account Number")
                        Text("Reference Code").tag("Reference Code")
                        Text("General").tag("General")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Spacer()

                    Button(action: {
                        storageService.addNotedNumber(
                            NotedNumber(
                                phoneNumber: inputNumber,
                                notedValue: newNoteValue,
                                label: newNoteLabel
                            )
                        )
                        showingAddNoteSheet = false
                    }) {
                        Text("Save Note")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(TrustifyTheme.emerald)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Note Details")
            .navigationBarItems(leading: Button("Cancel") { showingAddNoteSheet = false })
        }
    }

    private func evaluate(_ number: String) {
        let clean = number.trimmingCharacters(in: .whitespacesAndNewlines)
        if clean.count < 3 {
            searchResult = nil
            return
        }

        if let identity = OfflineDirectorySeeder.findIdentity(by: clean) {
            searchResult = identity
            return
        }

        if let profile = OfflineDirectorySeeder.findProfile(by: clean) {
            searchResult = CallerIdentityResult(
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
                attribution: "Offline Seed Directory"
            )
            return
        }

        if let trai = TraiNumberSeriesClassifier.classify(rawNumber: clean) {
            searchResult = trai
            return
        }

        searchResult = nil
    }
}

