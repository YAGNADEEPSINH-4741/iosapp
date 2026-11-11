import SwiftUI

@main
struct TrustifyApp: App {
    init() {
        // Run initial CallKit status query on app launch
        CallKitManager.shared.checkStatus()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
    }
}

