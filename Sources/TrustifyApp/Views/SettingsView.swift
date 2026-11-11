import SwiftUI

public struct SettingsView: View {
    @ObservedObject var callKitManager = CallKitManager.shared
    @ObservedObject var supabaseService = SupabaseService.shared

    @State private var showingSavedAlert: Bool = false

    public var body: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                Form {
                    Section(header: Text("iOS Caller ID Extension").foregroundColor(TrustifyTheme.teal)) {
                        HStack {
                            Text("Status")
                            Spacer()
                            Text(callKitManager.isEnabled ? "Active" : "Disabled")
                                .foregroundColor(callKitManager.isEnabled ? TrustifyTheme.emerald : TrustifyTheme.amber)
                                .bold()
                        }

                        Button(action: {
                            callKitManager.reloadExtension()
                        }) {
                            HStack {
                                Text("Reload Call Directory")
                                Spacer()
                                if callKitManager.isReloading {
                                    ProgressView()
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                        }

                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Open iOS Settings (Phone > Call Identification)")
                                .foregroundColor(TrustifyTheme.teal)
                        }
                    }
                    .listRowBackground(TrustifyTheme.cardBackground)

                    Section(header: Text("Supabase Voicemail Backend").foregroundColor(TrustifyTheme.teal)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Supabase Project URL")
                                .font(.caption)
                                .foregroundColor(TrustifyTheme.textSecondary)
                            TextField("https://your-project.supabase.co", text: $supabaseService.supabaseUrl)
                                .font(.subheadline)
                                .foregroundColor(TrustifyTheme.textPrimary)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Supabase Anon Key")
                                .font(.caption)
                                .foregroundColor(TrustifyTheme.textSecondary)
                            SecureField("eyJhbGciOi...", text: $supabaseService.supabaseAnonKey)
                                .font(.subheadline)
                                .foregroundColor(TrustifyTheme.textPrimary)
                        }

                        Button(action: {
                            Task {
                                await supabaseService.fetchVoicemails()
                                showingSavedAlert = true
                            }
                        }) {
                            Text("Test & Sync Voicemails")
                                .foregroundColor(TrustifyTheme.emerald)
                        }
                    }
                    .listRowBackground(TrustifyTheme.cardBackground)

                    Section(header: Text("About Trustify iOS").foregroundColor(TrustifyTheme.teal)) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("4.0.0 (iOS Sideloaded)")
                                .foregroundColor(TrustifyTheme.textSecondary)
                        }

                        HStack {
                            Text("Database Version")
                            Spacer()
                            Text("v4 (Non-Destructive)")
                                .foregroundColor(TrustifyTheme.textSecondary)
                        }

                        HStack {
                            Text("CallKit Identifier")
                            Spacer()
                            Text(CallKitManager.extensionBundleId)
                                .font(.caption2)
                                .foregroundColor(TrustifyTheme.textSecondary)
                        }
                    }
                    .listRowBackground(TrustifyTheme.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showingSavedAlert) {
                Alert(
                    title: Text("Supabase Sync"),
                    message: Text(supabaseService.errorMessage ?? "Connected successfully!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

