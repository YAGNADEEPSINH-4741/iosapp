import Foundation
import Combine

public class SupabaseService: ObservableObject {
    public static let shared = SupabaseService()

    @Published public var supabaseUrl: String {
        didSet { UserDefaults.standard.set(supabaseUrl, forKey: "supabase_url") }
    }
    @Published public var supabaseAnonKey: String {
        didSet { UserDefaults.standard.set(supabaseAnonKey, forKey: "supabase_anon_key") }
    }
    @Published public var voicemails: [Voicemail] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    public init() {
        self.supabaseUrl = UserDefaults.standard.string(forKey: "supabase_url") ?? "https://your-project.supabase.co"
        self.supabaseAnonKey = UserDefaults.standard.string(forKey: "supabase_anon_key") ?? ""
        loadSampleVoicemailsIfEmpty()
    }

    public func fetchVoicemails() async {
        guard !supabaseUrl.isEmpty, !supabaseAnonKey.isEmpty,
              let url = URL(string: "\(supabaseUrl)/rest/v1/voicemails?select=*&order=timestamp.desc") else {
            return
        }

        await MainActor.run { self.isLoading = true; self.errorMessage = nil }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(supabaseAnonKey)", forHTTPHeaderField: "Authorization")
        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let list = try decoder.decode([Voicemail].self, from: data)
                await MainActor.run {
                    self.voicemails = list
                    self.isLoading = false
                }
            } else {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Supabase query returned status code"
                }
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func loadSampleVoicemailsIfEmpty() {
        if voicemails.isEmpty {
            voicemails = [
                Voicemail(
                    phoneNumber: "+918067466720",
                    callerName: "Swiggy Delivery Partner",
                    durationSeconds: 14,
                    audioUrl: nil,
                    timestamp: Date().addingTimeInterval(-3600),
                    isRead: false
                ),
                Voicemail(
                    phoneNumber: "+9118002026161",
                    callerName: "HDFC Bank Central Helpline",
                    durationSeconds: 28,
                    audioUrl: nil,
                    timestamp: Date().addingTimeInterval(-86400),
                    isRead: true
                )
            ]
        }
    }
}
