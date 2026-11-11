import SwiftUI

public struct TrustedCallersView: View {
    @ObservedObject var storageService = StorageService.shared

    @State private var showingAddSheet: Bool = false
    @State private var newPhoneNumber: String = ""
    @State private var newLabel: String = ""
    @State private var newNotes: String = ""

    public var body: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                VStack {
                    if storageService.trustedCallers.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .font(.system(size: 48))
                                .foregroundColor(TrustifyTheme.textSecondary)
                            Text("No Trusted Callers")
                                .font(.headline)
                                .foregroundColor(TrustifyTheme.textPrimary)
                            Text("Add family, key contacts, or emergency dispatch numbers here to always bypass screening.")
                                .font(.footnote)
                                .foregroundColor(TrustifyTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(storageService.trustedCallers) { caller in
                                trustedCallerRow(caller)
                                    .listRowBackground(TrustifyTheme.cardBackground)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                            .onDelete { offsets in
                                storageService.deleteTrustedCaller(at: offsets)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Trusted Callers")
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddSheet = true
                }) {
                    Image(systemName: "person.badge.plus")
                        .font(.title3)
                        .foregroundColor(TrustifyTheme.emerald)
                }
            )
            .sheet(isPresented: $showingAddSheet) {
                addCallerSheet
            }
        }
    }

    private func trustedCallerRow(_ caller: UserTrustedCaller) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(caller.customLabel)
                    .font(.headline)
                    .foregroundColor(TrustifyTheme.textPrimary)
                Text(caller.phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(TrustifyTheme.textSecondary)
                if !caller.notes.isEmpty {
                    Text(caller.notes)
                        .font(.caption)
                        .foregroundColor(TrustifyTheme.teal)
                }
            }

            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(TrustifyTheme.emerald)
        }
        .padding(.vertical, 4)
    }

    private var addCallerSheet: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                VStack(spacing: 16) {
                    TextField("Phone Number (e.g. +919429887275)", text: $newPhoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(TrustifyTheme.cardBackground)
                        .foregroundColor(TrustifyTheme.textPrimary)
                        .cornerRadius(8)

                    TextField("Name / Label (e.g. Family Direct)", text: $newLabel)
                        .padding()
                        .background(TrustifyTheme.cardBackground)
                        .foregroundColor(TrustifyTheme.textPrimary)
                        .cornerRadius(8)

                    TextField("Notes (Optional)", text: $newNotes)
                        .padding()
                        .background(TrustifyTheme.cardBackground)
                        .foregroundColor(TrustifyTheme.textPrimary)
                        .cornerRadius(8)

                    Spacer()

                    Button(action: {
                        guard !newPhoneNumber.isEmpty, !newLabel.isEmpty else { return }
                        storageService.addTrustedCaller(
                            UserTrustedCaller(
                                phoneNumber: newPhoneNumber,
                                customLabel: newLabel,
                                notes: newNotes
                            )
                        )
                        newPhoneNumber = ""
                        newLabel = ""
                        newNotes = ""
                        showingAddSheet = false
                    }) {
                        Text("Save Trusted Caller")
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
            .navigationTitle("Add Trusted Caller")
            .navigationBarItems(leading: Button("Cancel") { showingAddSheet = false })
        }
    }
}

