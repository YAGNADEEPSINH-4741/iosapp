import SwiftUI

public struct NotedNumbersView: View {
    @ObservedObject var storageService = StorageService.shared

    @State private var showingAddSheet: Bool = false
    @State private var newPhoneNumber: String = ""
    @State private var newNotedValue: String = ""
    @State private var newLabel: String = "Delivery OTP"
    @State private var copiedId: String? = nil

    public var body: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                VStack {
                    if storageService.notedNumbers.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "note.text")
                                .font(.system(size: 48))
                                .foregroundColor(TrustifyTheme.textSecondary)
                            Text("No Noted Numbers")
                                .font(.headline)
                                .foregroundColor(TrustifyTheme.textPrimary)
                            Text("Save OTPs, tracking numbers, or reference IDs here with quick one-tap copy.")
                                .font(.footnote)
                                .foregroundColor(TrustifyTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(storageService.notedNumbers) { note in
                                noteCard(note)
                                    .listRowBackground(TrustifyTheme.cardBackground)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                            .onDelete { offsets in
                                storageService.deleteNotedNumber(at: offsets)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Noted Numbers")
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(TrustifyTheme.emerald)
                }
            )
            .sheet(isPresented: $showingAddSheet) {
                addNoteSheet
            }
        }
    }

    private func noteCard(_ note: NotedNumber) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.label)
                    .font(.caption.bold())
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .background(TrustifyTheme.teal.opacity(0.2))
                    .foregroundColor(TrustifyTheme.teal)
                    .cornerRadius(4)

                Spacer()

                Text(formatDate(note.createdAt))
                    .font(.caption2)
                    .foregroundColor(TrustifyTheme.textSecondary)
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(note.notedValue)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(TrustifyTheme.textPrimary)
                    Text("Linked: \(note.phoneNumber)")
                        .font(.caption)
                        .foregroundColor(TrustifyTheme.textSecondary)
                }

                Spacer()

                Button(action: {
                    UIPasteboard.general.string = note.notedValue
                    copiedId = note.id
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        copiedId = nil
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: copiedId == note.id ? "checkmark" : "doc.on.doc")
                        Text(copiedId == note.id ? "Copied" : "Copy")
                    }
                    .font(.caption.weight(.semibold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(copiedId == note.id ? TrustifyTheme.emerald : TrustifyTheme.cardHover)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var addNoteSheet: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                VStack(spacing: 16) {
                    TextField("Phone Number (Optional)", text: $newPhoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(TrustifyTheme.cardBackground)
                        .foregroundColor(TrustifyTheme.textPrimary)
                        .cornerRadius(8)

                    TextField("Value / Code / OTP", text: $newNotedValue)
                        .padding()
                        .background(TrustifyTheme.cardBackground)
                        .foregroundColor(TrustifyTheme.textPrimary)
                        .cornerRadius(8)

                    Picker("Label", selection: $newLabel) {
                        Text("Delivery OTP").tag("Delivery OTP")
                        Text("Tracking ID").tag("Tracking ID")
                        Text("Account Number").tag("Account Number")
                        Text("Reference Code").tag("Reference Code")
                        Text("General").tag("General")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Spacer()

                    Button(action: {
                        guard !newNotedValue.isEmpty else { return }
                        storageService.addNotedNumber(
                            NotedNumber(
                                phoneNumber: newPhoneNumber.isEmpty ? "Direct Note" : newPhoneNumber,
                                notedValue: newNotedValue,
                                label: newLabel
                            )
                        )
                        newPhoneNumber = ""
                        newNotedValue = ""
                        showingAddSheet = false
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
            .navigationTitle("New Note")
            .navigationBarItems(leading: Button("Cancel") { showingAddSheet = false })
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

