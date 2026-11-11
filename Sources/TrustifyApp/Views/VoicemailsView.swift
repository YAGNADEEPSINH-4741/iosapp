import SwiftUI

public struct VoicemailsView: View {
    @ObservedObject var supabaseService = SupabaseService.shared
    @ObservedObject var audioPlayer = AudioPlayerService.shared

    public var body: some View {
        NavigationView {
            ZStack {
                TrustifyTheme.primaryDark.ignoresSafeArea()

                VStack {
                    if supabaseService.isLoading {
                        ProgressView("Fetching voicemails...")
                            .foregroundColor(TrustifyTheme.textSecondary)
                            .padding()
                    }

                    if supabaseService.voicemails.isEmpty && !supabaseService.isLoading {
                        VStack(spacing: 12) {
                            Image(systemName: "recordingtape")
                                .font(.system(size: 48))
                                .foregroundColor(TrustifyTheme.textSecondary)
                            Text("No Voicemails Yet")
                                .font(.headline)
                                .foregroundColor(TrustifyTheme.textPrimary)
                            Text("When unanswered callers leave web voice messages via Supabase, they will appear here.")
                                .font(.footnote)
                                .foregroundColor(TrustifyTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(supabaseService.voicemails) { voicemail in
                                voicemailRow(voicemail)
                                    .listRowBackground(TrustifyTheme.cardBackground)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Voice Messages")
            .navigationBarItems(
                trailing: Button(action: {
                    Task {
                        await supabaseService.fetchVoicemails()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(TrustifyTheme.emerald)
                }
            )
        }
    }

    private func voicemailRow(_ voicemail: Voicemail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(voicemail.callerName ?? voicemail.phoneNumber)
                        .font(.headline)
                        .foregroundColor(TrustifyTheme.textPrimary)
                    Text(voicemail.phoneNumber)
                        .font(.caption)
                        .foregroundColor(TrustifyTheme.textSecondary)
                }

                Spacer()

                Text(formatDate(voicemail.timestamp))
                    .font(.caption2)
                    .foregroundColor(TrustifyTheme.textSecondary)
            }

            // Player control bar
            HStack(spacing: 14) {
                Button(action: {
                    if let url = voicemail.audioUrl {
                        audioPlayer.playAudio(from: url, id: voicemail.id)
                    }
                }) {
                    Image(systemName: (audioPlayer.currentPlayingId == voicemail.id && audioPlayer.isPlaying) ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(TrustifyTheme.emerald)
                }

                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(
                        value: (audioPlayer.currentPlayingId == voicemail.id && audioPlayer.duration > 0)
                            ? (audioPlayer.currentTime / audioPlayer.duration)
                            : 0
                    )
                    .accentColor(TrustifyTheme.emerald)

                    HStack {
                        Text(formatDuration(
                            audioPlayer.currentPlayingId == voicemail.id ? Int(audioPlayer.currentTime) : 0
                        ))
                        Spacer()
                        Text(formatDuration(voicemail.durationSeconds))
                    }
                    .font(.caption2)
                    .foregroundColor(TrustifyTheme.textSecondary)
                }

                // Call back button
                Button(action: {
                    if let url = URL(string: "tel://\(voicemail.phoneNumber)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "phone.arrow.up.right.fill")
                        .font(.subheadline)
                        .padding(8)
                        .background(TrustifyTheme.cardHover)
                        .foregroundColor(TrustifyTheme.teal)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

