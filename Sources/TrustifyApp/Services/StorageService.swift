import Foundation
import Combine

public class StorageService: ObservableObject {
    public static let shared = StorageService()

    @Published public var notedNumbers: [NotedNumber] = []
    @Published public var trustedCallers: [UserTrustedCaller] = []

    private let notedNumbersKey = "trustify_noted_numbers"
    private let trustedCallersKey = "trustify_trusted_callers"

    public init() {
        loadData()
    }

    public func loadData() {
        if let data = UserDefaults.standard.data(forKey: notedNumbersKey),
           let items = try? JSONDecoder().decode([NotedNumber].self, from: data) {
            self.notedNumbers = items
        } else {
            // Seed sample noted numbers
            self.notedNumbers = [
                NotedNumber(
                    phoneNumber: "+918067466720",
                    notedValue: "482910",
                    label: "Delivery OTP",
                    createdAt: Date().addingTimeInterval(-7200)
                ),
                NotedNumber(
                    phoneNumber: "+9118002666868",
                    notedValue: "IN849204829",
                    label: "Speed Post Tracking ID",
                    createdAt: Date().addingTimeInterval(-86400 * 2)
                )
            ]
        }

        if let data = UserDefaults.standard.data(forKey: trustedCallersKey),
           let items = try? JSONDecoder().decode([UserTrustedCaller].self, from: data) {
            self.trustedCallers = items
        } else {
            self.trustedCallers = [
                UserTrustedCaller(
                    phoneNumber: "+919429887275",
                    customLabel: "Kokilaben (Family)",
                    notes: "Family direct line"
                )
            ]
        }
    }

    public func addNotedNumber(_ note: NotedNumber) {
        notedNumbers.insert(note, at: 0)
        saveNotedNumbers()
    }

    public func deleteNotedNumber(at offsets: IndexSet) {
        notedNumbers.remove(atOffsets: offsets)
        saveNotedNumbers()
    }

    public func deleteNotedNumber(id: String) {
        notedNumbers.removeAll { $0.id == id }
        saveNotedNumbers()
    }

    private func saveNotedNumbers() {
        if let data = try? JSONEncoder().encode(notedNumbers) {
            UserDefaults.standard.set(data, forKey: notedNumbersKey)
        }
    }

    public func addTrustedCaller(_ caller: UserTrustedCaller) {
        trustedCallers.removeAll { $0.phoneNumber == caller.phoneNumber }
        trustedCallers.insert(caller, at: 0)
        saveTrustedCallers()
    }

    public func deleteTrustedCaller(at offsets: IndexSet) {
        trustedCallers.remove(atOffsets: offsets)
        saveTrustedCallers()
    }

    public func deleteTrustedCaller(phoneNumber: String) {
        trustedCallers.removeAll { $0.phoneNumber == phoneNumber }
        saveTrustedCallers()
    }

    private func saveTrustedCallers() {
        if let data = try? JSONEncoder().encode(trustedCallers) {
            UserDefaults.standard.set(data, forKey: trustedCallersKey)
        }
    }
}

